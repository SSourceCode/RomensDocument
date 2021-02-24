CREATE OR REPLACE PROCEDURE  WMS_TASKGROUPUNAUDITING
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
    SELECT COUNT(1) into v_temp FROM WMS_TASKGROUP WHERE nvl(ISAUDITING,0) = 0 AND GUID  = v_BILLGUID;
    IF v_temp <> 0 Then
      Begin
          V_ReturnMsg := '当前波次未审核,反审失败!';
          V_ReturnValue := -1;
          RETURN;
      End;
    END IF;
    v_temp := 0;
    SELECT COUNT(1) into v_temp FROM WMS_TASKGROUPDETAIL A INNER JOIN FAHUOHEAD B ON A.FAHUOHEADGUID = B.Guid INNER JOIN FAHUO C ON B.BillNo = C.LSH WHERE A.TASKGROUPGUID = v_BillGuid AND nvl(C.BoxBZ,' ')<>' ';
    IF v_temp <> 0 Then
      Begin
          V_ReturnMsg := '当前波次已发起复核,反审失败!';
          V_ReturnValue := -1;
          RETURN;
      End;
    End IF;
    Begin
	    UPDATE WMS_TASKGROUP SET ISAUDITING = 0 ,AUDITINGGUID = ' ',AUDITINGDATE = null  WHERE GUID  = V_BillGuid AND NVL(ISAUDITING,0) = 1;
	     EXCEPTION WHEN OTHERS THEN
       V_RETURNMSG := '反审失败！';
       V_RETURNVALUE := -1;
       ROLLBACK;
       Return;
    End;
	Commit;
	V_ReturnMsg :=' ';
	V_ReturnValue :=0;
  Return;
END;

