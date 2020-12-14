CREATE PROC [dbo].[LocationForbidden]
(	@BillGuid nvarchar(100),             	-- 表单单据GUID
    @BillTypeGuid nvarchar(100),		--单据类型
	@OperatorGuid nvarchar(100),     	--当前操作人员GUID
	@ReturnMsg nvarchar(500) output,   	--返回提示或错误信息
	@ReturnValue smallint output          --返回提示或错误信息
)
As
begin
    declare @count int;
	--判断是否审核
	IF EXISTS(Select * from GoodsPlace  where isnull(IsForbidden,'0')='1' and guid='101010101')
	Begin
		set @ReturnMsg='本单据已禁用，无法重复禁用!'
		set @ReturnValue=2
		return 2
	End
	BEGIN
	--检测是否已启用，库位GUID 与 CODE 必须保持一致
	SELECT @Count=count(*) FROM GoodsPlaceBalance WHERE GOODSPLACENO  = @BillGuid And isnull(Quantity,0)>0
	IF @Count>0
	begin
		set @ReturnMsg = '货位已启用,不允许删除！'
		set @ReturnValue = - 1
		RETURN -1
	end
	END
    select @count  = count(1) from phk a inner join goodsplace b on a.KH = b.Code and a.StockID = b.WarehouseGuid where B.GUID = @BillGuid AND A.SL > 0
    if(@count > 0)
     Begin
		set @ReturnMsg='当前库位已在PHK中使用无法禁用!'
		set @ReturnValue=2
		return 2
	End
	Begin Tran
	begin
	update GoodsPlace set IsForbidden=1,FORBIDDENDATE=convert(varchar(10),getdate(),111),FORBIDDENGUID=@OPERATORGUID where guid=@billguid
	if @@ERROR<>0
	Begin
		set @ReturnMsg='启用执行失败!'
		set @ReturnValue=2
		rollback
		return 2
	End
	end
	commit
	set @ReturnMsg=''
	set @ReturnValue=0
	return
end
go


