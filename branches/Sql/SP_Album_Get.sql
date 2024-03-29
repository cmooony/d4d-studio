USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Album_Get]    Script Date: 10/26/2009 18:15:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- =============================================
ALTER PROCEDURE [dbo].[Album_Get]   
   @AlbumId AS INT 
AS
BEGIN	
	
    SELECT 
               AlbumId, 
               Title,
			   BandId,
			   PublishDate,
			   PublishYear,
			   PublishMonth,
			   AddUserId,
			   AddDate,
			   [Status],
			   TotalCount,
			  SImage,
			  LImage
    FROM albums With(nolock)
    WHERE AlbumId =  @AlbumId
 
END
