CREATE PROCEDURE     [dbo].[SellOutTMFHAfterMultCheck]
(

  @OperatorGuid varchar(50), --人员内码,
  @BRANCHGUID varchar(50), --组织机构内码,
  @ReturnMsg varchar(50) output, --返回消息
  @ReturnValue SmallInt  output --返回值
)

AS
   Declare @dh varchar(50);
   Declare @lsh varchar(50);
   Declare @boxNo varchar(50);
   DECLARE  @pickNum int;
BEGIN
--select @num = count(1) from tt_selectguid where type='TMFH_AfterMultSave' and operatorguid=@OperatorGuid;
--select guid as dh from tt_selectguid where type='TMFH_AfterMultSave' and operatorguid=@OperatorGuid GROUP BY Guid;


DECLARE mycursor CURSOR
FOR
    select guid from tt_selectguid where type='TMFH_AfterMultSave' and operatorguid=@OperatorGuid GROUP BY Guid;
OPEN mycursor  --打开游标
FETCH NEXT FROM mycursor INTO @dh
WHILE (@@fetch_status = 0)   --如果上一次操作成功则继续循环
    BEGIN
		SELECT @lsh = lsh,@boxNo = WMSRECORDSTATUS from FAHUO where DH = @dh
        SELECT @pickNum = COUNT(1) FROM FAHUO WHERE WMSRECORDSTATUS = @boxNo AND LSH = @lsh  AND ISNULL(BoxBZ,0)= 0
        IF(@pickNum<=0)
        Begin
            update  WMS_VESSEL set ISSTATUS = 1 where CODE = @boxNo;
        End
        --用游标去取下一条记录(继续取下一行数据)
        FETCH NEXT FROM mycursor INTO @dh
    END
CLOSE mycursor --关闭游标
DEALLOCATE mycursor --撤销游标(释放资源 )
      set @ReturnMsg ='' ;
      select @ReturnValue = 0 ;
      return;
END