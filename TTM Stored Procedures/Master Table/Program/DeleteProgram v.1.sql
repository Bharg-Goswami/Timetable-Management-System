CREATE OR ALTER PROCEDURE DeleteProgram
    @ProgramId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Program exists
        IF NOT EXISTS (SELECT 1 FROM Program WHERE ProgramId = @ProgramId AND IsDeleted = 0)
            THROW 50026, 'Error: Program not found or is deleted.', 1;

        -- Soft delete AcademicClasses
        UPDATE AcademicClass
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE ProgramId = @ProgramId AND IsDeleted = 0;

        -- Soft delete Divisions under AcademicClasses
        UPDATE Division
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE AcademicClassId IN (
            SELECT AcademicClassId FROM AcademicClass WHERE ProgramId = @ProgramId
        ) AND IsDeleted = 0;

        -- Soft delete Batches under Divisions
        UPDATE Batch
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DivisionId IN (
            SELECT DivisionId FROM Division 
            WHERE AcademicClassId IN (
                SELECT AcademicClassId FROM AcademicClass WHERE ProgramId = @ProgramId
            )
        ) AND IsDeleted = 0;

        -- Soft delete TimeSlots
        UPDATE TimeSlot
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE ProgramId = @ProgramId AND IsDeleted = 0;

        -- Soft delete Timetable entries related to this Program
        UPDATE Timetable
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE ProgramId = @ProgramId AND IsDeleted = 0;

        -- Soft delete Program
        UPDATE Program
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE ProgramId = @ProgramId;

        COMMIT TRANSACTION;
        PRINT 'Success: Program and related data deleted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

