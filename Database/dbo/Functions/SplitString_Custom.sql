CREATE FUNCTION dbo.SplitString_Custom
(
    @String NVARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @Result TABLE (Item NVARCHAR(MAX))
AS
BEGIN
    DECLARE @Pos INT;

    WHILE CHARINDEX(@Delimiter, @String) > 0
    BEGIN
        SET @Pos = CHARINDEX(@Delimiter, @String);
        INSERT INTO @Result (Item) VALUES (SUBSTRING(@String, 1, @Pos - 1));
        SET @String = SUBSTRING(@String, @Pos + 1, LEN(@String) - @Pos);
    END;

    INSERT INTO @Result (Item) VALUES (@String);

    RETURN;
END;