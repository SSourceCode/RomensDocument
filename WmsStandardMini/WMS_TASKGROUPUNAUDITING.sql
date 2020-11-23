GO
/****** Object:  StoredProcedure [dbo].[WMS_VESSELDELETE]    Script Date: 2020/11/23 16:03:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WMS_TASKGROUPUNAUDITING]
(
	@BillGuid varchar(50),			--单据内码
	@BillTypeGuid varchar(50),		--单据类型
	@OperatorGuid varchar(50),		--操作人员内码
	@ReturnMsg varchar(200) OutPut,	--返回提示信息，成功执行，返回空值；否则返回提示信息
	@ReturnValue int OutPut			--返回值，成功执行，返回0；否则返回非零值
  )
  AS
  Declare @temp int;
  Set @temp = 0;
BEGIN
    SELECT @temp = COUNT(1) FROM WMS_TASKGROUP WHERE ISNULL(ISAUDITING,0) = 0 AND GUID  = @BILLGUID
    IF @temp <> 0
	Begin
      Set @ReturnMsg = '当前波次未审核,反审失败!';
      Set @ReturnValue = -1;
      RETURN;
    End;
    SELECT @temp = COUNT(1) FROM WMS_TASKGROUPDETAIL A INNER JOIN FAHUOHEAD B ON A.FAHUOHEADGUID = B.Guid INNER JOIN FAHUO C ON B.BillNo = C.LSH WHERE A.TASKGROUPGUID = @BillGuid AND ISNULL(C.BoxBZ,'')<>''
	IF @temp <> 0
    Begin
        Set @ReturnMsg = '当前波次已发起复核,反审失败!';
        Set @ReturnValue = -1;
        RETURN;
    End
    Begin Tran
	UPDATE WMS_TASKGROUP SET ISAUDITING = 0 ,AUDITINGGUID = '',AUDITINGDATE = null  WHERE GUID  = @BillGuid AND ISNULL(ISAUDITING,0) = 1
    IF @@Error<>0
	Begin
		Select @ReturnMsg='反审失败!'
		GoTo SQLErr1
    End
	Commit Tran
	Set @ReturnMsg='反审成功!'
	Set @ReturnValue=0
	Return
    SQLErr1:
	RollBack Transaction
	Set @ReturnValue=-1
	Return
END;