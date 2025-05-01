CREATE OR ALTER PROCEDURE CreateDivision
    @DivisionName VARCHAR(50),
    @AcademicClassId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if AcademicClass exists
        IF NOT EXISTS (SELECT 1 FROM AcademicClass WHERE AcademicClassId = @AcademicClassId AND IsDeleted = 0)
            THROW 50033, 'Error: Academic class not found or is deleted.', 1;

        -- Check for duplicate DivisionName
        IF EXISTS (SELECT 1 FROM Division WHERE DivisionName = @DivisionName AND AcademicClassId = @AcademicClassId AND IsDeleted = 0)
            THROW 50034, 'Error: Division name already exists in this academic class.', 1;

        -- Insert new Division
        DECLARE @NewDivisionId INT;
        INSERT INTO Division (DivisionName, AcademicClassId, CreationTimeStamp, IsDisabled, IsDeleted)
        VALUES (@DivisionName, @AcademicClassId, GETDATE(), 0, 0);
        SET @NewDivisionId = SCOPE_IDENTITY();

        -- Create default Batch
        INSERT INTO Batch (BatchName, DivisionId, CreationTimeStamp, IsDisabled, IsDeleted)
        VALUES ('Batch 1', @NewDivisionId, GETDATE(), 0, 0);

        COMMIT TRANSACTION;
        PRINT 'Success: Division and default batch created successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

