CREATE OR ALTER PROCEDURE AuthenticateUser
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT Email, [Password]
    FROM Users
    WHERE Email = @Email
        AND IsDeleted = 0
        AND IsDisabled = 0;
END;
