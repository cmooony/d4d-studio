USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Image_GetPagedByTag]    Script Date: 10/26/2009 18:20:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- =============================================
ALTER PROCEDURE [dbo].[Image_GetPagedByTag]  
    @TagId AS INT ,
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
			SELECT	ImageId  
			FROM dbo.images WITH(NOLOCK)		
			 WHERE ImageId IN
			(SELECT ObjectId   FROM tag_relation WITH(NOLOCK) 
			WHERE TagId = @TagId AND ObjectType=5)--4 is image 5 is album					
			ORDER BY PublishDate DESC 	
	END
	ELSE 
	BEGIN
	        INSERT INTO 
			@Results (Id)
			SELECT	ImageId  
			FROM dbo.images WITH(NOLOCK)	
			WHERE [Status] =@PublishStatus AND	 ImageId IN
			(SELECT ObjectId   FROM tag_relation WITH(NOLOCK) 
			WHERE TagId = @TagId AND ObjectType=5)--4 is image 5 is album					
		
			ORDER BY PublishDate DESC 	
	END 
	
		
	SET @NumberOfCount = @@ROWCOUNT


		SELECT   
		       ImageId, 
               AlbumId,
               ImageName,
			   ImageFile,			 
			   AddUserId,
			   AddDate,
			   [Status],			 
			  SImageFile,
			  PublishDate
		FROM dbo.images t WITH(NOLOCK)
		INNER JOIN @Results r ON  (t.ImageId = r.Id)	
		WHERE 
			r.Pos BETWEEN @StartRow AND @RowCount	
	   ORDER BY PublishDate DESC 	
  
END




	

 

