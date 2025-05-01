CREATE OR ALTER PROCEDURE GetUserIdentityData
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @UserRoleId INT;

    -- Fetch UserRoleId
    SELECT 
        @UserRoleId = R.RoleId
    FROM Users U
    JOIN UserRole UR ON U.UserId = UR.UserId
    JOIN [Role] R ON UR.RoleId = R.RoleId
    WHERE U.Email = @Email
        AND U.IsDeleted = 0
        AND U.IsDisabled = 0
        AND GETDATE() BETWEEN UR.FromDate AND UR.ToDate;

    -- Return message if user has no role assigned
    IF @UserRoleId IS NULL
    BEGIN
        SELECT 'User has not been assigned any role.' AS Message;
        RETURN;
    END

    -- Fetch user details
    IF @UserRoleId = 6
    BEGIN 
        -- Student-specific details
        SELECT 
            U.UserId,
            U.FullName,
            U.FacultyId,
            U.DepartmentId,
            STUFF((
                SELECT ',' + CAST(UR2.RoleId AS VARCHAR(10))
                FROM UserRole UR2
                WHERE UR2.UserId = U.UserId
                    AND GETDATE() BETWEEN UR2.FromDate AND UR2.ToDate
                FOR XML PATH('')
            ), 1, 1, '') AS RoleIds,
            STUFF((
                SELECT ',' + R.RoleName
                FROM UserRole UR2
                JOIN [Role] R ON UR2.RoleId = R.RoleId
                WHERE UR2.UserId = U.UserId
                    AND GETDATE() BETWEEN UR2.FromDate AND UR2.ToDate
                FOR XML PATH('')
            ), 1, 1, '') AS RoleNames,
            SD.AcademicClassId,
            SD.DivisionId
        FROM Users U
        JOIN UserRole UR ON U.UserId = UR.UserId
        JOIN StudentDetails SD ON U.UserId = SD.UserId
        WHERE U.Email = @Email
            AND U.IsDeleted = 0
            AND U.IsDisabled = 0
            AND GETDATE() BETWEEN UR.FromDate AND UR.ToDate
        GROUP BY U.UserId, U.FullName, U.FacultyId, U.DepartmentId, SD.AcademicClassId, SD.DivisionId;
    END
    ELSE
    BEGIN
        -- Non-student user details (exclude StudentDetails table)
        SELECT 
            U.UserId,
            U.FullName,
            U.FacultyId,
            U.DepartmentId,
            STUFF((
                SELECT ',' + CAST(UR2.RoleId AS VARCHAR(10))
                FROM UserRole UR2
                WHERE UR2.UserId = U.UserId
                    AND GETDATE() BETWEEN UR2.FromDate AND UR2.ToDate
                FOR XML PATH('')
            ), 1, 1, '') AS RoleIds,
            STUFF((
                SELECT ',' + R.RoleName
                FROM UserRole UR2
                JOIN [Role] R ON UR2.RoleId = R.RoleId
                WHERE UR2.UserId = U.UserId
                    AND GETDATE() BETWEEN UR2.FromDate AND UR2.ToDate
                FOR XML PATH('')
            ), 1, 1, '') AS RoleNames,
            NULL AS AcademicClassId,  -- Ensure column exists
            NULL AS DivisionId  -- Ensure column exists
        FROM Users U
        JOIN UserRole UR ON U.UserId = UR.UserId
        WHERE U.Email = @Email
            AND U.IsDeleted = 0
            AND U.IsDisabled = 0
            AND GETDATE() BETWEEN UR.FromDate AND UR.ToDate
        GROUP BY U.UserId, U.FullName, U.FacultyId, U.DepartmentId;
    END
END;