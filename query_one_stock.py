#!/usr/bin/python

import tushare as ts
#import sys

#reload(sys)

#sys.setdefaultencoding('utf-8')
stock_code = "000413"

stocks = ts.get_stock_basics()
hist = ts.get_hist_data(stock_code,start="2016-12-29")

stock = stocks.reindex([stock_code])

del stock["name"]
del stock["industry"]
del stock["area"]
del stock["totalAssets"]
del stock["liquidAssets"]
del stock["fixedAssets"]
del stock["reserved"]
#del stock["reservedPerShare"]
del stock["esp"]
del stock["bvps"]
del stock["timeToMarket"]
del stock["undp"]
#del stock["perundp"]
del stock["rev"]
#del stock["profit"]
#del stock["gpr"]
#del stock["npr"]
del stock["holders"]

cash_flows = ts.get_cashflow_data(2016,3)
del cash_flows["name"]
cf = cash_flows[cash_flows["code"] == stock_code]
print stock
print cf
#cash_flows.to_csv("/root/share/cash_flows.csv")