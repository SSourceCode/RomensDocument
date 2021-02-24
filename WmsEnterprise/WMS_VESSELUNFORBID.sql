CREATE OR REPLACE PROCEDURE WMS_VESSELUNFORBID
(
	v_BillGuid IN VARCHAR2 DEFAULT NULL,
    v_BillTypeGuid IN VARCHAR2 DEFAULT NULL,
    v_OperatorGuid IN VARCHAR2 DEFAULT NULL ,
    v_ReturnMsg OUT NVARCHAR2,
    v_ReturnValue OUT NUMBER
) AS
    V_ISSTATUS NUMBER(10) := 0;
BEGIN
  SELECT NVL(ISSTATUS,0) INTO V_ISSTATUS FROM WMS_VESSEL WHERE GUID = V_BillGuid;
  IF V_ISSTATUS != 0 Then
	BEGIN
		V_ReturnMsg   := '该容器不是禁用状态,不允许启用!';
		V_ReturnValue := -1;
		RETURN;
	END;
  End IF;
  Begin
    Update WMS_VESSEL Set ISSTATUS = 1 WHERE GUID = V_BillGuid and NVL(ISSTATUS, 0) = 0;
     EXCEPTION WHEN OTHERS THEN
         V_RETURNMSG := '启用失败！';
         V_RETURNVALUE := -1;
         ROLLBACK;
         Return;
  End;
  Commit;
  V_ReturnMsg :=' ';
  V_ReturnValue := 0;
  return;
END;