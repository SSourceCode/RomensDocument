GO
/****** Object:  StoredProcedure [dbo].[WMS_VESSELDELETE]    Script Date: 2020/11/23 16:03:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WMS_TASKGROUPDELETE]
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
    SELECT @temp = COUNT(1) FROM WMS_TASKGROUP WHERE ISNULL(ISAUDITING,0) = 1 AND GUID = @BILLGUID
    IF @temp <> 0
	Begin
      Set @ReturnMsg = '��ǰ���������,����ɾ��!';
      Set @ReturnValue = -1;
      RETURN;
    End;
    SELECT  @temp = COUNT(1) FROM WMS_TASKGROUPDETAIL A INNER JOIN FAHUOHEAD B ON A.FAHUOHEADGUID = B.Guid INNER JOIN FAHUO C ON C.LSH = B.BillNo WHERE ISNULL(C.BoxBZ,'') <>'' AND A.TASKGROUPGUID = @BillGuid;
    IF @temp <> 0
	Begin
      Set @ReturnMsg = '��ǰ�����ѷ�������,����ɾ��!';
      Set @ReturnValue = -1;
      RETURN;
    End;
    Begin Tran
	DELETE WMS_TASKGROUPDETAIL WHERE TASKGROUPGUID = @BillGuid ;
    IF @@Error<>0
	Begin
		Select @ReturnMsg='ɾ��������ϸʧ��!'
		GoTo SQLErr1
    End
    DELETE WMS_TASKGROUP WHERE GUID = @BillGuid;
    IF @@Error<>0
	Begin
		Select @ReturnMsg='ɾ������ʧ��!'
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