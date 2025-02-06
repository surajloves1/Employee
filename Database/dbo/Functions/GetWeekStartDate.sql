CREATE FUNCTION GetWeekStartDate (
    @WeekNumber INT,
    @Year INT
)
RETURNS DATE
AS
BEGIN
    DECLARE @FirstDayOfYear DATE;
    SET @FirstDayOfYear = DATEFROMPARTS(@Year, 1, 1);

    DECLARE @StartDate DATE;

    -- Calculate start date of the week
    SET @StartDate = DATEADD(WEEK, @WeekNumber - 1, @FirstDayOfYear);
    SET @StartDate = DATEADD(DAY, 1 - DATEPART(WEEKDAY, @StartDate), @StartDate);

    -- If the start date falls into the next year, adjust it to the last day of the current year
    IF YEAR(@StartDate) > @Year
    BEGIN
        SET @StartDate = DATEFROMPARTS(@Year, 12, 31);
    END

    RETURN @StartDate;
END;
