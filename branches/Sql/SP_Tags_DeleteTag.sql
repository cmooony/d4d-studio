USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Tags_DeleteTag]    Script Date: 10/26/2009 18:30:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-10
-- Description:	Delete  One Tag
-- =============================================
ALTER PROCEDURE [dbo].[Tags_DeleteTag]
   @TagID AS INT 
AS
BEGIN	

   DELETE FROM  [tags]
   WHERE TagId = @TagID	
	
END
