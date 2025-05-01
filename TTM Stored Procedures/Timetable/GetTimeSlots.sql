-- Get Time Slots by ProgramId
CREATE PROCEDURE GetTimeSlots
    @ProgramId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        TimeSlotId,
        Timeslot,
        FromTime,
        ToTime
    FROM TimeSlot 
    WHERE ProgramId = @ProgramId 
        AND IsDeleted = 0 
        AND IsDisabled = 0;
END;
GO