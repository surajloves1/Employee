CREATE FUNCTION [dbo].[fn_GetProcessingDeadline]
(	
	@AllowedSubstractDays INT,
	@AuditReportDueDeadline DATETIME
)
RETURNS VARCHAR(20)
AS
BEGIN
	
	DECLARE @RetValue DATETIME	
	declare @counter int
	DECLARE @RETURNVALUE VARCHAR(20)
	declare @Dayname varchar(20)
	declare @flgdate bit
	DECLARE @IsAuditReportRequired BIT

	
	set @flgdate = 0
	set @counter = @AllowedSubstractDays	
	
	while(@counter!=0)
		begin--while
		set @Dayname=datepart(dw,@AuditReportDueDeadline)					
		if(@Dayname > 1 and @Dayname < 7) 
			begin
				if(@flgdate = 1)
					set @flgdate = 0								
				else
					begin
						set @AuditReportDueDeadline = 	dateadd(d,-1,@AuditReportDueDeadline)							
					end
				set @Dayname=datename(dw,@AuditReportDueDeadline)
				if(@Dayname ='Saturday')
					set @AuditReportDueDeadline = 	dateadd(d,-1,@AuditReportDueDeadline)
				else if(@Dayname ='Sunday')
					set @AuditReportDueDeadline = 	dateadd(d,-2,@AuditReportDueDeadline)
					
				set @counter=@counter-1	
			end				
		else
			begin
			set @AuditReportDueDeadline = 	dateadd(d,-1,@AuditReportDueDeadline)
			set @flgdate=1
		end
	end--while	
	
	SET @RETURNVALUE = @AuditReportDueDeadline
	SET @RETURNVALUE = CONVERT(VARCHAR(20),@AuditReportDueDeadline,101)
	
	RETURN @RETURNVALUE

END
