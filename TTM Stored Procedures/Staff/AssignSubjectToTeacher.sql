CREATE OR ALTER PROCEDURE AssignSubjectToTeacher
    @SubjectId INT,
    @StaffId INT,
    @DivisionId INT,
    @BatchId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check if the subject exists
        IF NOT EXISTS (
            SELECT 1 FROM [Subject] WHERE SubjectId = @SubjectId
        )
        BEGIN
            RAISERROR('Invalid SubjectId.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Check if the division exists
        IF NOT EXISTS (
            SELECT 1 FROM Division WHERE DivisionId = @DivisionId
        )
        BEGIN
            RAISERROR('Invalid DivisionId.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validate BatchId exists and is linked to the division
        IF NOT EXISTS (
            SELECT 1 FROM Batch WHERE BatchId = @BatchId AND DivisionId = @DivisionId
        )
        BEGIN
            RAISERROR('Invalid BatchId for the given DivisionId.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insert the subject-teacher assignment
        INSERT INTO SubjectTeacher (SubjectId, StaffId, DivisionId, BatchId, CreationTimeStamp)
        VALUES (@SubjectId, @StaffId, @DivisionId, @BatchId, GETDATE());

        COMMIT TRANSACTION;

        SELECT SCOPE_IDENTITY() AS SubjectTeacherId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END