#!/bin/bash

# retrieve latest data
cd ~/project/outsourcepro/

# get latest news
python get_dynamic_news.py
mysql -utushare -Dtushare -pAbcd1234 -e "SELECT title,time FROM DYNAMIC_NEWS where classify = '证券'" >Latest_News.txt

cat Latest_News.txt | mail -s "Latest News" 519718645@qq.com
