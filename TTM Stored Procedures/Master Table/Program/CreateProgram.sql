CREATE OR ALTER PROCEDURE CreateProgram
    @ProgramCode VARCHAR(50),
    @ProgramName VARCHAR(255),
    @ProgramType VARCHAR(50),
    @Degree VARCHAR(50),
    @AcademicYearId INT,
    @DepartmentId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Check if AcademicYear exists
        IF NOT EXISTS (SELECT 1 FROM AcademicYear WHERE AcademicYearId = @AcademicYearId AND IsDeleted = 0)
        BEGIN
            THROW 50019, 'Error: AcademicYear not found or is deleted.', 1;
            RETURN;
        END

        -- Check if Department exists
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentId = @DepartmentId AND IsDeleted = 0)
        BEGIN
            THROW 50020, 'Error: Department not found or is deleted.', 1;
            RETURN;
        END

        -- Check for duplicate ProgramCode
        IF EXISTS (SELECT 1 FROM Program WHERE ProgramCode = @ProgramCode AND IsDeleted = 0)
        BEGIN
            THROW 50021, 'Error: Program code already exists.', 1;
            RETURN;
        END

        -- Insert new Program
        INSERT INTO Program (ProgramCode, ProgramName, ProgramType, Degree, AcademicYearId, DepartmentId, CreationTimeStamp, IsDisabled, IsDeleted)
        VALUES (@ProgramCode, @ProgramName, @ProgramType, @Degree, @AcademicYearId, @DepartmentId, GETDATE(), 0, 0);

        COMMIT TRANSACTION;
        PRINT 'Success: Program created successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

