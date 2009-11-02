USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Tags_AddTagHits]    Script Date: 11/02/2009 15:31:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-10
-- Description:	Add One TagsHits
-- =============================================
ALTER PROCEDURE [dbo].[Tags_AddTagHits]    
   @TagIDStr AS Varchar(100)
AS
BEGIN	
	    
  
  declare   @sql   varchar(500)     
 
    
  set   @sql='UPDATE   [tags]   SET  [Hits] = [Hits]+1  where    TagId in ('   +   @TagIDStr   + ')'
  
  exec   (@sql)   
	

 
END
