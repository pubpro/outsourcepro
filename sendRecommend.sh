#!/bin/bash

# retrieve latest data
cd ~/project/outsourcepro/
# get realtime data
python db_sync.py
python db_realtime_data.py
# calculate latest result
mysql -uroot -D tushare -pAbcd1234 -e 'call GetFinalResult(20181);'

echo "======================游资买入票=================================" >Stock_Recommend.txt
mysql -uroot -D tushare -pAbcd1234 -e "SELECT t1.CODE,t1.NAME, t1.INDUSTRY,t1.SCORE,t3.net FROM RESULT_RECOMMEND as t1 inner join realtime_price as t2 on t1.code = t2.code inner join cap_tops as t3 on t1.code = t3.code where t3.net > 0 order by t1.score desc" >>Stock_Recommend.txt
echo "======================游资卖出票=================================" >>Stock_Recommend.txt
mysql -uroot -D tushare -pAbcd1234 -e "SELECT t1.CODE,t1.NAME, t1.INDUSTRY,t1.SCORE,t3.net FROM RESULT_RECOMMEND as t1 inner join realtime_price as t2 on t1.code = t2.code inner join cap_tops as t3 on t1.code = t3.code where t3.net < 0 order by t1.score desc" >>Stock_Recommend.txt


echo "======================机构买入票=================================" >>Stock_Recommend.txt
mysql -uroot -D tushare -pAbcd1234 -e "SELECT t1.CODE,t1.NAME, t1.INDUSTRY,t1.SCORE,t3.net FROM RESULT_RECOMMEND as t1 inner join realtime_price as t2 on t1.code = t2.code inner join inst_tops as t3 on t1.code = t3.code where t3.net > 0 order by t1.score desc" >>Stock_Recommend.txt
echo "======================机构卖出票=================================" >>Stock_Recommend.txt
mysql -uroot -D tushare -pAbcd1234 -e "SELECT t1.CODE,t1.NAME, t1.INDUSTRY,t1.SCORE,t3.net FROM RESULT_RECOMMEND as t1 inner join realtime_price as t2 on t1.code = t2.code inner join inst_tops as t3 on t1.code = t3.code where t3.net < 0 order by t1.score desc" >>Stock_Recommend.txt

sed 's/\t/,/g' Stock_Recommend.txt | mail -s "Stock Recommend" 519718645@qq.com

