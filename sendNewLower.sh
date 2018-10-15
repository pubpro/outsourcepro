#!/bin/bash

# retrieve latest data
cd ~/project/outsourcepro/

echo "retrieve realtime data ..."
python db_realtime_data.py

echo "=====================获取价值投资票===============================">Stock_Recommend.txt
mysql -uroot -D tushare -pAbcd1234 -e "SELECT CODE,NAME,DATE,NET,VOL, SCORE FROM JIATOU_RECOMMEND ORDER BY CODE, DATE" >>Stock_Recommend.txt

#echo "====================短线强势票=============================">>Stock_Recommend.txt
#mysql -uroot -D tushare -pAbcd1234 -e "SELECT CODE,NAME,DATE,NET,VOL FROM FENGTOU_RECOMMEND ORDER BY CODE, DATE" >>Stock_Recommend.txt

sed 's/\t/,/g' Stock_Recommend.txt | mail -s "Stock Recommend" 915029350@qq.com 519718645@qq.com
