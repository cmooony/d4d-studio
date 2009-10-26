USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[TagRelation_GetByTagId]    Script Date: 10/26/2009 18:29:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-10
-- Description:	Get One TagsRealtionByTagId    
-- =============================================
ALTER PROCEDURE [dbo].[TagRelation_GetByTagId]    
   @TagId AS INT
AS
BEGIN	
	
    SELECT Id,TagId,ObjectId,ObjectType,AddUserID,[AddDate] 
    FROM tag_relation With(nolock)
     WHERE TagId = @TagId 

	
 
END
