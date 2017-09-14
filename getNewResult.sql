DROP PROCEDURE GetFinalResult;

DELIMITER //

CREATE PROCEDURE GetFinalResult()
BEGIN

CALL GetBasicAvg();
CALL GetReportAvg();
CALL GetProfitAvg();
CALL GetOperationAvg();
CALL GetGrowthAvg();
CALL GetDebtpayAvg();
CALL GetCashflowAvg();
CALL GetAllIndexAvg();
CALL GetAllStockIndex();


END;


CALL GetFinalResult();

