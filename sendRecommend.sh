#!/bin/bash

# retrieve latest data
cd ~/project/outsourcepro/
# get realtime data
python db_sync.py
python db_realtime_data.py
# calculate latest result
mysql -uroot -D tushare -pAbcd1234 -e 'call GetFinalResult(20181);'

mysql -uroot -D tushare -pAbcd1234 -e "SELECT t1.CODE,t1.NAME, t1.INDUSTRY,SCORE FROM RESULT_RECOMMEND as t1 inner join realtime_price as t2 on t1.code = t2.code order by score desc" >Stock_Recommend2.txt

cat Stock_Recommend2.txt | mail -s "Stock Recommend" 519718645@qq.com

