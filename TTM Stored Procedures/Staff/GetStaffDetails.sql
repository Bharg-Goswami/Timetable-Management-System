CREATE OR ALTER PROCEDURE [dbo].[GetStaffDetails]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        sd.StaffId,
        sd.UserId,
        u.FacultyId,
        f.FacultyName,
        u.DepartmentId,
        d.DepartmentName,
        u.FullName,
        sd.Designation,
        sd.Qualification,
        u.PhoneNumber,
        u.Email,
        STRING_AGG(s.SubjectName, ', ') AS Subjects
    FROM StaffDetails sd
    INNER JOIN Users u ON sd.UserId = u.UserId
    INNER JOIN Faculty f ON u.FacultyId = f.FacultyId
    INNER JOIN Department d ON u.DepartmentId = d.DepartmentId
    LEFT JOIN SubjectTeacher st ON sd.StaffId = st.StaffId
    LEFT JOIN [Subject] s ON st.SubjectId = s.SubjectId
    WHERE sd.IsDisabled = 0
      AND sd.IsDeleted = 0
    GROUP BY 
        sd.StaffId,
        sd.UserId,
        u.FacultyId,
        f.FacultyName,
        u.DepartmentId,
        d.DepartmentName,
        u.FullName,
        sd.Designation,
        sd.Qualification,
        u.PhoneNumber,
        u.Email
    ORDER BY sd.StaffId;
END;
