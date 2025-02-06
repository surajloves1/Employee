
CREATE function [dbo].[GetWeekNumberStartEndDate](@fromdate varchar(20))
returns table as return 
(
	with n as (select n from (values(0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) t(n))
	, dates as (
	select top (datediff(day, @fromdate, dateadd(month, datediff(month, 0, @fromdate )+1, 0))) 
    [DateValue]=convert(date,dateadd(day,row_number() over(order by (select 1))-1,@fromdate))
	from n as deka cross join n as hecto
	)
	select 
    WeekOfMonth = row_number() over (order by datepart(week,DateValue))
	, Week        = datepart(week,DateValue)
	, WeekStart   = min(DateValue)
	, WeekEnd     = max(DateValue)
	, WeekFrmTo   = convert(varchar(2),month(min(DateValue)))+'/'+convert(varchar(2),day(min(DateValue))) +'-'+ convert(varchar(2),month(max(DateValue)))+'/'+convert(varchar(2),day(max(DateValue)))
	from dates
	group by datepart(week,DateValue)
)
