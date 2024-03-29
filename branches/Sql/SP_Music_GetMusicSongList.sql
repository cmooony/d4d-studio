USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Music_GetMusicSongList]    Script Date: 10/26/2009 18:22:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- Description:	Get  Music SongList
-- =============================================
ALTER PROCEDURE [dbo].[Music_GetMusicSongList]    
   @ListId AS INT 
AS
BEGIN	
	
    SELECT 
              ListId, 
              MusicId,
			   SongName,
			   SongFile,
			   SongTime,
			   AddUserId,			 		
			   AddDate,
			  [Status]
    FROM music_songlist With(nolock)
    WHERE ListId =  @ListId
 
END
