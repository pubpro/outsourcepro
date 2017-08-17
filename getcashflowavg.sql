DROP PROCEDURE GetCashflowAvg;

DELIMITER //
CREATE PROCEDURE GetCashflowAvg()
BEGIN
DROP TABLE IF EXISTS RESULT_CASHFLOW_AVG;
CREATE TABLE RESULT_CASHFLOW_AVG AS
select a.industry, avg(b.cf_sales) as cf_sales,avg(b.rateofreturn) as rateofreturn,avg(b.cf_liabilities) as cf_liabilities,avg(b.cashflowratio) as cashflowratio from basic_info as a
inner join (
select distinct code,cf_sales,rateofreturn,cf_liabilities,cashflowratio from cashflow_data 
	where quater = 20172 
	and cf_sales is not null
	and rateofreturn is not null
	and cf_liabilities is not null
	and cashflowratio is not null
UNION ALL 
select distinct code,cf_sales,rateofreturn,cf_liabilities,cashflowratio from cashflow_data 
	where code not in (select distinct code from cashflow_data where quater = 20172)
	and cf_sales is not null
	and rateofreturn is not null
	and cf_liabilities is not null
	and cashflowratio is not null
) as b
on a.code = b.code
group by a.industry;

END;


CALL GetCashflowAvg();

