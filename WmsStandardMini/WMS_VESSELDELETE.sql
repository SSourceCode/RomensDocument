GO

/****** Object:  StoredProcedure [dbo].[WMS_VESSELDELETE]    Script Date: 2020/11/18 10:17:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[WMS_VESSELDELETE] 
(
	@BillGuid     varchar(100),                 -- ��ɾ���ı�����GUID
	@BillTypeGuid varchar(100),                 -- ��ɾ���ı�GUID
	@OperatorGuid varchar(100),                 -- ��ǰ������ԱGUID
 	@ReturnMsg    nvarchar(500) output,          -- ������ʾ�������Ϣ
 	@ReturnValue    nvarchar(500) output          -- ������ʾ�������Ϣ
  ) 
  AS
  Declare @temp int;
  Set @temp = 0;
BEGIN
    SELECT @temp = COUNT(1)  FROM WMS_VESSEL  WHERE GUID = @BillGuid  AND ISNULL(ISSTATUS, 1) <> 1;
    IF @temp <> 0 
	Begin
      Set @ReturnMsg = '���������ǿ���״̬,����ɾ��!';
      Set @ReturnValue = -1;
      RETURN;
    End;
    Begin Tran
	DELETE WMS_VESSEL WHERE GUID = @BillGuid;
    IF @@Error<>0 
	Begin
		Select @ReturnMsg='ɾ��ʧ��!'
		GoTo SQLErr1
    End
	Commit Tran
	Set @ReturnMsg='ɾ���ɹ�!'
	Set @ReturnValue=0
	Return
    SQLErr1:
	RollBack Transaction
	Set @ReturnValue=-1
	Return
END;
GO


