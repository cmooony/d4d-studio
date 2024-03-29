USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[News_GetTopImageNews]    Script Date: 11/02/2009 22:02:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-10
-- Description:	Add One TagsHits
-- =============================================
ALTER PROCEDURE [dbo].[News_GetTopImageNews]  
 @RemarkType AS INT,
 @MaxCount AS INT
AS
BEGIN	
	SET ROWCOUNT @MaxCount	
	
      IF (@RemarkType=1)--Video
      BEGIN
      	SELECT   
		       NewsId ,
               Title,
			   Body,
			   Preview,
			   SImage,
			   LImage,
			   NewsType,
			   Hits,
			   PublishDate,
			   AddUserId,
			   AddDate,
			  [Status],
			  Remark
		FROM dbo.newsinfo  WITH(NOLOCK)
		WHERE Remark='video' AND  [Status] =1
		AND (SImage <> '' AND SIMAGE IS NOT NULL)
		ORDER BY  PublishDate DESC, NewsId DESC
      END
      ELSE
      BEGIN
		  SELECT   
		       NewsId ,
               Title,
			   Body,
			   Preview,
			   SImage,
			   LImage,
			   NewsType,
			   Hits,
			   PublishDate,
			   AddUserId,
			   AddDate,
			  [Status],
			  Remark
		FROM dbo.newsinfo  WITH(NOLOCK)
		WHERE Remark<>'video' AND  [Status] =1
		AND (SImage <> '' AND SIMAGE IS NOT NULL)
		ORDER BY  PublishDate DESC, NewsId DESC
      END
     
     

 
END
