USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[BandInfo_Set]    Script Date: 10/20/2009 21:00:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		xinweifeng
-- Create date: 2009-10-11
-- Description:	Add Or Set Album
-- =============================================
CREATE PROCEDURE [dbo].[BandInfo_Set]
   @BandId AS INT ,
   @BandName AS NVARCHAR(50),    
   @Info1 AS NVARCHAR(1000),
  @Info2 AS NVARCHAR(1000),
  @Info3 AS NVARCHAR(1000),
  @Remark AS NVARCHAR(200),
   @DeleteFlag AS INT
AS
BEGIN
	
	SET NOCOUNT ON;
  
    IF (@BandId<=0)
   BEGIN 
	INSERT INTO bandinfo
			   (BandName,
			   Info1,
			   Info2,
			   Info3,
			   Remark,
			  DeleteFlag 
			   )
		 VALUES
			   (@BandName,
			   @Info1,
			   @Info2,
			   @Info3,
			   @Remark,
			  0 
			 )
		SET @BandId = 	 @@IDENTITY 
   END
   ELSE
   BEGIN
    UPDATE bandinfo
    SET  BandName = @BandName,Info1=@Info1,Info2= @Info2,
    Info3=@Info3,Remark=@Remark,DeleteFlag=@DeleteFlag
    WHERE @BandId =  @BandId
   END
	
	RETURN @BandId
END
