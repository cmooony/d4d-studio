USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Tags_AddTag]    Script Date: 10/26/2009 18:29:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-10
-- Description:	Add Or Update  One Tags
-- =============================================
ALTER PROCEDURE [dbo].[Tags_AddTag] 
 @TagID AS INT ,
   @Name AS NVARCHAR(100),   
   @AddUserID AS INT   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  
    IF (@TagID<=0)
   BEGIN 
	INSERT INTO [tags]
			   ([Name],
			   [Hits],
			   [AddUserId],
			   [AddDate]
			   )
		 VALUES
			   (@Name
			   ,0
			   ,@AddUserID			   
			   ,GETDATE()
			 )
		SET @TagID = 	 @@IDENTITY 
   END
   ELSE
   BEGIN
    UPDATE [tags]
    SET  [Name] = @Name,[AddUserId]=@AddUserID,[AddDate]= GETDATE()
    WHERE TagId =  @TagID
   END
	
	RETURN @TagID
END
