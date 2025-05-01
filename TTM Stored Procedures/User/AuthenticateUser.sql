CREATE PROCEDURE AuthenticateUser
    @Email NVARCHAR(100),
    @Password NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        U.UserId,
        U.FullName,
        U.FacultyId,
        U.DepartmentId,
        STUFF((
            SELECT ',' + CAST(UR2.RoleId AS VARCHAR(10)) + ':' + R.RoleName
            FROM UserRole UR2
            JOIN [Role] R ON UR2.RoleId = R.RoleId
            WHERE UR2.UserId = U.UserId
                AND GETDATE() BETWEEN UR2.FromDate AND UR2.ToDate
            FOR XML PATH('')
        ), 1, 1, '') AS RoleIds
    FROM Users U
    JOIN UserRole UR ON U.UserId = UR.UserId
    WHERE U.Email = @Email
        AND U.Password = @Password
        AND U.IsDeleted = 0
        AND U.IsDisabled = 0
        AND GETDATE() BETWEEN UR.FromDate AND UR.ToDate
    GROUP BY U.UserId, U.FullName, U.FacultyId, U.DepartmentId;
END;
