USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Album_Delete]    Script Date: 10/26/2009 18:14:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- Description:	Delete   Album
-- =============================================
ALTER PROCEDURE [dbo].[Album_Delete]
   @AlbumId AS INT 
AS
BEGIN	

   DELETE FROM  albums
   WHERE AlbumId = @AlbumId
   
   DELETE FROM images
   WHERE  AlbumId = @AlbumId
	
END
