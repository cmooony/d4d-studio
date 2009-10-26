USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Image_DeleteByAlbumId]    Script Date: 10/26/2009 18:19:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- Description:	Delete  Images by albumID
-- =============================================
ALTER PROCEDURE [dbo].[Image_DeleteByAlbumId]
   @AlbumId AS INT 
AS
BEGIN	   
   
   DELETE FROM images
   WHERE  AlbumId = @AlbumId  

   
   UPDATE albums
   SET TotalCount = 0
    WHERE AlbumId =@AlbumId
	
END
