
GO

/****** Object:  StoredProcedure [dbo].[WMS_DOWNSTRATEGYAUDIT]    Script Date: 2020/11/18 10:31:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[WMS_DOWNSTRATEGYAUDIT]
(
	@BillGuid varchar(50),
	@BillTypeGuid varchar(50),
	@AuditingDate datetime,
	@OperatorGuid varchar(50),
	@ReturnMsg nvarchar(50) output,
	@ReturnValue int output
 ) as

 Begin
  declare @info    varchar(500);
 declare @iswhole bit; --1������0��ɢ
 declare @num     int;
 declare @count   int;
 declare @hw varchar(100);
 declare @xh varchar(100);
  --������Ч���
  select @info = case when isnull(a.isauditing, 0) = 1 then '��ǰ���������,�������ظ���ˣ�' end from wms_downstrategy a where a.guid = @billguid;
  if IsNull(@info,'')<> ''
  Begin
    set @ReturnMsg   = @info;
    set @ReturnValue = -1;
    return;
  End;
    --����Ƿ�����ϸ����
  Set @count = 0;
  Select @count =COUNT(1) FROM wms_downstrategydetail  WHERE MAINGUID = @billguid;
  If @count = 0 
  Begin
	set @ReturnMsg = 'û����ϸ���ݣ����������';
	set @ReturnValue = -1;
	return;
  End

  Select TOP 1 @hw = t.goodsplaceguid,@xh = t.detailno from WMS_DOWNSTRATEGYDETAIL t where t.mainguid = @billguid and t.goodsplaceguid in (select a.goodsplaceguid from WMS_DOWNSTRATEGYDETAIL a where a.mainguid <> @billguid);
  IF @@Error<>0
  Begin
	Set @hw = '';
  End	
  IF IsNull(@hw,'')<>''
  BEGIN
	 select top 1 @ReturnMsg = '��ϸ�����:'+ @xh + '��λ:'+t2.code+',�ڳ������ID:'+t1.code+'���Ѿ������,���ʧ�ܣ�' from WMS_DOWNSTRATEGYDETAIL t inner join WMS_DOWNSTRATEGY t1 on t.mainguid = t1.guid left join GOODSPLACE t2 on t.goodsplaceguid = t2.guid  where t.goodsplaceguid = @hw and t.mainguid <> @billguid;
     Set @ReturnValue = -1;
     Return;
  END;

  Begin Tran
    --�������״̬ ����� ���ʱ��
    UPDATE wms_downstrategy SET IsAuditing = 1,AuditingDate = convert(varchar(10),getdate(),23),AuditingGuid = @OperatorGuid WHERE Guid = @BillGuid;
	If @@Error<>0 
	Begin
	 Set @ReturnMsg = '��˷����쳣'
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


