DROP PROCEDURE GetAllStockIndex;


--代码
--行业
--市盈率
--市净率
--每股净资产
--净利率
--毛利率
--每股主营业务收入
--营收帐款周转率
--存货周转率
--流动资产周转率
--主营业务收入增长率
--净利润增长率
--净资产增长率
--总资产增长率
--每股收益增长率
--股东权益增长率
--流动比率
--速动比率
--现金比率
--利息支付倍数
--股东权益比率
--经营现金净流量对销售收入比率
--资产的经营现金流量回报率
--经营现金净流量对负债比率
--现金流量比率
--每股收益
--净资产收益率



DELIMITER //
CREATE PROCEDURE GetAllStockIndex()
BEGIN
DROP TABLE IF EXISTS RESULT_ALLSTOCKINDEX;
CREATE TABLE RESULT_ALLSTOCKINDEX AS
SELECT T1.CODE, T1.INDUSTRY,
T1.PE, 
T1.PB, 
T1.BVPS,
T2.net_profit_ratio AS NPR, 
T2.gross_profit_rate AS GPR, 
T2.BIPS, 
T3.ARTURNOVER, 
T3.INVENTORY_TURNOVER, 
T3.CURRENTASSET_TURNOVER, 
T4.MBRG, 
T4.NPRG, 
T4.NAV, 
T4.TARG, 
T4.EPSG, 
T4.SEG, 
T5.CURRENTRATIO, 
T5.QUICKRATIO, 
T5.CASHRATIO, 
T5.ICRATIO, 
T5.SHEQRATIO, 
T6.cf_sales, 
T6.rateofreturn, 
T6.cf_liabilities, 
T6.cashflowratio
 FROM basic_info AS T1
INNER JOIN 
(
select code,net_profit_ratio,gross_profit_rate,bips from profit_data
        where quater = 20172
        and net_profit_ratio is not null
        and gross_profit_rate is not null
        and bips is not null
UNION ALL
select code,net_profit_ratio,gross_profit_rate,bips from profit_data
        where code not in (select code from profit_data where quater = 20172)
        and net_profit_ratio is not null
        and gross_profit_rate is not null
        and bips is not null
) AS T2
ON T1.CODE = T2.CODE
INNER JOIN 
(
select code,arturnover,inventory_turnover,currentasset_turnover from operation_data
        where quater = 20172
        and arturnover is not null
        and inventory_turnover is not null
        and currentasset_turnover is not null
UNION ALL
select code,arturnover,inventory_turnover,currentasset_turnover from operation_data
        where code not in (select code from operation_data where quater = 20172)
        and arturnover is not null
        and inventory_turnover is not null
        and currentasset_turnover is not null
) AS T3
ON T1.CODE = T3.CODE
INNER JOIN 
(
select code,mbrg,nprg,nav,targ,epsg,seg from growth_data
        where quater = 20172
        and mbrg is not null
        and nprg is not null
        and nav is not null
        and targ is not null
        and epsg is not null
        and seg is not null
UNION ALL
select code,mbrg,nprg,nav,targ,epsg,seg from growth_data
        where code not in (select code from growth_data where quater = 20172)
        and mbrg is not null
        and nprg is not null
        and nav is not null
        and targ is not null
        and epsg is not null
        and seg is not null
) AS T4
ON T1.CODE = T4.CODE
INNER JOIN 
(
select code,currentratio,quickratio,cashratio,icratio,sheqratio from debtpay_data
        where quater = 20172
        and currentratio is not null
        and quickratio is not null
        and cashratio is not null
        and icratio is not null
        and sheqratio is not null
UNION ALL
select code,currentratio,quickratio,cashratio,icratio,sheqratio from debtpay_data
        where code not in (select code from debtpay_data where quater = 20172)
        and currentratio is not null
        and quickratio is not null
        and cashratio is not null
        and icratio is not null
        and sheqratio is not null
) AS T5
ON T1.CODE = T5.CODE
INNER JOIN 
(
select code,cf_sales,rateofreturn,cf_liabilities,cashflowratio from cashflow_data
        where quater = 20172
        and cf_sales is not null
        and rateofreturn is not null
        and cf_liabilities is not null
        and cashflowratio is not null
UNION ALL
select code,cf_sales,rateofreturn,cf_liabilities,cashflowratio from cashflow_data
        where code not in (select code from cashflow_data where quater = 20172)
        and cf_sales is not null
        and rateofreturn is not null
        and cf_liabilities is not null
        and cashflowratio is not null
) AS T6
ON T1.CODE = T6.CODE
INNER JOIN 
(
select code,eps,roe from report_data
        where quater = 20172
        and eps is not null
        and roe is not null
UNION ALL
select code,eps,roe from report_data
        where code not in (select code from report_data where quater = 20172)
        and eps is not null
        and roe is not null
) AS T7
ON T1.CODE = T7.CODE;

END;


CALL GetAllStockIndex();

