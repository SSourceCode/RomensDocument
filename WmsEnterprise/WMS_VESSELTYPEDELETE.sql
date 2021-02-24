CREATE OR REPLACE PROCEDURE WMS_VESSELTYPEDELETE
(
	v_BillGuid IN VARCHAR2 DEFAULT NULL,
    v_BillTypeGuid IN VARCHAR2 DEFAULT NULL,
    v_OperatorGuid IN VARCHAR2 DEFAULT NULL ,
    v_ReturnMsg OUT NVARCHAR2,
    v_ReturnValue OUT NUMBER
) AS
    v_temp number(10);
BEGIN
  BEGIN
    SELECT COUNT(1) into v_temp FROM WMS_VESSEL WHERE VESSELTYPE = v_BillGuid;
	IF v_temp > 0 Then
        Begin
          v_ReturnMsg := '该容器类型正在使用,不能删除!';
          v_ReturnValue := -1;
          RETURN;
        End;
	End IF;
  END;
  BEGIN
    DELETE WMS_VESSELTYPE WHERE GUID = V_BillGuid;
     EXCEPTION WHEN OTHERS THEN
         V_RETURNMSG := '删除失败！';
         V_RETURNVALUE := -1;
         ROLLBACK;
         Return;
  End;
  Commit;
  V_ReturnMsg :=' ';
  V_ReturnValue := 0;
  Return;
END;

