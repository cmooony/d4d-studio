USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Music_GetMusicSongListByMusicId]    Script Date: 10/26/2009 18:22:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- Description:	Add One Music SongList
-- =============================================
ALTER PROCEDURE [dbo].[Music_GetMusicSongListByMusicId]    
 @PublishStatus INT ,
   @MusicId AS INT    
AS
BEGIN	
	IF ( @PublishStatus =2)
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
    WHERE MusicId =  @MusicId
 END
 ELSE
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
    WHERE MusicId =  @MusicId AND  [Status]= @PublishStatus
 END 
END
