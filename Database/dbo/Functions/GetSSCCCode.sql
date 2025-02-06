
CREATE function [dbo].[GetSSCCCode](@OrderID INT)
returns varchar(20)
as
begin
   --SET @OrderID = 
   DECLARE @WalmartVendorID INT ,@SSCCCode varchar(20),@CheckNum INT,@TotalAtOdd INT,@TotalAtEven INT,@TotalOddEven INT
   SET @WalmartVendorID = 613471
   SET @SSCCCode = '00' + CONVERT(varchar(6),@WalmartVendorID) + REPLACE(STR(CONVERT(VARCHAR(9),@OrderID), 9), SPACE(1), '0')  
   DECLARE @Counter INT
   SET @Counter = 1
   --print @SSCCCode
   SET @TotalAtOdd = 0
   SET @TotalAtEven = 0
   WHILE @Counter <= len(@SSCCCode)
   BEGIN
		
		--PRINT CONVERT(varchar(20), @Counter % 2 )
	   IF @Counter % 2 = 1
	   BEGIN
		--PRINT convert(varchar(20),@Counter) + ' - ' + convert(varchar(20),CONVERT(INT,substring(@SSCCCode,@Counter,1)))
			SET @TotalAtOdd += 	CONVERT(INT,substring(@SSCCCode,@Counter,1))
		END
		else
			SET @TotalAtEven += CONVERT(INT,substring(@SSCCCode,@Counter,1))
		
	   SET @Counter += 1
	END
	--PRINT convert(varchar(20),@TotalAtOdd)
	SET @TotalAtOdd = (@TotalAtOdd * 3)
	SET @TotalOddEven = @TotalAtOdd + @TotalAtEven
	DECLARE @LastNumber INT
	SET @LastNumber = CONVERT(INT,substring(convert(varchar(20),@TotalOddEven),len(CONVERT(varchar(20),@TotalOddEven)),1))
	IF @LastNumber = 0
		SET @CheckNum = 0
	ELSE
		SET @CheckNum = 10 - @LastNumber
	--PRINT convert(varchar(20),@CheckNum)
	SET @SSCCCode = '00' + @SSCCCode + CONVERT(varchar(1),@CheckNum)
	RETURN @SSCCCode
end
