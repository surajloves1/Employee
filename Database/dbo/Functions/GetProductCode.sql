CREATE function [dbo].[GetProductCode](@iPlanID INT,@ManufacturerID INT, @ManufacturerCode varchar(50),@CategoryID INT,@ModelNumber varchar(50),@FunctionalStatus varchar(50),@Grade varchar(50),@BuildAttributes BIT)
--returns varchar(100)
RETURNS @ProductCodeInformation TABLE 
(
	ProductCode varchar(100),
	ModelPrefix varchar(100),
	Specification varchar(100),
	GroupCode varchar(100),
	CategoryID INT,
	ManufacturerCode varchar(50),
	CategoryCode varchar(2),
	PartNumber varchar(50),
	CurrentGrade varchar(10)
)
as
begin
	DECLARE @CategoryCode varchar(5),@AuditGrade varchar(5),@PartNumber varchar(50)
	IF @ManufacturerID IS NULL AND @CategoryID IS NULL 
	BEGIN
		SELECT @ModelNumber = vMfgModelNumber,@FunctionalStatus = vFinalFunctionalStatus,@Grade = vFinalGrade,@ManufacturerID = iMfg,@CategoryID = iCategory,@AuditGrade = vAuditGrade,@PartNumber = vMfgPartNumber
			FROM ViewAuditStandard WHERE iScanID = @iPlanID
	END
	IF LEN(ISNULL(@PartNUmber,'')) < 4
		SET @PartNumber = ''
	IF @ManufacturerCode IS NULL
		SELECT @ManufacturerCode = vRef1 FROM Ref_Main WHERE vReferenceID = 'iMFG' AND iRefMainID = @ManufacturerID
	IF @ManufacturerCode = ''
		SET @ManufacturerCode = null
	
	DECLARE @ProductCode varchar(100), @ModelPrefix varchar(100),@Specification varchar(100),@GroupCode varchar(100)
    SET @ProductCode = ''
	SELECT @ProductCode = vProductCode FROM Ref_Cat WHERE iCatID = @CategoryID
 IF ISNULL(@ProductCode,'') = ''
	SET @ProductCode = 'XX'
 SET @CategoryCode = @ProductCode
 SET @ManufacturerCode = ISNULL(@ManufacturerCode,'XX')
 IF (@CategoryID in(225,205,206,83,226)) OR (@CategoryID = 97 AND @ManufacturerID IN(315,169))  -- For Dell, HP and Lenovo Chromebooks
	SET @ProductCode += '-' + @ManufacturerCode + '-' + ISNULL(@ModelNumber,'') + '-' + ISNULL(@PartNumber,'')
 ELSE
	SET @ProductCode += '-' + @ManufacturerCode + '-' + (CASE WHEN (@CategoryID in (83,205,225,86) OR (@CategoryID = 34 AND @ManufacturerID = 315)) THEN ISNULL(@PartNumber,'') ELSE ISNULL(@ModelNumber,'') END)
 IF @CategoryID = 86 -- Monitor
	SET @ProductCode += '-' + ISNULL(@ModelNumber,'')
 SET @GroupCode = @ProductCode
 IF @CategoryID in (34,97,138,205,83,225,206,226)
 BEGIN
	IF @BuildAttributes = 1
	BEGIN
		DECLARE @FormFactorNB varchar(10),@FormFactorSystem varchar(10),@CPUType varchar(10),@CPUSpeed varchar(10),@RAM varchar(10),@HDD varchar(10),@Optical varchar(10),@WebCam char(1),@OS varchar(10),
			@Color varchar(20),@Carrier varchar(30),@TouchScreen varchar(2),@Wifi char(1)
		
		
		BEGIN
			SELECT @FormFactorNB = rmFF.vRef1,
			@FormFactorSystem = rmFF1.vRef1,
			@CPUType = rmCT.vRef1,
			@CPUSpeed = rmCS.vRef1,
			@RAM = rmMem.vRef1,
			@HDD = rmHDD.vRef1,
			@WebCam = acd.cWebcam,
			@OS = rmOS.vRef1,
			@TouchScreen = acd.cTouchScreen,
			@Carrier = rmCar.vRef1,
			@Color = rmCol.vRef1,
			@Wifi = acd.cWifi
			FROM Detail_AssetConfigDynamic acd
			LEFT JOIN Ref_Main rmFF on acd.iType_Notebook = rmFF.iRefMainID and rmFF.vReferenceID = 'iType_Notebook'
			LEFT JOIN Ref_Main rmFF1 on acd.iType_System = rmFF1.iRefMainID and rmFF1.vReferenceID = 'iType_System'
			LEFT JOIN Ref_Main rmCT on acd.iProcessorType = rmCT.iRefMainID and rmCT.vReferenceID = 'iProcessorType'
			LEFT JOIN Ref_Main rmCS on acd.iProcessorSpeed = rmCS.iRefMainID and rmCS.vReferenceID = 'iProcessorSpeed'
			LEFT JOIN Ref_Main rmMem on acd.iMemory = rmMem.iRefMainID and rmMem.vReferenceID = 'iMemory'
			LEFT JOIN Ref_Main rmHDD on acd.iHDDSize = rmHDD.iRefMainID and rmHDD.vReferenceID = 'iHDDSize'
			LEFT JOIN Ref_Main rmOS on acd.iOSInstalled = rmOS.iRefMainID and rmOS.vReferenceID = 'iOSInstalled'
			LEFT JOIN Ref_Main rmCar on acd.iMobileCarrier = rmCar.iRefMainID and rmCar.vReferenceID = 'iMobileCarrier'
			LEFT JOIN Ref_Main rmCol on acd.iColor = rmCol.iRefMainID and rmCol.vReferenceID = 'iColor'
			WHERE acd.cAuditFinal = 'F' and acd.iScanID = @iPlanID

			IF @CategoryID in (97) -- notebook
				SET @ProductCode += '-' + ISNULL(@FormFactorNB,'*')
			ELSE IF @CategoryID in (83,205) --Smart/Mobile Phones and Tablet
			BEGIN
				SET @ProductCode += '-' + ISNULL(@HDD,'*')
				IF @CategoryID = 83
					SET @ProductCode += '-' + ISNULL(@Carrier,'*')
			END
			ELSE IF @CategoryID in (225) -- Chromebooks
				SET @ProductCode += '-' + ISNULL(@CPUType,'*') + '-' + ISNULL(@CPUSpeed,'*') + '-' + ISNULL(@RAM,'*') + '-' + ISNULL(@HDD,'*') 
			ELSE IF @CategoryID = 226
				SET @ProductCode += '-' + ISNULL(@Color,'*')
			ELSE IF @CategoryID != 206
				SET @ProductCode += '-' + ISNULL(@FormFactorSystem,'*')
			SET @GroupCode = @ProductCode + '-' + ISNULL(@CPUType,'*') + '-' + ISNULL(@RAM,'*') + '-' + ISNULL(@HDD,'*') + '-' + ISNULL(@OS,'*')
			IF @CategoryID NOT IN (83,205,225,226)
				SET @ProductCode += '-' + ISNULL(@CPUType,'*') + '-' + ISNULL(@CPUSpeed,'*') + '-' + ISNULL(@RAM,'*') + '-' + ISNULL(@HDD,'*') + '-' + ISNULL(@OS,'*')
			IF @CategoryID IN (97,225,261) AND ISNULL(@TouchScreen,'') = 'Y'
			BEGIN
				SET @ProductCode += '-' + @TouchScreen
			END
			IF @CategoryID in (86,206)
			BEGIN
				IF EXISTS(SELECT 1 FROM Detail_AuditInfo WHERE iScanID = @iPlanID AND cAuditOrFinal = 'F' and iAuditInfoID = 3850 and iAuditType = 4)
					SET @ProductCode += '-NS'
			END
			IF @CategoryID = 34 AND @Wifi = 'Y'
				SET @ProductCode += '-WIFI'
			SET @ModelPrefix = @ModelNumber + '/' + ISNULL(@CPUType,'*')
			SET @Specification = ISNULL(@RAM,'*') + '/' + ISNULL(@HDD,'*') + '/' + ISNULL(@OS,'*')
		END
		
	END
	
	ELSE
	BEGIN
		SET @ProductCode += '-*-*-*-*-*-*-*'
		SET @GroupCode += '-*-*-*-*-*'
	END
 END
 ELSE IF @CategoryID = 86 -- Monitor
	BEGIN
		IF @BuildAttributes = 1
		BEGIN
			DECLARE @ScreenSize varchar(20)
			SELECT @ScreenSize = rmss.vDescription
			FROM Detail_AssetConfigDynamic acd
			LEFT JOIN Ref_Main rmSS on acd.iScreenSize = rmSS.iRefMainID and rmSS.vReferenceID = 'iScreenSize'
			WHERE acd.cAuditFinal = 'F' and acd.iScanID = @iPlanID
			SET @ProductCode += '-' + ISNULL(@ScreenSize,'*')

			IF EXISTS(SELECT 1 FROM Detail_AuditInfo WHERE iScanID = @iPlanID AND cAuditOrFinal = 'F' and iAuditInfoID IN (3850,4186) and iAuditType = 4)
					SET @ProductCode += '-NS'

		END
	END
 --IF @CategoryID not in (83,205)
 BEGIN
	 DECLARE @OverAllGrade varchar(5)
	 SET @OverAllGrade = dbo.FN_GetOverallGrade(@FunctionalStatus,@Grade)
	 SET @ProductCode += '-' + @OverAllGrade
	 SET @GroupCode += '-' + @OverAllGrade
END
  
 --RETURN @ProductCode
 INSERT @ProductCodeInformation
        SELECT @ProductCode,@ModelPrefix,@Specification,@GroupCode,@CategoryID,@ManufacturerCode,@CategoryCode,@PartNumber,@Grade
 RETURN;
end


