CREATE OR ALTER PROCEDURE GetAcademicClass
    @ProgramId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ac.AcademicClassId,
        ac.AcademicClassName,
        ac.ProgramId,
        p.ProgramName
    FROM AcademicClass ac
    JOIN Program p ON ac.ProgramId = p.ProgramId
    WHERE ac.ProgramId = @ProgramId
      AND ac.IsDeleted = 0
      AND ac.IsDisabled = 0
      AND p.IsDeleted = 0
      AND p.IsDisabled = 0
    ORDER BY ac.AcademicClassName;
END;