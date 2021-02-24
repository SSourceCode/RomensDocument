CREATE OR REPLACE PROCEDURE WMS_TASKGROUPAUDITING
(
	v_BillGuid IN VARCHAR2 DEFAULT NULL,
    v_BillTypeGuid IN VARCHAR2 DEFAULT NULL,
    v_OperatorGuid IN VARCHAR2 DEFAULT NULL ,
    v_AuditingDate date,			--审核日期
    v_ReturnMsg OUT NVARCHAR2,
    v_ReturnValue OUT NUMBER
  )
  AS
  v_temp number(1):=0;
BEGIN
    SELECT COUNT(1) into v_temp FROM WMS_TASKGROUP WHERE nvl(ISAUDITING,0) = 1 AND GUID  = v_BILLGUID;
    IF V_temp <> 0 Then
	Begin
      V_ReturnMsg := '当前波次已审核,不能审核!';
      V_ReturnValue := -1;
      RETURN;
    End;
	End If;
    Begin
	UPDATE WMS_TASKGROUP SET ISAUDITING = 1 ,AUDITINGGUID = v_OperatorGuid,AUDITINGDATE = sysdate  WHERE GUID  =v_BillGuid AND nvl(ISAUDITING,0)=0;
	 EXCEPTION WHEN OTHERS THEN
     V_RETURNMSG := '审核失败！';
     V_RETURNVALUE := -1;
     ROLLBACK;
     return ;
     End;
	Commit;
	v_ReturnMsg :=' ';
	v_ReturnValue :=0;
	Return;
END;
