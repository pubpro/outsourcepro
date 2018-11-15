# 每只股票
- 代码
- 行业
- 市盈率(PE) = 当前股价 / 每股收益  --越小越好
- 市净率(PB) = 当前股价 / 每股净资产  --越小越好
- 净利率(NPR) = 净利润 / 主营业务收入* 100%  --越大越好
- 每股净资产 =  股东权益 / 总股数 --越大越好
- 毛利率(GPR) = （主营业务收入-主营业务成本）/ 主营业务收入×100% --越大越好
- 每股主营业务收入(BIPS) = 主营业务收入 / 总股数 --越大越好
- 应收帐款周转率(ARTURNOVER) = （当期销售净收入 - 当期现销收入） / （（期初应收账款余额 + 期末应收账款余额）/ 2） --越大越好
- 存货周转率(INVENTORY_TURNOVER) = 营业收入 / （（期初存货+期末存货）/ 2） --越大越好
- 流动资产周转率(CURRENTASSET)TURNOVER) = （主营业务收入 - 销售折扣 - 销售折让） / （（流动资产年初数+流动资产年末数）/ 2） --越大越好
- 主营业务收入增长率(MBRG) = （本期主营业务收入-上期主营业务收入） / 上期主营业务收入 * 100%  --越大越好
- 净利润增长率(NPRG)  = （本期净利润 - 上期净利润） / 上期净利润 * 100% --越大越好
- 净资产增长率(NAV) = （本期净资产 - 上期净资产） / 上期净资产 * 100% --越大越好
- 总资产增长率(TARG) = （本期总资产 - 上期总资产） / 上期总资产 * 100% --越大越好
- 每股收益增长率(EPSG) = （本期每股收益 - 上期每股收益） / 上期每股收益 * 100% --越大越好
- 股东权益增长率(SEG) = （本期股东权益 - 上期股东权益） / 上期股东权益 * 100% --越大越好
- 流动比率(CURRENTRATIO) = 流动资产 / 流动负债  --越大越好
- 速动比率(QUICKRATIO) = 速动资产 / 流动负债  --越大越好
- 现金比率(CASHRATIO) = （货币资金 + 交易性金融资产） / 流动负债  --越大越好
- 股东权益比率(ICRATIO) = 股东权益 / 总资产 * 100%   --越大越好
- 经营现金净流量对销售收入比率(CF_SALES) = 经营活动现金净流量 / 主营业务收入 * 100%  --越大越好
- 资产的经营现金流量回报率(RATEOFRETURN) = 经营活动现金净流量 / 总资产 * 100%  --越大越好
- 经营现金净流量对负债比率(CF_LIABILITIES) = 经营活动现金净流量 / 总负债 * 100%  --越大越好
- 现金流量比率(CASHFLOWRATIO) = 企业经营活动所产生的现金流量可以抵偿流动负债的程度 = 经营活动现金净流量 / 流动负债 * 100%  --越大越好
- 每股收益(EPS) = 净利润 / 总股本  --越大越好
- 净资产收益率(ROE) = 权益报酬率 = 净利润 / 所有者权益  --越大越好

## 其他关键字：
- 净利润 = （（营业收入－营业成本－营业税金及附加－期间费用－资产减值损失 + 公允价值变动收益－公允价值变动损失 + 投资净收益）- 所得税费用）
- 净资产 = 总资产 - 总负债
- 股东权益 = 净资产 - 少数股东权益
- 速动资产 = 货币资金 + 短期投资 + 应收票据 + 应收账款 + 及其他应收款
- 货币资金 = 库存现金 + 银行存款 + 其他货币资金
- 交易性金融资产 = 债券投资 + 股票投资 + 基金投资




# 程序运行次序：
```
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


# CREATE TABLE JIATOU_RECOMMEND AS SELECT t1.CODE,t1.NAME, t1.INDUSTRY, date_format(now(),'%y-%m-%d') as DATE, t1.SCORE,t3.net as NET,t3.net/t2.trade * 100 as VOL FROM RESULT_RECOMMEND as t1 inner join realtime_price as t2 on t1.code = t2.code inner join cap_tops as t3 on t1.code = t3.code;

# CREATE TABLE FENGTOU_RECOMMEND AS select t1.code, t1.name, date_format(now(),'%y-%m-%d') as DATE, t2.net, t2.net/t1.trade * 100 as VOL from realtime_price as t1 inner join cap_tops as t2 on t1.code = t2.code;

# create table to hold your stocks
# create table TARGET_PRICE (CODE VARCHAR(6) PRIMARY KEY, NAME VARCHAR(24),PURCHASE_PRICE DOUBLE, BASE_PRICE DOUBLE);
# insert into TARGET_PRICE values ('000637','茂化实华',4.97,5.08);

# create table to hold new low price stock
create table new_lowprice (code varchar(6), primary key(code))


# 配置邮箱
vim /etc/mail.rc
# append below lines
set from=coolzhouguoliang@163.com
set smtp=smtps://smtp.163.com
set smtp-auth-user=coolzhouguoliang@163.com
set smtp-auth-password="XXX"
set smtp-auth=login
set nss-config-dir=/etc/pki/nssdb
set ssl-verify=ignore

cd /etc/pki/nssdb
echo -n |openssl s_client -connect smtp.163.com:465 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'>./163.crt
certutil -A -n "GeoTrust SSL CA -G3" -t "Pu,Pu,Pu" -d ./ -i 163.crt




# 部署一下作业自动发送邮件
01 14 * * * sh ~/project/outsourcepro/sendRecommend.sh
01 15 * * * sh ~/project/outsourcepro/sendRecommend.sh
0 9-15 * * * sh ~/project/outsourcepro/sendNews.sh
30-59/5 9-10 * * 1-5 sh ~/project/outsourcepro/sendAlert.sh
0-30/5 11 * * 1-5 sh ~/project/outsourcepro/sendAlert.sh
*/5 13-14 * * 1-5 sh ~/project/outsourcepro/sendAlert.sh

```
