create FUNCTION GetStringParts(@SplittedString nvarchar(300), @Part int, @SplitChar nvarchar(1))
Returns nvarchar(300)

as
begin
if(@Part < 1)
        return '';
    declare @Index int = 1, @Result nvarchar(300) = @SplittedString, @PatIndexResult int
    while @Index < @Part
    begin
        set @PatIndexResult = PATINDEX('%' + @SplitChar + '%', @Result)
        if(@PatIndexResult = 0)
            return '';
        set @Result = SUBSTRING(@Result, @PatIndexResult + 1, len(@Result));
        set @Index = @Index + 1;
    end
    set @PatIndexResult = PATINDEX('%' + @SplitChar + '%', @Result);
    if(@PatIndexResult = 0)
        return @Result;
    return substring(@Result, 0, patindex('%' + @SplitChar + '%', @Result));
end