DROP PROCEDURE IF EXISTS GetFinalResult;

DELIMITER //
CREATE PROCEDURE GetFinalResult(IN currentQuater INT)
BEGIN

CALL GetBasicAvg();
CALL GetReportAvg(currentQuater);
CALL GetProfitAvg(currentQuater);
CALL GetOperationAvg(currentQuater);
CALL GetGrowthAvg(currentQuater);
CALL GetDebtpayAvg(currentQuater);
CALL GetCashflowAvg(currentQuater);
CALL GetAllIndexAvg();
CALL GetAllStockIndex(currentQuater);

DROP TABLE IF EXISTS RESULT_RECOMMEND;
CREATE TABLE RESULT_RECOMMEND AS SELECT CODE,NAME, INDUSTRY,round(1000/PRICE + 1000/PE + 10 * NPR + 10 * GPR + 20 * BIPS + 10 * SHEQRATIO + 5 * CASHFLOWRATIO + 5 * if(MBRG>100,MBRG/10,MBRG) + 5 * if(EPSG>100,EPSG/10,EPSG) + 5 * if(SEG>100,SEG/10,SEG)) AS SCORE,round(PE),round(PRICE),round(GPR),round(BIPS),round(SHEQRATIO),CASHFLOWRATIO,MBRG,EPSG,SEG FROM RESULT_ALLSTOCKINDEX WHERE round(PE) > 0 and round(PE) < 100 AND CASHFLOWRATIO > 0 AND round(BIPS) > 0 AND MBRG > 0 AND EPSG > 0 AND SEG > 0 ORDER BY SCORE DESC, round(PE), round(PRICE) limit 0,200;

DELETE FROM realtime_price WHERE changepercent < 1 OR turnoverratio < 1.5 OR turnoverratio > 8;

END;


-- CALL GetFinalResult();
