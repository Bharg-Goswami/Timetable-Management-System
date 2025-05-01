CREATE OR ALTER PROCEDURE CreateDepartment
    @DepartmentName VARCHAR(255),
    @FacultyId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Faculty exists
        IF NOT EXISTS (SELECT 1 FROM Faculty WHERE FacultyId = @FacultyId AND IsDeleted = 0)
        BEGIN
            ;THROW 50005, 'Error: Faculty not found or is deleted.', 1;
            RETURN;
        END

        -- Check for duplicate DepartmentName
        IF EXISTS (SELECT 1 FROM Department WHERE DepartmentName = @DepartmentName AND FacultyId = @FacultyId AND IsDeleted = 0)
        BEGIN
            ;THROW 50006, 'Error: Department name already exists in this faculty.', 1;
            RETURN;
        END

        -- Insert new Department
        INSERT INTO Department (DepartmentName, FacultyId, CreationTimeStamp, IsDisabled, IsDeleted)
        VALUES (@DepartmentName, @FacultyId, GETDATE(), 0, 0);

        COMMIT TRANSACTION;
        PRINT 'Success: Department created successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

