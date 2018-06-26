#!/bin/bash

# retrieve latest data
cd ~/outsourcepro/
python db_sync.py
# calculate latest result
mysql -uroot -D tushare -pAbcd1234 -e 'call GetFinalResult(20174);'

mysql -uroot -D tushare -pAbcd1234 -e "SELECT CODE,NAME, INDUSTRY,round(1000/PRICE + 10 * GPR + 30 * BIPS + 10 * SHEQRATIO + 5 * CASHFLOWRATIO + 6 * if(MBRG>100,MBRG/10,MBRG) + 6 * if(EPSG>100,EPSG/10,EPSG) + 5 * if(SEG>100,SEG/10,SEG)) AS SCORE,round(PE),round(PRICE),round(GPR),round(BIPS),round(SHEQRATIO),CASHFLOWRATIO,MBRG,EPSG,SEG FROM RESULT_ALLSTOCKINDEX WHERE round(PE) > 0 and round(PE) < 70 AND CODE NOT LIKE '3%' AND CASHFLOWRATIO > 0 AND round(BIPS) > 0 AND MBRG > 0 AND EPSG > 0 AND SEG > 0 ORDER BY SCORE DESC, round(PE), round(PRICE) limit 0,69;" >Stock_Recommend2.txt

cat Stock_Recommend2.txt | mail -s "Stock Recommend 2" 519718645@qq.com

# get latest news
python get_dynamic_news.py
mysql -uroot -D tushare -pAbcd1234 -e "SELECT title,time FROM DYNAMIC_NEWS where classify = '证券'" >Latest_News.txt

cat Latest_News.txt | mail -s "Latest News" 519718645@qq.com
