USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[TagRelation_Delete]    Script Date: 10/26/2009 18:28:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-10
-- Description:	Delete  One TagRelation
-- =============================================
ALTER PROCEDURE [dbo].[TagRelation_Delete]
    @TagId AS INT,
   @ObjectId AS INT,   
   @ObjectType AS INT
AS
BEGIN	

   DELETE FROM  tag_relation
   WHERE TagId = @TagId 
	AND	ObjectId = @ObjectId
	AND ObjectType = @ObjectType
	
END
