CREATE FUNCTION [dbo].[FN_GetOverallGrade] (
  @FunctionalStatus varchar(50),
  @Grade varchar(20)
) RETURNS VARCHAR(10)     
BEGIN         
	DECLARE @OverallGrade varchar(10)
	SET @OverallGrade = ''
	IF @FunctionalStatus IN ('Functional','Functional-M','Functional-N') AND @Grade='A'
		SET @OverallGrade = 'A'
	ELSE IF (@FunctionalStatus like 'Functional%' and @Grade='B') OR (@FunctionalStatus = 'Functional-NOB' and @Grade='A')
		SET @OverallGrade = 'B'
	ELSE IF @FunctionalStatus like 'Functional%' and @Grade='C'
		SET @OverallGrade = 'C'
	ELSE IF @Grade='R'
		SET @OverallGrade = 'R'
	ELSE IF @FunctionalStatus = 'Non-Functional' OR @Grade='D'
		SET @OverallGrade = 'D'
	ELSE IF @FunctionalStatus = 'Not Tested' and @Grade='R'
		SET @OverallGrade = 'R'
	ELSE IF @Grade='L'
		SET @OverallGrade = 'L'
	ELSE IF @FunctionalStatus = 'Not Tested' AND @Grade != 'R'
		SET @OverallGrade = 'X'

	RETURN @OverallGrade
END 

