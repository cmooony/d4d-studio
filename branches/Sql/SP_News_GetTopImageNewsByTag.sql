USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[News_GetTopImageNewsByTag]    Script Date: 11/02/2009 22:05:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-10
-- Description:	Add One TagsHits
-- =============================================
ALTER PROCEDURE [dbo].[News_GetTopImageNewsByTag]  
 @RemarkType AS INT,
 @MaxCount AS INT,
 @TagId INT
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
		WHERE  Remark='video' 
		AND  [Status] =1		
		AND (SImage <> '' AND SIMAGE IS NOT NULL)
		AND NewsId IN
		(SELECT ObjectId    FROM tag_relation WITH(NOLOCK) WHERE TagId = @TagId AND ObjectType=1)--1 is News					
		ORDER BY PublishDate DESC, NewsId DESC
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
		WHERE  Remark<>'video'
		 AND  [Status] =1		
		AND (SImage <> '' AND SIMAGE IS NOT NULL)
		AND NewsId IN
		(SELECT ObjectId    FROM tag_relation WITH(NOLOCK) WHERE TagId = @TagId AND ObjectType=1)--1 is News					
	
		ORDER BY PublishDate DESC, NewsId DESC
      END
     
     

 
END
