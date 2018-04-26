#!/bin/bash

# retrieve latest data
cd ~/outsourcepro/

python getrealtimequotes.py
if [[ $? -ne 0 ]];then
	python getrealtimequotes.py | mail -s "Stock Warning" gl.zhou@artisantechnologies.cn
fi

