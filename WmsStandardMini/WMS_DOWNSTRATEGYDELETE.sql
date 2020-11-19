
GO

/****** Object:  StoredProcedure [dbo].[WMS_DOWNSTRATEGYDELETE]    Script Date: 2020/11/18 10:28:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
procedure       [dbo].[WMS_DOWNSTRATEGYDELETE]
--库存盘点 删除存储过程
--2014/3/13
--许勇智转F4门店版
(
  @BillGuid nvarchar(100) ,
  @BillTypeGuid nvarchar(100) ,
  @OperatorGuid nvarchar(100) ,
  @ReturnMsg nvarchar(100) OUT,
  @RETURNVALUE int OUT 
)
AS
   DECLARE @count INT;
BEGIN
   SELECT @count = ISNULL(ISAUDITING,0) FROM WMS_DOWNSTRATEGY WHERE  GUID = @BillGuid;
   IF @count <> 0 
   BEGIN
      Set @ReturnMsg = '该策略已审核,不能删除!' ;
      Set @ReturnValue = -1 ;
      Return;
   END;
 
  Begin Tran
   DELETE WMS_DOWNSTRATEGY  WHERE GUID = @BillGuid and IsNull(ISAUDITING,0)=0;
   DELETE WMS_DOWNSTRATEGYDETAIL  WHERE mainguid = @BillGuid ;
   ----------删除排序
   Delete from WMS_GOODSPLACESORT where BILLTEMPLATEGUID='10051508008' and mainguid=@Billguid;
   If @@Error<>0 
	Begin
	 Set @ReturnMsg = '删除失败'
	 Goto SQLErr1
	End
  Commit Tran
	SET @ReturnMsg=''
	SET @ReturnValue=0
	Return;
	SQLErr1:
	RollBack Transaction
	Set @ReturnValue=-1
	Return;

END;
GO


