CREATE OR REPLACE PROCEDURE WMS_TASKGROUPDELETE
(
	v_BillGuid IN VARCHAR2 DEFAULT NULL,
    v_BillTypeGuid IN VARCHAR2 DEFAULT NULL,
    v_OperatorGuid IN VARCHAR2 DEFAULT NULL ,
    v_ReturnMsg OUT NVARCHAR2,
    v_ReturnValue OUT NUMBER
  )
  AS
    v_temp number(10) := 0;
BEGIN
    SELECT COUNT(1) into v_temp FROM WMS_TASKGROUP WHERE nvl(ISAUDITING,0) = 1 AND GUID = v_BILLGUID;
    IF v_temp <> 0 then
        Begin
          V_ReturnMsg := '当前波次已审核,不能删除!';
          V_ReturnValue := -1;
          RETURN;
        End;
	End IF;
    SELECT  COUNT(1) INTO V_temp FROM WMS_TASKGROUPDETAIL A INNER JOIN FAHUOHEAD B ON A.FAHUOHEADGUID = B.Guid INNER JOIN FAHUO C ON C.LSH = B.BillNo WHERE NVL(C.BoxBZ,' ') <>' ' AND A.TASKGROUPGUID = V_BillGuid;
    IF V_temp <> 0 THEN
	Begin
      V_ReturnMsg := '当前波次已发生复核,不能删除!';
      V_ReturnValue := -1;
      RETURN;
    End;
	End IF;
    Begin
        DELETE WMS_TASKGROUPDETAIL WHERE TASKGROUPGUID = V_BillGuid ;
        EXCEPTION WHEN OTHERS THEN
        V_RETURNMSG := '删除波次明细失败！';
        V_RETURNVALUE := -1;
        ROLLBACK;
        Return;
    End;
    Begin
        DELETE WMS_TASKGROUP WHERE GUID = V_BillGuid;
        EXCEPTION WHEN OTHERS THEN
        V_RETURNMSG := '删除波次失败！';
        V_RETURNVALUE := -1;
        ROLLBACK;
        Return;
    End;
	Commit;
	v_ReturnMsg :=' ';
	v_ReturnValue :=0 ;
	Return;
    End;

