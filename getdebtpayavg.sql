DROP PROCEDURE GetDebtpayAvg;

DELIMITER //
CREATE PROCEDURE GetDebtpayAvg()
BEGIN
DROP TABLE IF EXISTS RESULT_DEBTPAY_AVG;
CREATE TABLE RESULT_DEBTPAY_AVG AS
select a.industry, avg(b.currentratio) as currentratio,avg(b.quickratio) as quickratio,avg(b.cashratio) as cashratio,avg(b.icratio) as icratio,
avg(b.sheqratio) as sheqratio from basic_info as a
inner join (
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
) as b
on a.code = b.code
group by a.industry;

END;


CALL GetDebtpayAvg();
