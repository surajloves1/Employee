
CREATE FUNCTION GetDayOfWeekDate (
    @WeekNumber INT,
    @Year INT,
    @DayOfWeek INT
)
RETURNS DATE
AS
BEGIN
    DECLARE @WeekStartDate DATE;
    DECLARE @TargetDate DATE;
    DECLARE @LastDateOfYear DATE;

    -- Calculate the start date of the week
    SET @WeekStartDate = DATEADD(WEEK, @WeekNumber - 1, DATEADD(YEAR, @Year - 1900, 0));

    -- Find the target date based on the day of the week
    IF @DayOfWeek BETWEEN 1 AND 7
    BEGIN
        SET @TargetDate = DATEADD(DAY, @DayOfWeek - DATEPART(WEEKDAY, @WeekStartDate), @WeekStartDate);
    END
    ELSE
    BEGIN
        -- Get the last date of the year
        SET @LastDateOfYear = DATEFROMPARTS(@Year, 12, 31);

        -- If the day of week is invalid, return the last day of the year within the same week
        SET @TargetDate = DATEADD(DAY, 6 - DATEPART(WEEKDAY, @LastDateOfYear), @LastDateOfYear);
    END

    RETURN CASE WHEN YEAR(@TargetDate) != @Year then datefromparts(@Year,12,31) else @TargetDate end;
END;