USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Music_DeleteSongList]    Script Date: 10/26/2009 18:21:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- Description:	Delete  One MusicSonglist
-- =============================================
ALTER PROCEDURE [dbo].[Music_DeleteSongList]
   @ListId AS INT 
AS
BEGIN	

   DELETE FROM  music_songlist
   WHERE ListId = @ListId	
	
END
