CREATE OR ALTER PROCEDURE UpdateFaculty
    @FacultyId INT,
    @FacultyName VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Faculty exists
        IF NOT EXISTS (SELECT 1 FROM Faculty WHERE FacultyId = @FacultyId AND IsDeleted = 0)
        BEGIN
            THROW 50002, 'Error: Faculty not found or is deleted.', 1;
            RETURN;
        END

        -- Check for duplicate FacultyName
        IF EXISTS (SELECT 1 FROM Faculty WHERE FacultyName = @FacultyName AND FacultyId <> @FacultyId AND IsDeleted = 0)
        BEGIN
            THROW 50003, 'Error: Faculty name already exists.', 1;
            RETURN;
        END

        -- Update Faculty
        UPDATE Faculty
        SET FacultyName = @FacultyName,
            UpdationTimeStamp = GETDATE()
        WHERE FacultyId = @FacultyId;

        COMMIT TRANSACTION;
        PRINT 'Success: Faculty updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

