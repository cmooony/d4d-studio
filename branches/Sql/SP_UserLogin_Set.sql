USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[UserLogin_Set]    Script Date: 10/26/2009 18:31:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- =============================================
ALTER PROCEDURE [dbo].[UserLogin_Set]
   @UserId AS INT ,
   @UserName AS NVARCHAR(50),   
   @Password AS NVARCHAR(100),   
   @Email AS NVARCHAR(100)
AS
BEGIN

	SET NOCOUNT ON;
  
  
	UPDATE	userlogin
	SET		UserName = @UserName,[Password]=@Password,Email = @Email
	WHERE  UserId = @UserId 
	
	
	IF @@ROWCOUNT = 0
	BEGIN
		  INSERT INTO userlogin   
		  (UserId,
			   UserName,
			   [Password],			
			   Email			  
			   )
		  VALUES (@UserId, 
		  @UserName, 
		  @Password, 
		  @Email
		  )
	END  
END