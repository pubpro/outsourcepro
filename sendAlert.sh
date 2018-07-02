#!/bin/bash

# retrieve latest data
cd ~/project/outsourcepro/

# find stock escape
mysql -uroot -D tushare -pAbcd1234 -e "SELECT t1.CODE,t1.NAME from TARGET_PRICE as t1 inner join cap_tops as t2 on t1.code = t2.code where t2.net < 0" >Stock_Alerts.txt
mysql -uroot -D tushare -pAbcd1234 -e "SELECT t1.CODE,t1.NAME from TARGET_PRICE as t1 inner join inst_tops as t2 on t1.code = t2.code where t2.net < 0" >>Stock_Alerts.txt
python getrealtimequotes.py>>Stock_Alerts.txt
if [ -s ./Stock_Alerts.txt ]; then
	sed 's/\t/,/g' Stock_Alerts.txt | mail -s "Stock Alerts" 519718645@qq.com
fi



