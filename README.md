# 每只股票
--代码
--行业
--市盈率 = 当前股价 / 每股收益  --越小越好
--市净率 = 当前股价 / 每股净资产  --越小越好
--净利率 = 净利润 / 主营业务收入* 100%  --越大越好
--每股净资产 =  股东权益 / 总股数 --越大越好
--毛利率 = （主营业务收入-主营业务成本）/ 主营业务收入×100% --越大越好
--每股主营业务收入 = 主营业务收入 / 总股数 --越大越好
--应收帐款周转率 = （当期销售净收入 - 当期现销收入） / （（期初应收账款余额 + 期末应收账款余额）/ 2） --越大越好
--存货周转率 = 营业收入 / （（期初存货+期末存货）/ 2） --越大越好
--流动资产周转率 = （主营业务收入 - 销售折扣 - 销售折让） / （（流动资产年初数+流动资产年末数）/ 2） --越大越好
--主营业务收入增长率 = （本期主营业务收入-上期主营业务收入） / 上期主营业务收入 * 100%  --越大越好
--净利润增长率  = （本期净利润 - 上期净利润） / 上期净利润 * 100% --越大越好
--净资产增长率 = （本期净资产 - 上期净资产） / 上期净资产 * 100% --越大越好
--总资产增长率 = （本期总资产 - 上期总资产） / 上期总资产 * 100% --越大越好
--每股收益增长率 = （本期每股收益 - 上期每股收益） / 上期每股收益 * 100% --越大越好
--股东权益增长率 = （本期股东权益 - 上期股东权益） / 上期股东权益 * 100% --越大越好
--流动比率 = 流动资产 / 流动负债  --越大越好
--速动比率 = 速动资产 / 流动负债  --越大越好
--现金比率 = （货币资金 + 交易性金融资产） / 流动负债  --越大越好
--利息支付倍数 = 营业利润支付债息的能力 = 税前净利 / 期间利息费用  --越大越好
--股东权益比率 = 股东权益 / 总资产 * 100%   --越大越好
--经营现金净流量对销售收入比率 = 经营活动现金净流量 / 主营业务收入 * 100%  --越大越好
--资产的经营现金流量回报率 = 经营活动现金净流量 / 总资产 * 100%  --越大越好
--经营现金净流量对负债比率 = 经营活动现金净流量 / 总负债 * 100%  --越大越好
--现金流量比率 = 企业经营活动所产生的现金流量可以抵偿流动负债的程度 = 经营活动现金净流量 / 流动负债 * 100%  --越大越好
--每股收益 = 净利润 / 总股本  --越大越好
--净资产收益率 = 权益报酬率 = 净利润 / 所有者权益  --越大越好





其他关键字：
--净利润 = （（营业收入－营业成本－营业税金及附加－期间费用－资产减值损失 + 公允价值变动收益－公允价值变动损失 + 投资净收益）- 所得税费用）
--净资产 = 总资产 - 总负债
--股东权益 = 净资产 - 少数股东权益
--速动资产 = 货币资金 + 短期投资 + 应收票据 + 应收账款 + 及其他应收款
--货币资金 = 库存现金 + 银行存款 + 其他货币资金
--交易性金融资产 = 债券投资 + 股票投资 + 基金投资




程序运行次序：
# change year, season, quater value and then run
db_sync.py  --python db_sync.py

# replace 20172 with current season
call GetFinalResult(20181); --this procedure invoke below procedures in order

getbasicavg.sql  --CALL GetBasicAvg();
getreportavg.sql  --CALL GetReportAvg();
getprofitavg.sql  --CALL GetProfitAvg();
getoperationavg.sql  --CALL GetOperationAvg();
getgrowthavg.sql  --CALL GetGrowthAvg();
getdebtpayavg.sql --CALL GetDebtpayAvg();
getcashflowavg.sql  --CALL GetCashflowAvg();
getallindexavg.sql  --CALL GetAllIndexAvg();
getallstockindex.sql  --CALL GetAllStockIndex();

SELECT T1.CODE, T1.INDUSTRY,T1.PRICE,T2.PRICE AS AVG_PRICE,T1.PE,T2.PE AS AVG_PE, T1.PB, T2.PB AS AVG_PB,T1.EPS, T2.EPS AS AVG_EPS FROM RESULT_ALLSTOCKINDEX AS T1
INNER JOIN RESULT_ALLINDEX_AVG AS T2
ON T1.INDUSTRY = T2.INDUSTRY
WHERE 1 = 1
AND T1.GPR >= T2.GPR
AND T1.BIPS >= T2.BIPS
AND T1.ARTURNOVER >= T2.ARTURNOVER / 2
AND T1.MBRG >= T2.MBRG / 2
AND T1.EPSG >= T2.EPSG / 2
AND T1.CURRENTRATIO >= T2.CURRENTRATIO / 2
AND T1.SHEQRATIO >= T2.SHEQRATIO
AND T1.EPS >= T2.EPS
AND T1.PRICE <= (T2.PRICE / 1.5)
ORDER BY T1.INDUSTRY




# 部署一下作业自动发送邮件
30 22 * * * sh /root/outsourcepro/sendmail.sh
*/1 9-12 * * 1-5 sh /root/outsourcepro/sendwarning.sh
*/1 13-15 * * 1-5 sh /root/outsourcepro/sendwarning.sh

