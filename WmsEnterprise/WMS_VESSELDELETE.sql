CREATE OR REPLACE PROCEDURE WMS_VESSELDELETE
(
	v_BillGuid IN VARCHAR2 DEFAULT NULL,
    v_BillTypeGuid IN VARCHAR2 DEFAULT NULL,
    v_OperatorGuid IN VARCHAR2 DEFAULT NULL ,
    v_ReturnMsg OUT NVARCHAR2,
    v_ReturnValue OUT NUMBER
  )
  AS
  V_temp NUMBER(10) := 0;
BEGIN
    SELECT COUNT(1) INTO V_temp FROM WMS_VESSEL  WHERE GUID = V_BillGuid  AND NVL(ISSTATUS, 1) <> 1;
    IF V_temp <> 0 THEN
        Begin
          V_ReturnMsg := '该容器不是空闲状态,不能删除!';
          V_ReturnValue := -1;
          RETURN;
        End;
	END IF;
    Begin
	    DELETE WMS_VESSEL WHERE GUID = V_BillGuid;
	    EXCEPTION WHEN OTHERS THEN
        V_RETURNMSG := '删除失败！';
        V_RETURNVALUE := -1;
        ROLLBACK;
        Return;
    End;
	Commit;
	v_ReturnMsg := '删除成功!';
	v_ReturnValue := 0;
	Return;
END;