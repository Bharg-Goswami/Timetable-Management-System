-- Get Current Academic Year by FacultyId
CREATE PROCEDURE GetCurrentAcademicYear
    @FacultyId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 
        AcademicYearId, 
        AcademicYearCode
    FROM AcademicYear
    WHERE FacultyId = @FacultyId
        AND AcademicYearFrom <= GETDATE()
        AND AcademicYearTo >= GETDATE()
        AND IsDeleted = 0 
        AND IsDisabled = 0
    ORDER BY AcademicYearFrom DESC;
END;
GO