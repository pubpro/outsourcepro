#!/bin/bash

# retrieve latest data
cd ~/outsourcepro/
python db_sync.py
# calculate latest result
mysql -uroot -D tushare -pAbcd1234 -e 'call GetFinalResult(20174);'
#mysql -uroot -D tushare -pAbcd1234 -e 'SELECT T1.CODE, T1.INDUSTRY,T1.PRICE,T2.PRICE AS AVG_PRICE FROM RESULT_ALLSTOCKINDEX AS T1 INNER JOIN RESULT_ALLINDEX_AVG AS T2 ON T1.INDUSTRY = T2.INDUSTRY WHERE 1 = 1 AND T1.GPR >= T2.GPR AND T1.BIPS >= T2.BIPS AND T1.ARTURNOVER >= T2.ARTURNOVER / 2 AND T1.MBRG >= T2.MBRG / 2 AND T1.EPSG >= T2.EPSG / 2 AND T1.CURRENTRATIO >= T2.CURRENTRATIO / 2 AND T1.SHEQRATIO >= T2.SHEQRATIO AND T1.EPS >= T2.EPS AND T1.PRICE <= (T2.PRICE / 1.5) ORDER BY T1.INDUSTRY;' >Stock_Recommend1.txt

mysql -uroot -D tushare -pAbcd1234 -e "SELECT CODE,NAME, INDUSTRY,round(1000/PRICE + 10 * GPR + 50 * BIPS + 10 * SHEQRATIO + 5 * CASHFLOWRATIO + 5 * if(MBRG>100,MBRG/10,MBRG) + 5 * if(EPSG>100,EPSG/10,EPSG) + 5 * if(SEG>100,SEG/10,SEG)) AS SCORE,round(PE),round(PRICE),round(GPR),round(BIPS),round(SHEQRATIO),CASHFLOWRATIO,MBRG,EPSG,SEG FROM RESULT_ALLSTOCKINDEX WHERE round(PE) > 0 and round(PE) < 70 AND CODE NOT LIKE '3%' AND CASHFLOWRATIO > 0 AND round(BIPS) > 0 AND MBRG > 0 AND EPSG > 0 AND SEG > 0 ORDER BY SCORE DESC, round(PE), round(PRICE) limit 0,60;" >Stock_Recommend2.txt

cat Stock_Recommend1.txt | mail -s "Stock Recommend 1" gl.zhou@artisantechnologies.cn
cat Stock_Recommend2.txt | mail -s "Stock Recommend 2" gl.zhou@artisantechnologies.cn

# get latest news
python get_dynamic_news.py
mysql -uroot -D tushare -pAbcd1234 -e "SELECT title,time FROM DYNAMIC_NEWS where classify = '证券'" >Latest_News.txt

cat Latest_News.txt | mail -s "Latest News" gl.zhou@artisantechnologies.cn
