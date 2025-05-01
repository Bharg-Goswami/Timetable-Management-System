CREATE OR ALTER PROCEDURE UpdateAcademicClass
    @AcademicClassId INT,
    @AcademicClassName VARCHAR(255) = NULL,
    @ProgramId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if AcademicClass exists
        IF NOT EXISTS (
            SELECT 1 
            FROM AcademicClass 
            WHERE AcademicClassId = @AcademicClassId AND IsDeleted = 0
        )
        BEGIN
            RAISERROR('Error: Academic class not found or is deleted.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- If ProgramId is being updated, check if it exists
        IF @ProgramId IS NOT NULL
        BEGIN
            IF NOT EXISTS (
                SELECT 1 
                FROM Program 
                WHERE ProgramId = @ProgramId AND IsDeleted = 0
            )
            BEGIN
                RAISERROR('Error: Program not found or is deleted.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END;
        END;

        -- Check for duplicate AcademicClassName only if both name and program are provided
        IF @AcademicClassName IS NOT NULL AND @ProgramId IS NOT NULL
        BEGIN
            IF EXISTS (
                SELECT 1 
                FROM AcademicClass 
                WHERE AcademicClassName = @AcademicClassName 
                  AND ProgramId = @ProgramId 
                  AND AcademicClassId <> @AcademicClassId 
                  AND IsDeleted = 0
            )
            BEGIN
                RAISERROR('Error: Academic class name already exists in this program.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END;
        END;

        -- Perform the update
        UPDATE AcademicClass
        SET 
            AcademicClassName = COALESCE(@AcademicClassName, AcademicClassName),
            ProgramId = COALESCE(@ProgramId, ProgramId),
            UpdationTimeStamp = GETDATE()
        WHERE AcademicClassId = @AcademicClassId;

        COMMIT TRANSACTION;
        PRINT 'Success: Academic class updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
        SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();
        RAISERROR(@ErrMsg, @ErrSeverity, 1);
    END CATCH;
END;

