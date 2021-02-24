CREATE Proc [dbo].[WMS_PDARights]
(
@OperatorCode varchar(50),
@ReturnMsg varchar(2000) output ,
@RightModel varchar(2000) output ,
@ReturnValue int output
)

AS
 DECLARE  @COUNT INT;
 DECLARE  @OperatorGuid VARCHAR(100);
 DECLARE  @RightModelGuid VARCHAR(50);
 DECLARE  @RightValue VARCHAR(1000);
 DECLARE  @rightinfo VARCHAR(1000);
 DECLARE  @RightModeltemp VARCHAR(500);
 DECLARE  @RightModelname VARCHAR(2000);
Begin
	Select @OperatorGuid = guid From operators where code = UPPER(@OperatorCode);
	If @OperatorGuid IS NULL
		Begin
			Set @ReturnMsg = '获取操作人员编号失败！';
			Set @ReturnValue = -1;
			Return;
		End;
	Set @RightModelGuid =  '6d66d794-6881-49a2-9347-4a5064502369';
	Select @rightinfo = rightinfo2 From rightmodel where guid = @RightModelGuid;
	Set @COUNT = 0;
	Select  @COUNT =COUNT(1) From rights WHERE rightmodelguid=@RightModelGuid AND OperatorGuid=@OperatorGuid;
    If @COUNT = 1
	Begin
	  Select @RightValue = RightValue2 From rights where rightmodelguid=@RightModelGuid and OperatorGuid=@OperatorGuid;
      Select @RightModel = STUFF( (Select ','+ modelname From (Select ch as modelname,row_number() over(order by (Select 0)) as xuhao From fsplit(@rightinfo,','))a1
      inner join (Select ch as rightname,row_number() over(order by (Select 0)) as xuhao From  fsplit(@RightValue,','))a2 on a1.xuhao = a2.xuhao where a2.rightname = 1 FOR XML PATH('')),1,1,'')
	  If @@Error<>0
		Begin
			Set @ReturnMsg='获取权限列表失败！'
			Set @ReturnValue = -1;
			Return;
		End
	  If @RightModel IS NULL
       Begin
			Set @RightModel = '';
			Set @ReturnMsg = '';
			Set @ReturnValue = 0;
			Return;
		End
		SET @RETURNMSG = ' ';
        SET @ReturnValue = 0;
        return;
	End
	Set @COUNT = 0;
	Select  @COUNT =COUNT(1) From operatorGroupmember WHERE Operatorguid=@OperatorGuid;

	If @COUNT > 0
	Begin
	declare my_cursor cursor for
	select GroupGuid from operatorGroupmember where Operatorguid=@OperatorGuid
	open my_cursor
	declare   @GroupGuid varchar(50)
	fetch next from my_cursor into @GroupGuid
	while @@FETCH_STATUS=0
	begin
	set @COUNT = 0;
    select @COUNT =COUNT(1) from rightgroup where OperatorGroupGuid=@GroupGuid and rightmodelguid=@RightModelGuid;
	If @COUNT = 1
	Begin
	  select @RightValue = rightvalue2  from rightgroup where OperatorGroupGuid=@GroupGuid and rightmodelguid=@RightModelGuid;
	  select @RightModeltemp = (select ','+ modelname from (select ch as modelname,row_number() over(order by (Select 0)) as xuhao from fsplit(@rightinfo,','))a1
                inner join (select ch as rightname,row_number() over(order by (Select 0)) as xuhao from fsplit(@RightValue,','))a2 on a1.xuhao = a2.xuhao where a2.rightname = 1);
	   If @@Error<>0
		Begin
			Set @ReturnMsg='获取权限列表失败！'
			Set @ReturnValue = -1;
			Return;
		End
	  If @RightModeltemp IS NULL
		  Begin
			Set @RightModelname = @RightModeltemp;
		  End
	  Else
		  Begin
			Set @RightModelname = @RightModelname + ',' + @RightModeltemp;
		  End
	End
	fetch next from my_cursor into @GroupGuid --获取下一条数据并赋值给变量
	end--关闭释放游标
	close my_cursor
	deallocate my_cursor
	End
    Set @ReturnMsg = '当前人员没有任何权限' ;
    Set @ReturnValue = -1 ;
    Return;
Return;
End
go

