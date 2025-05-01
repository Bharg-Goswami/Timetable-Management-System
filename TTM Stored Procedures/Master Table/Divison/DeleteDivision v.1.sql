CREATE OR ALTER PROCEDURE DeleteDivision
    @DivisionId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Division exists
        IF NOT EXISTS (SELECT 1 FROM Division WHERE DivisionId = @DivisionId AND IsDeleted = 0)
            THROW 50038, 'Error: Division not found or is deleted.', 1;

        -- Soft delete Batches
        UPDATE Batch
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DivisionId = @DivisionId AND IsDeleted = 0;

        -- Soft delete Timetable entries related to this Division
        UPDATE Timetable
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DivisionId = @DivisionId AND IsDeleted = 0;

        -- Soft delete Division
        UPDATE Division
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DivisionId = @DivisionId;

        COMMIT TRANSACTION;
        PRINT 'Success: Division and related data deleted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

