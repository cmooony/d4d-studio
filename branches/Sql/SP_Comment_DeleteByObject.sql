USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Comment_DeleteByObject]    Script Date: 10/26/2009 18:18:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-10
-- =============================================
ALTER PROCEDURE [dbo].[Comment_DeleteByObject]   
   @ObjectId AS INT,   
   @ObjectType AS INT
AS
BEGIN	

   DELETE FROM  comments
   WHERE ObjectId = @ObjectId
	AND ObjectType = @ObjectType
	
END
