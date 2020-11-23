GO
/****** Object:  StoredProcedure [dbo].[WMS_TASKGROUPAUDITING]    Script Date: 2020/11/23 16:38:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WMS_TASKGROUPAUDITING]
(
	@BillGuid varchar(50),			--��������
	@BillTypeGuid varchar(50),		--��������
	@OperatorGuid varchar(50),		--������Ա����
	@AuditingDate Datetime,			--�������
	@ReturnMsg varchar(200) OutPut,	--������ʾ��Ϣ���ɹ�ִ�У����ؿ�ֵ�����򷵻���ʾ��Ϣ
	@ReturnValue int OutPut			--����ֵ���ɹ�ִ�У�����0�����򷵻ط���ֵ
  )
  AS
  Declare @temp int;
  Set @temp = 0;
BEGIN
    SELECT @temp = COUNT(1) FROM WMS_TASKGROUP WHERE ISNULL(ISAUDITING,0) = 1 AND GUID  = @BILLGUID
    IF @temp <> 0
	Begin
      Set @ReturnMsg = '��ǰ���������,�������!';
      Set @ReturnValue = -1;
      RETURN;
    End;

    Begin Tran
	UPDATE WMS_TASKGROUP SET ISAUDITING = 1 ,AUDITINGGUID = @OperatorGuid,AUDITINGDATE = getdate()  WHERE GUID  = @BillGuid AND ISNULL(ISAUDITING,0)=0
    IF @@Error<>0
	Begin
		Select @ReturnMsg='���ʧ��!'
		GoTo SQLErr1
    End
	Commit Tran
	Set @ReturnMsg='��˳ɹ�!'
	Set @ReturnValue=0
	Return
    SQLErr1:
	RollBack Transaction
	Set @ReturnValue=-1
	Return
END;