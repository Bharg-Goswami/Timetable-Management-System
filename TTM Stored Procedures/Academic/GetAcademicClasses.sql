GO
-- Get Academic Classes by ProgramId
CREATE PROCEDURE GetAcademicClasses
    @ProgramId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        AcademicClassId,
        AcademicClassName
    FROM AcademicClass 
    WHERE ProgramId = @ProgramId 
        AND IsDeleted = 0 
        AND IsDisabled = 0;
END;
GO