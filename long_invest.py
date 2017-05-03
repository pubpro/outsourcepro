#!/usr/bin/python
import tushare as ts
import pandas as pd
import datetime
import time
import math

stock_basic_info = None
stock_hist_info = pd.DataFrame()
purchase_code_list = []
pe_low = 1 #price earning ratio
pe_up = 20 #
gpr = 0 #gross profit ratio
npr = 15 #net profit ratio
rev = 0 #revenue increase ratio
profit = 0 #profit increase ratio

pb_low = 1 #price book value
pb_up = 3 #
outstanding = 10 #
totals = 200 #total stock value

now = None
request_date = ''
last_request_date = None
p_diff_rate = 0 #price change slope
v_diff_rate = 0 #volumn change slope
fixedslop = 0.0 #fix slope

# get all stocks code and basic info
def get_stock_basic_info():
	global stock_basic_info
	stock_basic_info = ts.get_stock_basics()

def drop_unused_columns():
	global stock_basic_info
	del stock_basic_info["name"]
	del stock_basic_info["industry"]
	del stock_basic_info["area"]
	del stock_basic_info["totalAssets"]
	del stock_basic_info["liquidAssets"]
	del stock_basic_info["fixedAssets"]
	del stock_basic_info["reserved"]
	del stock_basic_info["reservedPerShare"]
	del stock_basic_info["esp"]
	del stock_basic_info["bvps"]
	del stock_basic_info["timeToMarket"]
	del stock_basic_info["undp"]
	del stock_basic_info["perundp"]
	#del stock_basic_info["rev"]
	#del stock_basic_info["profit"]
	#del stock_basic_info["gpr"]
	#del stock_basic_info["npr"]
	del stock_basic_info["holders"]

# get all A stocks
def get_all_a_stocks():
	global stock_basic_info
	code_list = []
	for code in stock_basic_info.index:
		if code.startswith("600") or code.startswith("601") or code.startswith("603") or code.startswith("00"):
			code_list.append(code)

	stock_basic_info = stock_basic_info[stock_basic_info.index.isin(code_list)]

# filter via basic index pb,pe,outstanding and totals
def basic_filters():
	global stock_basic_info
	#filter by PE
	stock_basic_info = stock_basic_info[stock_basic_info["pe"] >= pe_low]
	stock_basic_info = stock_basic_info[stock_basic_info["pe"] <= pe_up]
	#filter by PB
	stock_basic_info = stock_basic_info[stock_basic_info["pb"] >= pb_low]
	stock_basic_info = stock_basic_info[stock_basic_info["pb"] <= pb_up]
	stock_basic_info = stock_basic_info[stock_basic_info["rev"] >= rev]
	stock_basic_info = stock_basic_info[stock_basic_info["profit"] >= profit]
	stock_basic_info = stock_basic_info[stock_basic_info["gpr"] >= gpr]
	stock_basic_info = stock_basic_info[stock_basic_info["npr"] >= npr]
	#filter by outstanding and totals
	#stock_basic_info = stock_basic_info[stock_basic_info["outstanding"] > outstanding]
	#stock_basic_info = stock_basic_info[stock_basic_info["totals"] < totals]
	for code in stock_basic_info.index:
		purchase_code_list.append(code)



def filter_by_avg_price_volume():
	global now, request_date, stock_hist_info
	ma5 = ma10 = ma20 = vma5 =  vma10 = vma20 = 0.0
	market_value = 0.0
	tm_wday = time.localtime(time.time()).tm_wday
	tm_hour = time.localtime(time.time()).tm_hour
	if tm_hour < 16:
		today = datetime.date.today()
		oneday = datetime.timedelta(days=1)
		now = today - oneday
	else:
		now = datetime.date.today()
	if tm_wday == 5:
		delta = datetime.timedelta(days=-1)
		last_date = now + delta
		request_date = last_date.strftime("%Y-%m-%d")
	elif tm_wday == 6:
		delta = datetime.timedelta(days=-2)
		last_date = now + delta
		request_date = last_date.strftime("%Y-%m-%d")		
	else:
		request_date = now.strftime("%Y-%m-%d")
	
	i = 0
	#request_date = "2016-12-27"	
	while i < len(purchase_code_list):
		stock = ts.get_hist_data(purchase_code_list[i],start = request_date, end = request_date,ktype='D')
		try:
			ma5 = stock["ma5"][0]
			ma10 = stock["ma10"][0]
			ma20 = stock["ma20"][0]
			vma5 = stock["v_ma5"][0]
			vma10 = stock["v_ma10"][0]
			vma20 = stock["v_ma20"][0]
			close = stock["close"][0]
			volume = stock["volume"][0]
		except Exception as e:
			del purchase_code_list[i]
			continue
		else:
			#if ma5 >= ma10 and ma10 >= ma20 and vma5 >= vma10 and vma10 >= vma20:
			#print ma5,ma10,ma20,math.fabs(ma5-ma10)/ma10*100,math.fabs(ma10-ma20)/ma20*100
			#break
			"""
			if (math.fabs(ma5-ma10)/ma5*100 < p_diff_rate):	
				pass
			else:
				del purchase_code_list[i]
				continue
			"""
			
			if ma5 >= ma20:
				pass
			else:
				del purchase_code_list[i]
				continue
			

			"""
			if (math.fabs(vma5-vma10)/vma10 < v_diff_rate) or (math.fabs(vma10-vma20)/vma20 < v_diff_rate):	
				pass
			else:
				del purchase_code_list[i]
				continue
			
			"""
			
			#filter by market value
			market_value = stock_basic_info.reindex([purchase_code_list[i]])["totals"][0] * close
			if market_value > totals:
				del purchase_code_list[i]
				continue
				
		#stock_hist_info.append(stock)
		#print i
		i += 1


def filter_by_slope():
	global now, last_request_date, request_date
	yesterday = datetime.timedelta(days=14)
	yesterday_date = now - yesterday
	weekday = yesterday_date.weekday()
	if weekday == 5:
		delta = datetime.timedelta(days=-1)
		last_date = yesterday_date + delta
		last_request_date = last_date.strftime("%Y-%m-%d")
	elif weekday == 6:
		delta = datetime.timedelta(days=-2)
		last_date = yesterday_date + delta
		last_request_date = last_date.strftime("%Y-%m-%d")		
	else:
		last_request_date = yesterday_date.strftime("%Y-%m-%d")
	i = 0
	while i < len(purchase_code_list):
		last_stock = ts.get_hist_data(purchase_code_list[i],start = last_request_date, end = last_request_date, ktype='D')
		last_ma5 = last_stock["ma5"][0]
		last_ma10 = last_stock["ma10"][0]
		last_ma20 = last_stock["ma20"][0]
		curr_stock = ts.get_hist_data(purchase_code_list[i],start = request_date, end = request_date, ktype='D')
		curr_ma5 = curr_stock["ma5"][0]
		curr_ma10 = curr_stock["ma10"][0]
		curr_ma20 = curr_stock["ma20"][0]
		#  
		if ((curr_ma5 - last_ma5)/last_ma5*100) > fixedslop:
			pass
		else:
			del purchase_code_list[i]
			continue
		#
		if last_ma5 < last_ma20:
			pass
		else:
			del purchase_code_list[i]
			continue

		i += 1


def print_details():
	global stock_basic_info
	i = 0
	while i < len(purchase_code_list):
		stock = stock_basic_info.reindex([purchase_code_list[i]])
		print stock
		i += 1


get_stock_basic_info()
drop_unused_columns()
#print stock_basic_info
get_all_a_stocks()
basic_filters()
filter_by_avg_price_volume()
filter_by_slope()
print_details()






