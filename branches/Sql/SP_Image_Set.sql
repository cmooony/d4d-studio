USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Image_Set]    Script Date: 10/26/2009 18:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- Description:	Add Or Set image
-- =============================================
ALTER PROCEDURE [dbo].[Image_Set]
  @ImageId AS INT,
   @AlbumId AS INT ,
   @ImageName AS NVARCHAR(1000),    
   @ImageFile AS NVARCHAR(1000),
   @SImageFile AS NVARCHAR(1000),   
   @AddUserId AS INT,   
   @Status AS INT,
   @PublishDate AS DATETIME   
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @BandId AS INT
   SELECT @BandId = BandId FROM albums
		   WHERE AlbumId = @AlbumId
  
    IF (@ImageId<=0)
   BEGIN 
	INSERT INTO images
			   (AlbumId,
			   ImageName,
			   ImageFile,
			   AddUserId,
			   AddDate,			 	
			   [Status],
			   SImageFile,
			   PublishDate,
			   BandId
			   )
		 VALUES
			   (@AlbumId,
			   @ImageName,
			   @ImageFile,
			   @AddUserId,
			   GETDATE(),			
			   @Status,
			   @SImageFile,
			   @PublishDate,
			   @BandId
			 )
		SET @ImageId = 	 @@IDENTITY 
		
		DECLARE @NEWCOUNT AS INT
		 SELECT @NEWCOUNT = COUNT(ImageID) FROM images
		   WHERE AlbumId = @AlbumId
		   
		   UPDATE albums
		   SET TotalCount = @NEWCOUNT
			WHERE AlbumId = @AlbumId
   END
   ELSE
   BEGIN
    UPDATE images
    SET  AlbumId = @AlbumId,ImageName=@ImageName,ImageFile= @ImageFile,
   AddUserId=@AddUserId,  AddDate=GETDATE(),[Status]=@Status,
   SImageFile=@SImageFile,PublishDate=@PublishDate
    WHERE ImageId =  @ImageId
   END
	
	RETURN @ImageId
END
