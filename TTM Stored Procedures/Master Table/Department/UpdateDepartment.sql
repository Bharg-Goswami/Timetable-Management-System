CREATE OR ALTER PROCEDURE UpdateDepartment
    @DepartmentId INT,
    @DepartmentName VARCHAR(255) = NULL,  -- Allow NULLs
    @FacultyId INT = NULL  -- Allow NULLs
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Department exists
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentId = @DepartmentId AND IsDeleted = 0)
        BEGIN
            ;THROW 50007, 'Error: Department not found or is deleted.', 1;
            RETURN;
        END

        -- Check if Faculty exists
        IF @FacultyId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Faculty WHERE FacultyId = @FacultyId AND IsDeleted = 0)
        BEGIN
            ;THROW 50008, 'Error: Faculty not found or is deleted.', 1;
            RETURN;
        END

        -- Check for duplicate DepartmentName if provided
        IF @DepartmentName IS NOT NULL AND EXISTS (SELECT 1 FROM Department WHERE DepartmentName = @DepartmentName AND FacultyId = @FacultyId AND DepartmentId <> @DepartmentId AND IsDeleted = 0)
        BEGIN
            ;THROW 50009, 'Error: Department name already exists in this faculty.', 1;
            RETURN;
        END

        -- Update Department: Only update provided (non-null) fields
        UPDATE Department
        SET 
            DepartmentName = COALESCE(@DepartmentName, DepartmentName),  -- Update only if new value is provided
            FacultyId = COALESCE(@FacultyId, FacultyId),  -- Update only if new value is provided
            UpdationTimeStamp = GETDATE()
        WHERE DepartmentId = @DepartmentId;

        COMMIT TRANSACTION;
        PRINT 'Success: Department updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

