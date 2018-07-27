DROP PROCEDURE IF EXISTS GetFinalResult;

DELIMITER //
CREATE PROCEDURE GetFinalResult(IN currentQuater INT)
BEGIN

-- CALL GetBasicAvg();
-- CALL GetReportAvg(currentQuater);
-- CALL GetProfitAvg(currentQuater);
-- CALL GetOperationAvg(currentQuater);
-- CALL GetGrowthAvg(currentQuater);
-- CALL GetDebtpayAvg(currentQuater);
-- CALL GetCashflowAvg(currentQuater);
-- CALL GetAllIndexAvg();
CALL GetAllStockIndex(currentQuater);

DROP TABLE IF EXISTS RESULT_RECOMMEND;
CREATE TABLE RESULT_RECOMMEND AS SELECT CODE,NAME, INDUSTRY,round(1000/PRICE + 1000/PE + 10 * NPR + 10 * GPR + 20 * BIPS + 10 * SHEQRATIO + 5 * CASHFLOWRATIO + 5 * if(MBRG>100,MBRG/10,MBRG) + 5 * if(EPSG>100,EPSG/10,EPSG) + 5 * if(SEG>100,SEG/10,SEG)) AS SCORE,round(PE),round(PRICE),round(GPR),round(BIPS),round(SHEQRATIO),CASHFLOWRATIO,MBRG,EPSG,SEG FROM RESULT_ALLSTOCKINDEX WHERE round(PE) > 0 and round(PE) < 100 AND CASHFLOWRATIO > 0 AND round(BIPS) > 0 AND MBRG > 0 AND EPSG > 0 AND SEG > 0 ORDER BY SCORE DESC, round(PE), round(PRICE) limit 0,500;

-- DELETE FROM realtime_price WHERE abs(changepercent) < 1.0 OR turnoverratio < 1 OR turnoverratio > 35;
delete from JIATOU_RECOMMEND where DATE = date_format(now(),'%Y%m%d');
delete from JIATOU_RECOMMEND where DATE < date_format(date_sub(now(),interval 10 day),'%Y%m%d');

delete from cap_tops where code like '3%';
delete from cap_tops where net > 0;

INSERT INTO JIATOU_RECOMMEND SELECT t1.CODE,t1.NAME, date_format(now(),'%Y%m%d') as DATE, t1.SCORE,t3.net as NET,t3.net/t2.trade * 100 as VOL FROM RESULT_RECOMMEND as t1 inner join realtime_price as t2 on t1.code = t2.code inner join cap_tops as t3 on t1.code = t3.code;

-- delete from FENGTOU_RECOMMEND where DATE = date_format(now(),'%Y%m%d');
-- INSERT INTO FENGTOU_RECOMMEND select t1.code, t1.name, date_format(now(),'%Y%m%d') as DATE, t2.net, t2.net/t1.trade * 100 as VOL from realtime_price as t1 inner join cap_tops as t2 on t1.code = t2.code;

END;


-- CALL GetFinalResult();
