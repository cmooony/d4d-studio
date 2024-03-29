-- =============================================
-- Create date: 2009-10-11
-- =============================================
ALTER PROCEDURE [dbo].[News_Get]
   @NewsId AS INT ,
   @Hits as INT = 0
AS
BEGIN	
	if @Hits > 0 
		UPDATE newsinfo
		SET  [Hits] = [Hits]+1
		WHERE NewsId =  @NewsId
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
    FROM newsinfo With(nolock)
    WHERE NewsId =  @NewsId
 
END
