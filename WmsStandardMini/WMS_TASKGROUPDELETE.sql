GO
/****** Object:  StoredProcedure [dbo].[WMS_VESSELDELETE]    Script Date: 2020/11/23 16:03:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WMS_TASKGROUPDELETE]
(
	@BillGuid     varchar(100),                 -- 待删除的表单单据GUID
	@BillTypeGuid varchar(100),                 -- 待删除的表单GUID
	@OperatorGuid varchar(100),                 -- 当前操作人员GUID
 	@ReturnMsg    nvarchar(500) output,          -- 返回提示或错误信息
 	@ReturnValue    nvarchar(500) output          -- 返回提示或错误信息
  )
  AS
  Declare @temp int;
  Set @temp = 0;
BEGIN
    SELECT @temp = COUNT(1) FROM WMS_TASKGROUP WHERE ISNULL(ISAUDITING,0) = 1 AND GUID = @BILLGUID
    IF @temp <> 0
	Begin
      Set @ReturnMsg = '当前波次已审核,不能删除!';
      Set @ReturnValue = -1;
      RETURN;
    End;
    SELECT  @temp = COUNT(1) FROM WMS_TASKGROUPDETAIL A INNER JOIN FAHUOHEAD B ON A.FAHUOHEADGUID = B.Guid INNER JOIN FAHUO C ON C.LSH = B.BillNo WHERE ISNULL(C.BoxBZ,'') <>'' AND A.TASKGROUPGUID = @BillGuid;
    IF @temp <> 0
	Begin
      Set @ReturnMsg = '当前波次已发生复核,不能删除!';
      Set @ReturnValue = -1;
      RETURN;
    End;
    Begin Tran
	DELETE WMS_TASKGROUPDETAIL WHERE TASKGROUPGUID = @BillGuid ;
    IF @@Error<>0
	Begin
		Select @ReturnMsg='删除波次明细失败!'
		GoTo SQLErr1
    End
    DELETE WMS_TASKGROUP WHERE GUID = @BillGuid;
    IF @@Error<>0
	Begin
		Select @ReturnMsg='删除波次失败!'
		GoTo SQLErr1
    End
	Commit Tran
	Set @ReturnMsg='删除成功!'
	Set @ReturnValue=0
	Return
    SQLErr1:
	RollBack Transaction
	Set @ReturnValue=-1
	Return
END;