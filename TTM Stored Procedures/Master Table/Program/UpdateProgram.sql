CREATE OR ALTER PROCEDURE UpdateProgram
    @ProgramId INT,
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
        -- Check if Program exists
        IF NOT EXISTS (SELECT 1 FROM Program WHERE ProgramId = @ProgramId AND IsDeleted = 0)
        BEGIN
            THROW 50022, 'Error: Program not found or is deleted.', 1;
            RETURN;
        END

        -- Check if AcademicYear exists
        IF NOT EXISTS (SELECT 1 FROM AcademicYear WHERE AcademicYearId = @AcademicYearId AND IsDeleted = 0)
        BEGIN
            THROW 50023, 'Error: AcademicYear not found or is deleted.', 1;
            RETURN;
        END

        -- Check if Department exists
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DepartmentId = @DepartmentId AND IsDeleted = 0)
        BEGIN
            THROW 50024, 'Error: Department not found or is deleted.', 1;
            RETURN;
        END

        -- Check for duplicate ProgramCode
        IF EXISTS (SELECT 1 FROM Program WHERE ProgramCode = @ProgramCode AND ProgramId <> @ProgramId AND IsDeleted = 0)
        BEGIN
            THROW 50025, 'Error: Program code already exists.', 1;
            RETURN;
        END

        -- Update Program
        UPDATE Program
        SET ProgramCode = @ProgramCode,
            ProgramName = @ProgramName,
            ProgramType = @ProgramType,
            Degree = @Degree,
            AcademicYearId = @AcademicYearId,
            DepartmentId = @DepartmentId,
            UpdationTimeStamp = GETDATE()
        WHERE ProgramId = @ProgramId;

        COMMIT TRANSACTION;
        PRINT 'Success: Program updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

