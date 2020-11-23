GO
/****** Object:  StoredProcedure [dbo].[WMS_TASKGROUPAUDITING]    Script Date: 2020/11/23 16:38:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WMS_TASKGROUPAUDITING]
(
	@BillGuid varchar(50),			--单据内码
	@BillTypeGuid varchar(50),		--单据类型
	@OperatorGuid varchar(50),		--操作人员内码
	@AuditingDate Datetime,			--审核日期
	@ReturnMsg varchar(200) OutPut,	--返回提示信息，成功执行，返回空值；否则返回提示信息
	@ReturnValue int OutPut			--返回值，成功执行，返回0；否则返回非零值
  )
  AS
  Declare @temp int;
  Set @temp = 0;
BEGIN
    SELECT @temp = COUNT(1) FROM WMS_TASKGROUP WHERE ISNULL(ISAUDITING,0) = 1 AND GUID  = @BILLGUID
    IF @temp <> 0
	Begin
      Set @ReturnMsg = '当前波次已审核,不能审核!';
      Set @ReturnValue = -1;
      RETURN;
    End;

    Begin Tran
	UPDATE WMS_TASKGROUP SET ISAUDITING = 1 ,AUDITINGGUID = @OperatorGuid,AUDITINGDATE = getdate()  WHERE GUID  = @BillGuid AND ISNULL(ISAUDITING,0)=0
    IF @@Error<>0
	Begin
		Select @ReturnMsg='审核失败!'
		GoTo SQLErr1
    End
	Commit Tran
	Set @ReturnMsg='审核成功!'
	Set @ReturnValue=0
	Return
    SQLErr1:
	RollBack Transaction
	Set @ReturnValue=-1
	Return
END;