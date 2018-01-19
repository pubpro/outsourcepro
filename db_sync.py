#coding:utf-8
from sqlalchemy import create_engine
import tushare as ts


lastYear = 2017
lastSeason = 2
quater=lastQuater = 20172
currentYear = 2017
currentSeason = 3
quater=currentQuater = 20173


# define engine
engine = create_engine('mysql://tushare:Abcd1234@127.0.0.1/tushare?charset=utf8')

# =================================================industry data=================================================
# import industry data
#code：股票代码
#name：股票名称
#c_name：行业名称
#df = ts.get_industry_classified()
#df.to_sql('industry_data',engine, if_exists='replace')


# =================================================bonus data=================================================
# import bonus data
#code:股票代码
#name:股票名称
#year:分配年份
#report_date:公布日期
#divi:分红金额（每10股）
#shares:转增和送股数（每10股）
df = ts.profit_data(year=lastYear,top=1000)
df.to_sql('bonus_data',engine, if_exists='replace')


# =================================================company data==================================================
# import basic data
#code,代码
#name,名称
#industry,所属行业
#area,地区
#pe,市盈率
#outstanding,流通股本(亿)
#totals,总股本(亿)
#totalAssets,总资产(万)
#liquidAssets,流动资产
#fixedAssets,固定资产
#reserved,公积金
#reservedPerShare,每股公积金
#esp,每股收益
#bvps,每股净资
#pb,市净率
#timeToMarket,上市日期
#undp,未分利润
#perundp, 每股未分配
#rev,收入同比(%)
#profit,利润同比(%)
#gpr,毛利率(%)
#npr,净利润率(%)
#holders,股东人数
df = ts.get_stock_basics()
df.to_sql('basic_info',engine, if_exists='replace')

# import report data
#code,代码
#name,名称
#esp,每股收益
#eps_yoy,每股收益同比(%)
#bvps,每股净资产
#roe,净资产收益率(%)
#epcf,每股现金流量(元)
#net_profits,净利润(万元)
#profits_yoy,净利润同比(%)
#distrib,分配方案
#report_date,发布日期
df = ts.get_report_data(lastYear,lastSeason)
df = df.assign(quater=lastQuater)
df.to_sql('report_data',engine, if_exists='replace')
df = ts.get_report_data(currentYear,currentSeason)
df = df.assign(quater=currentQuater)
df.to_sql('report_data',engine, if_exists='append')

# import profit data
#code,代码
#name,名称
#roe,净资产收益率(%)
#net_profit_ratio,净利率(%)
#gross_profit_rate,毛利率(%)
#net_profits,净利润(万元)
#esp,每股收益
#business_income,营业收入(百万元)
#bips,每股主营业务收入(元)
df = ts.get_profit_data(lastYear,lastSeason)
df = df.assign(quater=lastQuater)
df.to_sql('profit_data',engine, if_exists='replace')
df = ts.get_profit_data(currentYear,currentSeason)
df = df.assign(quater=currentQuater)
df.to_sql('profit_data',engine, if_exists='append')




# import operation data
#code,代码
#name,名称
#arturnover,应收账款周转率(次)
#arturndays,应收账款周转天数(天)
#inventory_turnover,存货周转率(次)
#inventory_days,存货周转天数(天)
#currentasset_turnover,流动资产周转率(次)
#currentasset_days,流动资产周转天数(天)
df = ts.get_operation_data(lastYear,lastSeason)
df = df.assign(quater=lastQuater)
df.to_sql('operation_data',engine, if_exists='replace')
df = ts.get_operation_data(currentYear,currentSeason)
df = df.assign(quater=currentQuater)
df.to_sql('operation_data',engine, if_exists='append')



# import growth data
#code,代码
#name,名称
#mbrg,主营业务收入增长率(%)
#nprg,净利润增长率(%)
#nav,净资产增长率
#targ,总资产增长率
#epsg,每股收益增长率
#seg,股东权益增长率
df = ts.get_growth_data(lastYear,lastSeason)
df = df.assign(quater=lastQuater)
df.to_sql('growth_data',engine, if_exists='replace')
df = ts.get_growth_data(currentYear,currentSeason)
df = df.assign(quater=currentQuater)
df.to_sql('growth_data',engine, if_exists='append')



# import debt pay data
#code,代码
#name,名称
#currentratio,流动比率
#quickratio,速动比率
#cashratio,现金比率
#icratio,利息支付倍数
#sheqratio,股东权益比率
#adratio,股东权益增长率
df = ts.get_debtpaying_data(lastYear,lastSeason)
df = df.assign(quater=lastQuater)
df.to_sql('debtpay_data',engine, if_exists='replace')
df = ts.get_debtpaying_data(currentYear,currentSeason)
df = df.assign(quater=currentQuater)
df.to_sql('debtpay_data',engine, if_exists='append')



# import cashflow data
#code,代码
#name,名称
#cf_sales,经营现金净流量对销售收入比率
#rateofreturn,资产的经营现金流量回报率
#cf_nm,经营现金净流量与净利润的比率
#cf_liabilities,经营现金净流量对负债比率
#cashflowratio,现金流量比率
df = ts.get_cashflow_data(lastYear,lastSeason)
df = df.assign(quater=lastQuater)
df.to_sql('cashflow_data',engine, if_exists='replace')
df = ts.get_cashflow_data(currentYear,currentSeason)
df = df.assign(quater=currentQuater)
df.to_sql('cashflow_data',engine, if_exists='append')


