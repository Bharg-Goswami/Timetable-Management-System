CREATE OR ALTER PROCEDURE CreateAcademicClass
    @AcademicClassName VARCHAR(255),
    @ProgramId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if Program exists
        IF NOT EXISTS (SELECT 1 FROM Program WHERE ProgramId = @ProgramId AND IsDeleted = 0)
            THROW 50027, 'Error: Program not found or is deleted.', 1;

        -- Check for duplicate AcademicClassName
        IF EXISTS (SELECT 1 FROM AcademicClass WHERE AcademicClassName = @AcademicClassName AND ProgramId = @ProgramId AND IsDeleted = 0)
            THROW 50028, 'Error: Academic class name already exists in this program.', 1;

        -- Insert new AcademicClass
        DECLARE @NewAcademicClassId INT;
        INSERT INTO AcademicClass (AcademicClassName, ProgramId, CreationTimeStamp, IsDisabled, IsDeleted)
        VALUES (@AcademicClassName, @ProgramId, GETDATE(), 0, 0);
        SET @NewAcademicClassId = SCOPE_IDENTITY();

        -- Create default Division
        INSERT INTO Division (DivisionName, AcademicClassId, CreationTimeStamp, IsDisabled, IsDeleted)
        VALUES ('Division A', @NewAcademicClassId, GETDATE(), 0, 0);

        COMMIT TRANSACTION;
        PRINT 'Success: Academic class and default division created successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

