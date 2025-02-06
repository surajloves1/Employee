CREATE FUNCTION [dbo].[GetWorkingHours] 
(
    @StartDate DATETIME,
    @FinishDate DATETIME
)
RETURNS BIGINT
AS
BEGIN
    DECLARE @Temp BIGINT,@HolidayDate datetime,@TempStartDate datetime
	SET @TempStartDate = @StartDate
    SET @Temp=0
    SET @Temp = DATEDIFF(hour,@StartDate,@FinishDate)
	--PRINT 'FRIST:' +  Convert(varchar(20),@Temp)
	DECLARE curHolidays CURSOR FAST_FORWARD FOR
						SELECT dHolidayDate FROM Ref_Holidays WHERE (dHolidayDate BETWEEN CONVERT(DATE,@StartDate) AND CONVERT(DATE,@FinishDate))
							AND DATEPART(DW,dHolidayDate) NOT IN (7,1)
							
					OPEN curHolidays
					FETCH NEXT FROM curHolidays INTO @HolidayDate
					WHILE @@FETCH_STATUS = 0
					BEGIN 
						IF @HolidayDate = convert(date,@StartDate) AND @HolidayDate = convert(date,@FinishDate)
							SET @Temp = @Temp - DATEDIFF(hour,@StartDate,@FinishDate)
						ELSE IF @HolidayDate = convert(date,@StartDate)
						BEGIN
							--PRINT '24-date is:' + convert(varchar(20),(24-(datepart(hour,@StartDate))))
							SET @Temp = @Temp - (24-(datepart(hour,@StartDate)))
						END
						ELSE IF @HolidayDate = convert(date,@FinishDate)
						BEGIN
							SET @Temp = @Temp - datepart(hour,@FinishDate)
						END
						ELSE 
						BEGIN
							
							SET @Temp = @Temp - 24
							--PRINT 'AFTER -24 is:' +CONVERT(varchar(20), @Temp)
						END
						FETCH NEXT FROM curHolidays INTO @HolidayDate
					END
					Close curHolidays
					Deallocate curHolidays
	

	WHILE CONVERT(DATE,@StartDate) <= CONVERT(DATE,@FinishDate)
	BEGIN
		IF DATEPART(DW,@StartDate) IN (7,1)
		BEGIN
			--PRINT 'I am here:'
			--PRINT 'DATE DIFF: ' + CONVERT(varchar(20),DATEDIFF(hour,@StartDate,@FinishDate))
			IF DATEDIFF(hour,@StartDate,@FinishDate) < 24
			BEGIN
				IF DATEDIFF(hour,@TempStartDate,@FinishDate) < 24
					SET @Temp = @Temp - DATEDIFF(hour,@StartDate,@FinishDate)
				ELSE
					SET @Temp = @Temp - DATEPART(hour,@FinishDate)
			END
			ELSE
				SET @Temp = @Temp - 24

		END
		SET @StartDate = DATEADD(day,1,@StartDate)
	END
	--PRINT Convert(varchar(20),@Temp)
	IF @Temp <0 
		SET @Temp = 0
	RETURN @Temp

END

