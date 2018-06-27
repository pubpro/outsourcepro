#!/bin/bash

# retrieve latest data
cd ~/project/outsourcepro/

python getrealtimequotes.py
if [[ $? -ne 0 ]];then
	python getrealtimequotes.py | mail -s "Stock Warning" 519718645@qq.com
fi

