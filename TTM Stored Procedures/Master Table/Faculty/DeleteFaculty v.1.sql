CREATE OR ALTER PROCEDURE DeleteFaculty
    @FacultyId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Faculty exists
        IF NOT EXISTS (SELECT 1 FROM Faculty WHERE FacultyId = @FacultyId AND IsDeleted = 0)
            THROW 50004, 'Error: Faculty not found or is deleted.', 1;

        -- Soft delete child Departments
        UPDATE Department
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE FacultyId = @FacultyId AND IsDeleted = 0;

        -- Soft delete child Locations (directly under Faculty)
        UPDATE Location
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE FacultyId = @FacultyId AND IsDeleted = 0;

        -- Soft delete Programs under Departments
        UPDATE Program
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE DepartmentId IN (
            SELECT DepartmentId FROM Department WHERE FacultyId = @FacultyId
        ) AND IsDeleted = 0;

        -- Soft delete AcademicClasses under Programs
        UPDATE AcademicClass
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE ProgramId IN (
            SELECT ProgramId FROM Program 
            WHERE DepartmentId IN (
                SELECT DepartmentId FROM Department WHERE FacultyId = @FacultyId
            )
        ) AND IsDeleted = 0;

        -- Soft delete Divisions under AcademicClasses
        UPDATE Division
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE AcademicClassId IN (
            SELECT AcademicClassId FROM AcademicClass 
            WHERE ProgramId IN (
                SELECT ProgramId FROM Program 
                WHERE DepartmentId IN (
                    SELECT DepartmentId FROM Department WHERE FacultyId = @FacultyId
                )
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
                    SELECT ProgramId FROM Program 
                    WHERE DepartmentId IN (
                        SELECT DepartmentId FROM Department WHERE FacultyId = @FacultyId
                    )
                )
            )
        ) AND IsDeleted = 0;

        -- Soft delete TimeSlots under Programs
        UPDATE TimeSlot
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE ProgramId IN (
            SELECT ProgramId FROM Program 
            WHERE DepartmentId IN (
                SELECT DepartmentId FROM Department WHERE FacultyId = @FacultyId
            )
        ) AND IsDeleted = 0;

        -- Soft delete Timetable entries related to this Faculty
        UPDATE Timetable
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE FacultyId = @FacultyId AND IsDeleted = 0;

        -- Soft delete Faculty
        UPDATE Faculty
        SET IsDeleted = 1, DeletionTimeStamp = GETDATE()
        WHERE FacultyId = @FacultyId;

        COMMIT TRANSACTION;
        PRINT 'Success: Faculty and related data deleted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

