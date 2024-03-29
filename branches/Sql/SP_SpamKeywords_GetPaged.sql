USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[News_GetPaged]    Script Date: 11/01/2009 20:24:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- =============================================
CREATE PROCEDURE [dbo].[SpamKeywords_GetPaged]  
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


	        INSERT INTO 
			@Results (Id)
			SELECT	Id  
			FROM dbo.SpamKeywords WITH(NOLOCK)			
			ORDER BY Id DESC 	

	
		
	SET @NumberOfCount = @@ROWCOUNT


		SELECT   
		        t.id ,
               Keyword,
			   [Status],
			   AddUserId,
			   AddDate
		FROM dbo.SpamKeywords t WITH(NOLOCK)
		INNER JOIN @Results r ON  (t.Id = r.Id)	
		WHERE 
			r.Pos BETWEEN @StartRow AND @RowCount	
	  ORDER BY t.Id DESC 	
  
END




	

 

