create proc WMS_VESSELTYPEDELETE
(
	@BillGuid     varchar(100),                 -- ��ɾ���ı�����GUID
	@BillTypeGuid varchar(100),                 -- ��ɾ���ı�GUID
	@OperatorGuid varchar(100),                 -- ��ǰ������ԱGUID
 	@ReturnMsg    nvarchar(500) output,          -- ������ʾ�������Ϣ
 	@ReturnValue    nvarchar(500) output          -- ������ʾ�������Ϣ
) AS
Declare @temp int;
BEGIN
  BEGIN
    SELECT @temp = COUNT(1) FROM WMS_VESSEL WHERE VESSELTYPE = @BillGuid;
	IF @temp <> 0
	Begin
      Set @ReturnMsg = '��������������ʹ��,����ɾ��!';
      Set @ReturnValue = -1;
      RETURN;
    End;
  END;

  BEGIN
    DELETE WMS_VESSELTYPE WHERE GUID = @BillGuid;
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
end;