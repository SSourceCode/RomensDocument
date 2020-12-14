CREATE PROC [dbo].[LocationUnForbidden]
(	@BillGuid nvarchar(100),             	-- 表单单据GUID
    @BillTypeGuid nvarchar(100),		--单据类型
	@OperatorGuid nvarchar(100),     	--当前操作人员GUID
	@ReturnMsg nvarchar(500) output,   	--返回提示或错误信息
	@ReturnValue smallint output          --返回提示或错误信息
)
As
begin

	--判断是否审核
	IF EXISTS(Select * from GoodsPlace  where isnull(IsForbidden,0)=0 and guid=@BillGuid)
	Begin
		set @ReturnMsg='本单据已启用，不能重复启用!'
		set @ReturnValue=2
		return 2
	End
Begin Tran
	begin
	update GoodsPlace set IsForbidden=0,FORBIDDENDATE=NULL,FORBIDDENGUID='' where guid=@billguid
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


