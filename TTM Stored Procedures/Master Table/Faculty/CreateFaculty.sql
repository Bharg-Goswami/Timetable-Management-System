CREATE OR ALTER PROCEDURE CreateFaculty
    @FacultyName VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check for duplicate FacultyName
        IF EXISTS (SELECT 1 FROM Faculty WHERE FacultyName = @FacultyName AND IsDeleted = 0)
        BEGIN
            THROW 50001, 'Error: Faculty name already exists.', 1;
            RETURN;
        END

        -- Insert new Faculty
        INSERT INTO Faculty (FacultyName, CreationTimeStamp, IsDisabled, IsDeleted)
        VALUES (@FacultyName, GETDATE(), 0, 0);

        COMMIT TRANSACTION;
        PRINT 'Success: Faculty created successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

