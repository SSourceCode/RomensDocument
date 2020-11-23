GO
/****** Object:  StoredProcedure [dbo].[WMS_VESSELDELETE]    Script Date: 2020/11/23 16:03:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WMS_TASKGROUPUNAUDITING]
(
	@BillGuid varchar(50),			--��������
	@BillTypeGuid varchar(50),		--��������
	@OperatorGuid varchar(50),		--������Ա����
	@ReturnMsg varchar(200) OutPut,	--������ʾ��Ϣ���ɹ�ִ�У����ؿ�ֵ�����򷵻���ʾ��Ϣ
	@ReturnValue int OutPut			--����ֵ���ɹ�ִ�У�����0�����򷵻ط���ֵ
  )
  AS
  Declare @temp int;
  Set @temp = 0;
BEGIN
    SELECT @temp = COUNT(1) FROM WMS_TASKGROUP WHERE ISNULL(ISAUDITING,0) = 0 AND GUID  = @BILLGUID
    IF @temp <> 0
	Begin
      Set @ReturnMsg = '��ǰ����δ���,����ʧ��!';
      Set @ReturnValue = -1;
      RETURN;
    End;
    SELECT @temp = COUNT(1) FROM WMS_TASKGROUPDETAIL A INNER JOIN FAHUOHEAD B ON A.FAHUOHEADGUID = B.Guid INNER JOIN FAHUO C ON B.BillNo = C.LSH WHERE A.TASKGROUPGUID = @BillGuid AND ISNULL(C.BoxBZ,'')<>''
	IF @temp <> 0
    Begin
        Set @ReturnMsg = '��ǰ�����ѷ��𸴺�,����ʧ��!';
        Set @ReturnValue = -1;
        RETURN;
    End
    Begin Tran
	UPDATE WMS_TASKGROUP SET ISAUDITING = 0 ,AUDITINGGUID = '',AUDITINGDATE = null  WHERE GUID  = @BillGuid AND ISNULL(ISAUDITING,0) = 1
    IF @@Error<>0
	Begin
		Select @ReturnMsg='����ʧ��!'
		GoTo SQLErr1
    End
	Commit Tran
	Set @ReturnMsg='����ɹ�!'
	Set @ReturnValue=0
	Return
    SQLErr1:
	RollBack Transaction
	Set @ReturnValue=-1
	Return
END;