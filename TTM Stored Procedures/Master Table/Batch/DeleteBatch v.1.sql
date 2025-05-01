CREATE OR ALTER PROCEDURE DeleteBatch
    @BatchId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Batch exists
        IF NOT EXISTS (SELECT 1 FROM Batch WHERE BatchId = @BatchId AND IsDeleted = 0)
            THROW 50044, 'Error: Batch not found or is deleted.', 1;

        -- Soft delete Timetable entries related to this Batch
        UPDATE Timetable
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE BatchId = @BatchId AND IsDeleted = 0;

        -- Soft delete Batch
        UPDATE Batch
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE BatchId = @BatchId;

        COMMIT TRANSACTION;
        PRINT 'Success: Batch deleted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

