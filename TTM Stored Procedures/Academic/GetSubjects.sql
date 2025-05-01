-- Get Subjects by AcademicClassId
CREATE PROCEDURE GetSubjects
    @AcademicClassId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        S.SubjectId, 
        S.SubjectName, 
        ST.SubjectTypeName
    FROM Subject S
    INNER JOIN SubjectType ST ON S.SubjectTypeId = ST.SubjectTypeId
    WHERE S.AcademicClassId = @AcademicClassId 
        AND S.IsDeleted = 0 
        AND S.IsDisabled = 0;
END;
GO
