CREATE OR ALTER PROCEDURE GetBatch
    @DivisionId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        b.BatchId,
        b.BatchName,
        b.DivisionId,
        div.DivisionName,
        b.IsDisabled
    FROM Batch b
    JOIN Division div ON b.DivisionId = div.DivisionId
    WHERE b.IsDeleted = 0
      AND div.IsDeleted = 0
      AND div.IsDisabled = 0
    ORDER BY b.BatchName;
END;

