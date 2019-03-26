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
mysql -uroot -D tushare -pAbcd1234 -e 'call GetFinalResult(20184);'

echo "send mail ..."


echo "====================短线龙头票=============================">>Stock_Recommend.txt
mysql -uroot -D tushare -pAbcd1234 -e "select t1.code,t1.name,t1.industry,t2.c_name,t1.score from RESULT_RECOMMEND as t1 inner join concept_data as t2 on t1.code = t2.code order by t2.c_name, t1.score desc" >>Stock_Recommend.txt

sed 's/\t/,/g' Stock_Recommend.txt | mail -s "Stock Recommend" 519718645@qq.com
