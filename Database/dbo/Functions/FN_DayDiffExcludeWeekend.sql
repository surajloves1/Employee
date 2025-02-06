CREATE FUNCTION [dbo].[FN_DayDiffExcludeWeekend] (
  @startdate date,
  @enddate date
) RETURNS int     
BEGIN         
	DECLARE @daydifference int
	DECLARE @totaldays INT
	DECLARE @weekenddays INT
	SET @daydifference = 0
	SET @totaldays = DATEDIFF(DAY, @startDate, @endDate) 
	SET @weekenddays = ((DATEDIFF(WEEK, @startDate, @endDate) * 2) + -- get the number of weekend days in between
                       CASE WHEN DATEPART(WEEKDAY, @startDate) = 1 THEN 1 ELSE 0 END + -- if selection was Sunday, won't add to weekends
                       CASE WHEN DATEPART(WEEKDAY, @endDate) = 6 THEN 1 ELSE 0 END)  -- if selection was Saturday, won't add to weekends

	SET @daydifference = @totaldays - @weekenddays

	RETURN @daydifference
END