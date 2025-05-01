CREATE OR ALTER PROCEDURE UpdateDivision
    @DivisionId INT,
    @DivisionName VARCHAR(50),
    @AcademicClassId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Division exists
        IF NOT EXISTS (SELECT 1 FROM Division WHERE DivisionId = @DivisionId AND IsDeleted = 0)
        BEGIN
            THROW 50035, 'Error: Division not found or is deleted.', 1;
            RETURN;
        END

        -- Check if AcademicClass exists
        IF NOT EXISTS (SELECT 1 FROM AcademicClass WHERE AcademicClassId = @AcademicClassId AND IsDeleted = 0)
        BEGIN
            THROW 50036, 'Error: Academic class not found or is deleted.', 1;
            RETURN;
        END

        -- Check for duplicate DivisionName
        IF EXISTS (SELECT 1 FROM Division WHERE DivisionName = @DivisionName AND AcademicClassId = @AcademicClassId AND DivisionId <> @DivisionId AND IsDeleted = 0)
        BEGIN
            THROW 50037, 'Error: Division name already exists in this academic class.', 1;
            RETURN;
        END

        -- Update Division
        UPDATE Division
        SET DivisionName = @DivisionName,
            AcademicClassId = @AcademicClassId,
            UpdationTimeStamp = GETDATE()
        WHERE DivisionId = @DivisionId;

        COMMIT TRANSACTION;
        PRINT 'Success: Division updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

