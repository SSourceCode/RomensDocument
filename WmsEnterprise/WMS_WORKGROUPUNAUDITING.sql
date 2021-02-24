GO
/****** Object:  StoredProcedure [dbo].[WMS_WORKGROUPUNAUDITING]    Script Date: 2020/11/18 10:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC          [dbo].[WMS_WORKGROUPUNAUDITING]
(
  @BillGuid VARCHAR(50) ,
  @BillTypeGuid VARCHAR(50),
  @OperatorGuid VARCHAR(50) ,
  @ReturnMsg varchar(200) OutPut,
  @ReturnValue int OutPut	-- 返回提示或错误信息 
)
AS
declare @count int;
BEGIN
   set @count = 0;
   select @count = count(*)  from wms_Workgroup WHERE  GUID = @BillGuid and IsNull(IsAuditing,0)=0;
   if @count>0
   begin
     set @ReturnMsg = '单据还未审核，无需反审！' ;
     set @ReturnValue = -1 ;
     RETURN;
   end;
   Begin Tran
   update wms_Workgroup  set ISAUDITING=0,AUDITINGGUID='',AUDITINGDATE=NULL
   WHERE GUID = @BillGuid and IsNull(IsAuditing,0)=1;
    If @@Error<>0 
   Begin
	Select @ReturnMsg = '反审失败！'
	Goto SQLErr1
   End;
   Commit Tran
	SET @ReturnMsg=''
	SET @ReturnValue=0
	Return;
	SQLErr1:
	RollBack Transaction
	Set @ReturnValue=-1
	Return;
	END;