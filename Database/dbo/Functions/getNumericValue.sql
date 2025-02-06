CREATE FUNCTION dbo.getNumericValue
 (
@inputString VARCHAR(256)
)
RETURNS VARCHAR(256)
AS
BEGIN
  DECLARE @integerPart INT
  SET @integerPart = PATINDEX('%[^0-9]%', @inputString)
  BEGIN
    WHILE @integerPart > 0
    BEGIN
      SET @inputString = STUFF(@inputString, @integerPart, 1, '' )
      SET @integerPart = PATINDEX('%[^0-9]%', @inputString )
    END
  END
  RETURN ISNULL(@inputString,0)
END