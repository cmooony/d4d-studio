USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[BandInfo_GetAll]    Script Date: 10/26/2009 18:17:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- =============================================
ALTER PROCEDURE [dbo].[BandInfo_GetAll] 
   @MinIndex INT  
AS
BEGIN	
	
    SELECT 
               BandId, 
               BandName,
			   Info1,
			   Info2,
			   Info3,
			   Remark
    FROM bandinfo With(nolock)
    WHERE  DeleteFlag = 0 AND BandId>=@MinIndex
 
END
