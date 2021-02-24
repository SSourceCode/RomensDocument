create or replace
PROCEDURE          "WMS_WORKGROUPDELETE"
(
  v_BillGuid-- 待删除的表单单据GUID
   IN VARCHAR2 DEFAULT NULL ,
  v_BillTypeGuid-- 待删除的表单GUID
   IN VARCHAR2 DEFAULT NULL ,
  v_OperatorGuid-- 当前操作人员GUID
   IN VARCHAR2 DEFAULT NULL ,
  v_ReturnMsg-- 返回提示或错误信息
   OUT VARCHAR2,
  v_ReturnValue-- 返回提示或错误信息
   OUT NUMBER
)
AS
   v_ISFORBIDDEN number;
BEGIN
   SELECT ISFORBIDDEN into v_ISFORBIDDEN  FROM wms_Workgroup WHERE  GUID = v_BillGuid;
   IF v_ISFORBIDDEN = 0 THEN
   BEGIN
      v_ReturnMsg := '该小组正在使用,不能删除!' ;
      v_ReturnValue := -1 ;
      RETURN;
   END;
   END IF;
   BEGIN
   DELETE wms_Workgroup  WHERE GUID = v_BillGuid and nvl(ISFORBIDDEN,1)=1;
   delete wms_Workgroupdetail WHERE GUID = v_BillGuid;
   EXCEPTION
            WHEN OTHERS THEN
                V_RETURNMSG:='删除失败！';
                GOTO SQLERR1;
  END;
  -------------从人员表中删除
  begin
  for c in (select workgroup,guid from OPERATORS where INSTR( WORKGROUP,v_BillGuid)>0) loop
    UPDATE  OPERATORS SET WORKGROUP=(select wm_concat(column_value) from table(WMS_STRSPLIT(c.workgroup))where  column_value<>v_BillGuid) WHERE guid=c.guid;
  end loop;
   EXCEPTION
            WHEN OTHERS THEN
                V_RETURNMSG:='更新作业组失败！'||sqlerrm(sqlcode);
                GOTO SQLERR1;
  end;

     COMMIT;
      V_RETURNMSG := ' ' ;
      V_RETURNVALUE := 0 ;
      RETURN;
   <<SQLERR1>>
   V_RETURNVALUE := -1 ;
   rollback;
   RETURN;

END;
 