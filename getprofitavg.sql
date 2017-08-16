DROP PROCEDURE GetProfitAvg;

DELIMITER //
CREATE PROCEDURE GetProfitAvg()
BEGIN
DROP TABLE IF EXISTS RESULT_PROFIT_AVG;
CREATE TABLE RESULT_PROFIT_AVG AS
select a.industry, avg(b.net_profit_ratio) as npr,avg(b.gross_profit_rate) as gpr,avg(b.bips) as bips from basic_info as a
inner join (
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
) as b
on a.code = b.code
group by a.industry;

END;


CALL GetProfitAvg();
