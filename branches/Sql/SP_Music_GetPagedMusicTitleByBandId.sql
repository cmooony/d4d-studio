USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Music_GetPagedMusicTitleByBandId]    Script Date: 10/26/2009 18:23:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- Description:	Music_GetPagedMusicTitleByBandId
-- =============================================
ALTER PROCEDURE [dbo].[Music_GetPagedMusicTitleByBandId]
   @BandId AS INT ,
   @PublishStatus INT ,
   @PageIndex INT,
	@PageSize INT,	
	@NumberOfCount INT OUTPUT
AS

BEGIN	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET LOCK_TIMEOUT 2000
	
	DECLARE @StartRow int
	IF @PageIndex = 0
		SET @PageIndex = 1
	SET @StartRow = (@PageIndex -1) * @PageSize + 1
	
	DECLARE @Results TABLE (Pos INT IDENTITY, Id INT)
	
	DECLARE @RowCount int
	SET @RowCount = @PageSize + @StartRow - 1

	
	IF (@PublishStatus=2) --ALL
	BEGIN
	
			INSERT INTO 
			@Results (Id)
			SELECT	MusicId  
			FROM dbo.music_title WITH(NOLOCK)		
			WHERE BandId=@BandId
			ORDER BY PublishDate DESC 	
	END
	ELSE 
	BEGIN
			INSERT INTO 
			@Results (Id)
			SELECT	MusicId  
			FROM dbo.music_title WITH(NOLOCK)		
			WHERE  [Status] =@PublishStatus AND  BandId=@BandId
			ORDER BY PublishDate DESC 	
	END
		
	SET @NumberOfCount = @@ROWCOUNT


		SELECT   
		       MusicId, 
               Title,
			   Body,
			   SImage,
			   LImage,
			   BandId,
			   PublishDate,
			   PublishYear,
			   AddUserId,
			   AddDate,
			  [Status]
		FROM dbo.music_title t WITH(NOLOCK)
		INNER JOIN @Results r ON  (t.MusicId = r.Id)	
		WHERE 
			r.Pos BETWEEN @StartRow AND @RowCount	
	   ORDER BY PublishDate DESC 	
  
END
 

