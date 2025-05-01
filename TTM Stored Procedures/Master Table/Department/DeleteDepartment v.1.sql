CREATE OR ALTER PROCEDURE DeleteDepartment
    @DepartmentId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Department exists
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentId = @DepartmentId AND IsDeleted = 0)
            THROW 50010, 'Error: Department not found or is deleted.', 1;

        -- Soft delete child Locations
        UPDATE Location
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DepartmentId = @DepartmentId AND IsDeleted = 0;

        -- Soft delete child Programs
        UPDATE Program
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DepartmentId = @DepartmentId AND IsDeleted = 0;

        -- Soft delete AcademicClasses under Programs
        UPDATE AcademicClass
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE ProgramId IN (
            SELECT ProgramId FROM Program WHERE DepartmentId = @DepartmentId
        ) AND IsDeleted = 0;

        -- Soft delete Divisions under AcademicClasses
        UPDATE Division
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE AcademicClassId IN (
            SELECT AcademicClassId FROM AcademicClass 
            WHERE ProgramId IN (
                SELECT ProgramId FROM Program WHERE DepartmentId = @DepartmentId
            )
        ) AND IsDeleted = 0;

        -- Soft delete Batches under Divisions
        UPDATE Batch
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DivisionId IN (
            SELECT DivisionId FROM Division 
            WHERE AcademicClassId IN (
                SELECT AcademicClassId FROM AcademicClass 
                WHERE ProgramId IN (
                    SELECT ProgramId FROM Program WHERE DepartmentId = @DepartmentId
                )
            )
        ) AND IsDeleted = 0;

        -- Soft delete TimeSlots under Programs
        UPDATE TimeSlot
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE ProgramId IN (
            SELECT ProgramId FROM Program WHERE DepartmentId = @DepartmentId
        ) AND IsDeleted = 0;

        -- Soft delete Timetable entries related to this Department
        UPDATE Timetable
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DepartmentId = @DepartmentId AND IsDeleted = 0;

        -- Soft delete Department
        UPDATE Department
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DepartmentId = @DepartmentId;

        COMMIT TRANSACTION;
        PRINT 'Success: Department and related data deleted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

