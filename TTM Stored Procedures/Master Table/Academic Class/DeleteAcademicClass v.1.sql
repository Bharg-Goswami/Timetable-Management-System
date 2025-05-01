CREATE OR ALTER PROCEDURE DeleteAcademicClass
    @AcademicClassId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if AcademicClass exists
        IF NOT EXISTS (SELECT 1 FROM AcademicClass WHERE AcademicClassId = @AcademicClassId AND IsDeleted = 0)
            THROW 50032, 'Error: Academic class not found or is deleted.', 1;

        -- Soft delete Divisions
        UPDATE Division
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE AcademicClassId = @AcademicClassId AND IsDeleted = 0;

        -- Soft delete Batches under Divisions
        UPDATE Batch
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DivisionId IN (
            SELECT DivisionId FROM Division WHERE AcademicClassId = @AcademicClassId
        ) AND IsDeleted = 0;

        -- Soft delete Timetable entries related to this AcademicClass
        UPDATE Timetable
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE AcademicClassId = @AcademicClassId AND IsDeleted = 0;

        -- Soft delete AcademicClass
        UPDATE AcademicClass
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE AcademicClassId = @AcademicClassId;

        COMMIT TRANSACTION;
        PRINT 'Success: Academic class and related data deleted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

