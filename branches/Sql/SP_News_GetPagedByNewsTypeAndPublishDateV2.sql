-- =============================================
-- Create date: 2009-10-11
-- =============================================
CREATE PROCEDURE [dbo].[News_GetPagedByNewsTypeAndPublishDateV2]
	@RemarkType INT,
    @NewsType INT ,
    @STime DATETIME,
	@ETime DATETIME,
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
	IF (@RemarkType=1)--Video
	BEGIN
		IF (@PublishStatus=2) --ALL
		BEGIN
		
				INSERT INTO 
				@Results (Id)
				SELECT	NewsId  
				FROM dbo.newsinfo WITH(NOLOCK)	
				WHERE NewsType=@NewsType 
				AND PublishDate>=@STime 
				AND PublishDate<=@ETime
				AND Remark='video'		
				ORDER BY PublishDate DESC 	,NewsId DESC 	
		END
		ELSE 
		BEGIN
				INSERT INTO 
				@Results (Id)
				SELECT	NewsId  
				FROM dbo.newsinfo WITH(NOLOCK)	
				WHERE [Status] =@PublishStatus 	 
				AND NewsType=@NewsType	
				AND PublishDate>=@STime 
				AND PublishDate<=@ETime
				AND Remark='video'		
				ORDER BY PublishDate DESC 	,NewsId DESC 	
		END 
	END
	ELSE
	BEGIN
		IF (@PublishStatus=2) --ALL
		BEGIN
		
				INSERT INTO 
				@Results (Id)
				SELECT	NewsId  
				FROM dbo.newsinfo WITH(NOLOCK)	
				WHERE NewsType=@NewsType	
				AND PublishDate>=@STime 
				AND PublishDate<=@ETime
				AND Remark<>'video'		
				ORDER BY PublishDate DESC 	,NewsId DESC 	
		END
		ELSE 
		BEGIN
				INSERT INTO 
				@Results (Id)
				SELECT	NewsId  
				FROM dbo.newsinfo WITH(NOLOCK)	
				WHERE [Status] =@PublishStatus 	 
				AND NewsType=@NewsType	
				AND PublishDate>=@STime 
				AND PublishDate<=@ETime
				AND Remark<>'video'		
				ORDER BY PublishDate DESC 	,NewsId DESC 	
		END 
	END
	
	
		
	SET @NumberOfCount = @@ROWCOUNT
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
		FROM dbo.newsinfo t WITH(NOLOCK)
		INNER JOIN @Results r ON  (t.NewsId = r.Id)	
		WHERE 
			r.Pos BETWEEN @StartRow AND @RowCount	
	   ORDER BY PublishDate DESC 	,NewsId DESC 	
  
END
	
 

GO
