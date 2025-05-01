CREATE PROCEDURE GetDays
AS
BEGIN
    SELECT
        DayId,
        DayName
    FROM WeekDay 
    WHERE IsDeleted = 0
    AND IsDisabled = 0;
END;