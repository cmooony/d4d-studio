USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Album_Set]    Script Date: 10/26/2009 18:16:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- Description:	Add Or Set Album
-- =============================================
ALTER PROCEDURE [dbo].[Album_Set]
   @AlbumId AS INT ,
   @Title AS NVARCHAR(1000),    
   @SImage AS NVARCHAR(1000),
   @LImage AS NVARCHAR(1000),
   @BandId AS INT,
   @PublishDate AS DATETIME,
   @PublishYear AS INT,
   @PublishMonth AS INT,
   @AddUserId AS INT,   
   @Status AS INT,
   @TotalCount AS INT
AS
BEGIN
	
	SET NOCOUNT ON;
  
    IF (@AlbumId<=0)
   BEGIN 
	INSERT INTO albums
			   (Title,
			   BandId,
			   PublishDate,
			   PublishYear,
			   PublishMonth,
			   AddUserId,
			   AddDate,
			   TotalCount,
			   [Status],
			  SImage,
			  LImage
			   )
		 VALUES
			   (@Title,
			   @BandId,
			   @PublishDate,
			   @PublishYear,
			   @PublishMonth,
			   @AddUserId,
			   GETDATE(),
			   @TotalCount,
			   @Status,
			  @SImage,
			  @LImage
			 )
		SET @AlbumId = 	 @@IDENTITY 
   END
   ELSE
   BEGIN
    UPDATE albums
    SET  Title = @Title,BandId=@BandId,PublishDate= @PublishDate,
    PublishYear=@PublishYear,PublishMonth=@PublishMonth,AddUserId=@AddUserId,
    AddDate=GETDATE(),[Status]=@Status,
   SImage=@SImage,  LImage=@LImage
    WHERE AlbumId =  @AlbumId
   END
	
	RETURN @AlbumId
END
