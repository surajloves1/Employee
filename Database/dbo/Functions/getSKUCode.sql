CREATE   FUNCTION dbo.getSKUCode
(
)
RETURNS CHAR(5)
AS
BEGIN
	DECLARE @result VARCHAR(5);

	WITH seq AS
	(
		SELECT 
			--ROW_NUMBER() OVER (ORDER BY x.alpha + y.number + z.number) AS Id,
			CAST(x.alpha + y.number + z.number as varchar(3)) AS Result
		FROM 
			(
				VALUES 
				--('0'), ('1'), ('2'), ('3'), ('4'), ('5'), ('6'), ('7'), ('8'), ('9'),
				('A'), ('B'), ('C'), ('D'), ('E'), ('F'), ('G'), ('H'), ('I'), ('J'), 
				('K'), ('L'), ('M'), ('N'), ('O'), ('P'), ('Q'), ('R'), ('S'), ('T'), 
				('U'), ('V'), ('W'), ('X'), ('Y'), ('Z')
			) x(alpha),
			(
				VALUES 
				(''), ('0'), ('1'), ('2'), ('3'), ('4'), ('5'), ('6'), ('7'), ('8'), ('9')
			) y(number),
			(
				VALUES 
				('0'), ('1'), ('2'), ('3'), ('4'), ('5'), ('6'), ('7'), ('8'), ('9')
			) z(number)
		WHERE
			NOT (NOT x.alpha BETWEEN '1' AND '9' AND y.number = '0' AND z.number = '0')
	)
	SELECT	TOP 1
			@result	= Result
	FROM	seq
	WHERE	NOT EXISTS 
	(
		SELECT	1
		FROM	Ref_AuditInfo
		WHERE	vSKUCode = seq.Result
	);

	RETURN @result;
END;
--SELECT Result FROM seq WHERE Id = (SELECT Id + 1 FROM seq WHERE Result = 'Z01')