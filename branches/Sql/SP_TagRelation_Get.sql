USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[TagRelation_Get]    Script Date: 10/26/2009 18:28:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-10
-- Description:	Get One TagsRealtion
-- =============================================
ALTER PROCEDURE [dbo].[TagRelation_Get]    
   @TagId AS INT,
   @ObjectId AS INT,   
   @ObjectType AS INT
AS
BEGIN	
	
    SELECT Id,TagId,ObjectId,ObjectType,AddUserID,[AddDate] 
    FROM tag_relation With(nolock)
     WHERE TagId = @TagId 
	AND	ObjectId = @ObjectId
	AND ObjectType = @ObjectType
	
 
END
