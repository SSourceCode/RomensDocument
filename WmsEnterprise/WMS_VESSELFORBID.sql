CREATE OR REPLACE PROCEDURE WMS_VESSELFORBID
(
	v_BillGuid IN VARCHAR2 DEFAULT NULL,
    v_BillTypeGuid IN VARCHAR2 DEFAULT NULL,
    v_OperatorGuid IN VARCHAR2 DEFAULT NULL ,
    v_ReturnMsg OUT NVARCHAR2,
    v_ReturnValue OUT NUMBER
) AS
    V_STATUS DECIMAL(10);
BEGIN
  Select  NVL(ISSTATUS,0) INTO V_STATUS From WMS_VESSEL Where GUID = V_BillGuid;
  IF V_STATUS = 0 Then
    Begin
      V_ReturnMsg  := '该容器已经禁用';
      V_ReturnValue := -1;
      RETURN;
    END;
  End IF;
  IF V_STATUS = 2 Then
    Begin
      V_ReturnMsg :='该容器正在使用,不允许禁用';
      V_ReturnValue := -1;
      RETURN;
    END;
    END IF;
  Begin
    Update WMS_VESSEL Set ISSTATUS = 0  WHERE GUID = V_BillGuid;
    EXCEPTION WHEN OTHERS THEN
         V_RETURNMSG := '禁用失败！';
         V_RETURNVALUE := -1;
         ROLLBACK;
         Return;
  End;
  Commit;
  V_ReturnMsg :=' ';
  V_ReturnValue := 0;
  Return;
 End;