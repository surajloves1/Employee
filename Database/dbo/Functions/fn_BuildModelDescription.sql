CREATE FUNCTION [dbo].[fn_BuildModelDescription]
(
	@iScanID INT,
	@cAuditOrFinal char(1)
)
RETURNS VARCHAR(300)
AS
BEGIN

	DECLARE @xmlstring XML
	declare @FieldName varchar(50)
	declare @DynamicValue varchar(100)
	declare @ModelDescription varchar(300)
	declare @CurrentDescription varchar(100)
	declare @iClassCatNumber INT
	SET @ModelDescription = ''
	IF @cAuditOrFinal = 'F'
	BEGIN
		SET @xmlstring =  
		(
		  SELECT   *
		  from 
		  InventoryAllFields4ModelDescBuild  where iScanID = @iScanID 
		   FOR XML AUTO
		 )
	END
	ELSE
	BEGIN
		SET @xmlstring =  
		(
		  SELECT   *
		  from 
		  InventoryAllFields4ModelDescBuild  where iScanID = @iScanID 
		   FOR XML RAW ('InventoryAllFields4ModelDescBuild')
		 )
	END
	 SET @FieldName = 'iClassCatNumber'
	 SELECT @iClassCatNumber = 
				Xtbl.Config.value('(@*[local-name() = sql:variable("@FieldName")])[1]', 'varchar(50)') 
				FROM @xmlstring.nodes('/InventoryAllFields4ModelDescBuild') as Xtbl(Config)

	 DECLARE @vFieldName varchar(100), @vTextBefore varchar(100), @vTextAfter varchar(100)
	DECLARE CurBuild CURSOR FAST_FORWARD FOR         
	SELECT vFieldName,vTextBefore,vTextAfter FROM Build_ModelDescription WHERE iClassCatNumber = @iClassCatNumber
		AND cAuditFinal = @cAuditOrFinal
		ORDER by iDescriptionOrder
	OPEN CurBuild        
	FETCH NEXT FROM CurBuild         
	INTO @vFieldName, @vTextBefore, @vTextAfter    
	WHILE @@FETCH_STATUS = 0        
	BEGIN
		SET @CurrentDescription = ''
		IF @vFieldName IS NULL
			SET @CurrentDescription = ISNULL(@vTextBefore,'') + '' + ISNULL(@vTextAfter,'')
		ELSE
		BEGIN
			SET @FieldName = 'v' + SUBSTRING(@vFieldName,2,len(@vFieldName))
			SELECT @DynamicValue =
				Xtbl.Config.value('(@*[local-name() = sql:variable("@FieldName")])[1]', 'varchar(50)') 
				FROM @xmlstring.nodes('/InventoryAllFields4ModelDescBuild') as Xtbl(Config)
			IF ISNULL(@DynamicValue,'') !='' AND @DynamicValue NOT IN ('Missing','Not-Determined','NA','N/A')
			BEGIN
				IF @FieldName = 'vWebcam'
				BEGIN
					IF @DynamicValue = 'Y'
						SET @CurrentDescription = 'WebCam,'
				END
				--ELSE IF @FieldName = 'vOSInstalled' AND ISNULL(@DynamicValue,'') like 'Win %'
					--SET @CurrentDescription = LTRIM(RTRIM(REPLACE(ISNULL(@vTextBefore,'') + '' + Replace(ISNULL(@DynamicValue,''),'Win ', 'Windows ') + '' + ISNULL(@vTextAfter,''),'  ',' ')))
				ELSE
					SET @CurrentDescription = REPLACE(ISNULL(@vTextBefore,'') + '' + LTRIM(RTRIM(ISNULL(@DynamicValue,''))) + '' + ISNULL(@vTextAfter,''),'  ',' ')
			END
		END
		IF ISNULL(@CurrentDescription,'') !=''
			SET @ModelDescription = @ModelDescription + (CASE WHEN @CurrentDescription like ',%' THEN @CurrentDescription ELSE CASE WHEN @FieldName = 'vProcessorSpeed' THEN '' ELSE ' ' END + @CurrentDescription END)
		FETCH NEXT FROM CurBuild         
		INTO @vFieldName, @vTextBefore, @vTextAfter    
        
	END    
    Close CurBuild    
    Deallocate CurBuild 
	select @ModelDescription = case when right(rtrim(@ModelDescription),1) = ',' then substring(rtrim(@ModelDescription),1,len(rtrim(@ModelDescription))-1) else @ModelDescription END
	RETURN REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(@ModelDescription)),'  ',' '),',,,',','),',,',',')
END



