USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Image_Delete]    Script Date: 10/26/2009 18:19:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- Description:	Delete   Image
-- =============================================
ALTER PROCEDURE [dbo].[Image_Delete]
   @ImageId AS INT 
AS
BEGIN	 

    DECLARE @NEWCOUNT AS INT
    DECLARE @DeleteAlbumID AS INT
   
   SELECT @DeleteAlbumID=AlbumId FROM images
   WHERE  ImageId = @ImageId 
   
   
   DELETE FROM images
   WHERE  ImageId = @ImageId
   
   SELECT @NEWCOUNT = COUNT(ImageID) FROM images
   WHERE AlbumId = @DeleteAlbumID
   
   UPDATE albums
   SET TotalCount = @NEWCOUNT
    WHERE AlbumId = @DeleteAlbumID
	
END
