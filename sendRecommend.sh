#!/bin/bash

# retrieve latest data
cd /opt/outsourcepro/
# get realtime data
echo "sync basic data ..."
python db_sync.py


echo "retrieve new low price stock ..."
python db_newlow.py

# calculate latest result
echo "calculate latest result ..."
mysql -uroot -D tushare -pAbcd1234 -e 'call GetFinalResult(20183);'

echo "send mail ..."

echo "=====================获取新低票===============================">Stock_Recommend.txt
mysql -uroot -D tushare -pAbcd1234 -e "select t1.code, t1.name from RESULT_RECOMMEND as t1 inner join new_lowprice as t2 on t1.code = t2.code"  >>Stock_Recommend.txt


#echo "====================短线强势票=============================">>Stock_Recommend.txt
#mysql -uroot -D tushare -pAbcd1234 -e "SELECT CODE,NAME,DATE,NET,VOL FROM FENGTOU_RECOMMEND ORDER BY CODE, DATE" >>Stock_Recommend.txt

sed 's/\t/,/g' Stock_Recommend.txt | mail -s "Stock Recommend" 519718645@qq.com
