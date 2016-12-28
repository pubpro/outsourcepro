#!/usr/bin/python
import tushare as ts
import pandas as pd
import datetime
import time
import math

stock_basic_info = None
purchase_code_list = []
pe_low = 0
pe_up = 50

pb_low = 1
pb_up = 5
outstanding = 10
totals = 150
minturnover = 2
maxturnover = 10

now = None
request_date = None
last_request_date = None
p_diff_rate = 1.5
v_diff_rate = 5
fixedslop = 0.5

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
	del stock_basic_info["rev"]
	del stock_basic_info["profit"]
	del stock_basic_info["gpr"]
	del stock_basic_info["npr"]
	del stock_basic_info["holders"]

# get all A stocks
def get_all_a_stocks():
	global stock_basic_info
	code_list = []
	for code in stock_basic_info.index:
		if code.startswith("600") or code.startswith("601") or code.startswith("00"):
			code_list.append(code)

	stock_basic_info = stock_basic_info[stock_basic_info.index.isin(code_list)]

# filter via basic index pb,pe,outstanding and totals
def basic_filters():
	global stock_basic_info
	#filter by PE
	stock_basic_info = stock_basic_info[stock_basic_info["pe"] > pe_low]
	stock_basic_info = stock_basic_info[stock_basic_info["pe"] < pe_up]
	#filter by PB
	stock_basic_info = stock_basic_info[stock_basic_info["pb"] > pb_low]
	stock_basic_info = stock_basic_info[stock_basic_info["pb"] < pb_up]
	#filter by outstanding and totals
	#stock_basic_info = stock_basic_info[stock_basic_info["outstanding"] > outstanding]
	#stock_basic_info = stock_basic_info[stock_basic_info["totals"] < totals]
	for code in stock_basic_info.index:
		purchase_code_list.append(code)
	del stock_basic_info



def filter_by_avg_price_volume():
	global now, request_date
	ma5 = ma10 = ma20 = vma5 =  vma10 = vma20 = 0.0
	market_value = 0.0
	turnover = 0.0
	tm_wday = time.localtime(time.time()).tm_wday
	tm_hour = time.localtime(time.time()).tm_hour
	if tm_hour < 18:
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
		stock = ts.get_hist_data(purchase_code_list[i],start = request_date, end = request_date)
		try:
			ma5 = stock["ma5"][0]
			ma10 = stock["ma10"][0]
			ma20 = stock["ma20"][0]
			vma5 = stock["v_ma5"][0]
			vma10 = stock["v_ma10"][0]
			vma20 = stock["v_ma20"][0]
			turnover = stock["turnover"][0]
			close = stock["close"][0]
			volume = stock["volume"][0]
		except Exception as e:
			del purchase_code_list[i]
			continue
		else:
			if turnover < minturnover or turnover > maxturnover :
				del purchase_code_list[i]
				continue
			#if ma5 >= ma10 and ma10 >= ma20 and vma5 >= vma10 and vma10 >= vma20:
			#print ma5,ma10,ma20,math.fabs(ma5-ma10)/ma10*100,math.fabs(ma10-ma20)/ma20*100
			#break
			if (math.fabs(ma5-ma10)/ma5*100 < p_diff_rate) or (math.fabs(ma10-ma20)/ma10*100 < p_diff_rate):	
				pass
			else:
				del purchase_code_list[i]
				continue

			if ma10 > close or ma20 > close:
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
			
			
			# filter by market value
			market_value = stock_basic_info.reindex([purchase_code_list[i]])["totals"][0] * close
			if market_value > totals:
				del purchase_code_list[i]
				continue
			"""
			
		i += 1


def filter_by_slope():
	global now, last_request_date, request_date
	two_day_before = datetime.timedelta(days=2)
	two_day_before_date = now - two_day_before
	weekday = two_day_before_date.weekday()
	if weekday == 5:
		delta = datetime.timedelta(days=-1)
		last_date = two_day_before_date + delta
		last_request_date = last_date.strftime("%Y-%m-%d")
	elif weekday == 6:
		delta = datetime.timedelta(days=-2)
		last_date = two_day_before_date + delta
		last_request_date = last_date.strftime("%Y-%m-%d")		
	else:
		last_request_date = two_day_before_date.strftime("%Y-%m-%d")
	i = 0
	while i < len(purchase_code_list):
		last_stock = ts.get_hist_data(purchase_code_list[i],start = last_request_date, end = last_request_date)
		last_ma5 = last_stock["ma5"][0]
		last_ma10 = last_stock["ma10"][0]
		curr_stock = ts.get_hist_data(purchase_code_list[i],start = request_date, end = request_date)
		curr_ma5 = curr_stock["ma5"][0]
		curr_ma10 = curr_stock["ma10"][0]
		if ((curr_ma5 - last_ma5)/last_ma5*100) > fixedslop or ((curr_ma10 - last_ma10)/last_ma5*100) > fixedslop:
			pass
		else:
			del purchase_code_list[i]
			continue
		i += 1





get_stock_basic_info()
drop_unused_columns()
#print stock_basic_info
get_all_a_stocks()
basic_filters()
filter_by_avg_price_volume()
filter_by_slope()
print purchase_code_list






