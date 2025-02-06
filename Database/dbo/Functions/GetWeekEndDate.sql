CREATE FUNCTION GetWeekEndDate (
    @WeekNumber INT,
    @Year INT
)
RETURNS DATE
AS
BEGIN
    DECLARE @StartDate DATE;
    DECLARE @EndDate DATE;

    -- Call the GetWeekStartDate function to get the start date of the week
    SET @StartDate = dbo.GetWeekStartDate(@WeekNumber, @Year);

    -- Calculate end date of the week
    SET @EndDate = DATEADD(DAY, 6, @StartDate);

    -- If the end date falls into the next year, adjust it to the last day of the current year
    IF YEAR(@EndDate) > @Year
    BEGIN
        SET @EndDate = DATEFROMPARTS(@Year, 12, 31);
    END

    RETURN @EndDate;
END;
