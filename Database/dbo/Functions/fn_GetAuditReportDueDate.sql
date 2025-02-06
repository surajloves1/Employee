CREATE FUNCTION [dbo].[fn_GetAuditReportDueDate]
(
	@IJobID INT,
	@iAuditReportDueIn INT,
	@ReceivingDate DATETIME
)
RETURNS VARCHAR(20)
AS
BEGIN
	
	DECLARE @RetValue DATETIME
	--DECLARE @iAuditReportDueIn INT
	--DECLARE @ReceivingDate DATETIME
	declare @counter int
	DECLARE @RETURNVALUE VARCHAR(20)
	declare @Dayname varchar(20)
	declare @flgdate bit
	DECLARE @IsAuditReportRequired BIT

	--SET @iAuditReportDueIn = 0
	--SELECT @iAuditReportDueIn = ISNULL(dj.iAuditReportDueIn,0),@IsAuditReportRequired = ISNULL(dj.bIsAuditReportRequired,0) FROM Detail_Job dj WHERE iJobID = 5

	--SELECT TOP 1 @ReceivingDate = dDateReceived FROM Detail_Load WHERE Detail_Load.iJobId = @IJobID ORDER BY dDateReceived ASC	
	set @flgdate = 0
	set @counter = @iAuditReportDueIn	
	
	while(@counter!=0)
		begin--while
		set @Dayname=datepart(dw,@ReceivingDate)					
		if(@Dayname > 1 and @Dayname < 7) 
			begin
				if(@flgdate = 1)
					set @flgdate = 0								
				else
					begin
						set @ReceivingDate = 	dateadd(d,1,@ReceivingDate)							
					end
				set @Dayname=datename(dw,@ReceivingDate)
				if(@Dayname ='Saturday')
					set @ReceivingDate = 	dateadd(d,2,@ReceivingDate)
				else if(@Dayname ='Sunday')
					set @ReceivingDate = 	dateadd(d,1,@ReceivingDate)
					
				set @counter=@counter-1	
			end				
		else
			begin
			set @ReceivingDate = 	dateadd(d,1,@ReceivingDate)
			set @flgdate=1
		end
	end--while	
	
	SET @RETURNVALUE = @ReceivingDate
	SET @RETURNVALUE = CONVERT(VARCHAR(20),@ReceivingDate,101)
	
	RETURN @RETURNVALUE

END
