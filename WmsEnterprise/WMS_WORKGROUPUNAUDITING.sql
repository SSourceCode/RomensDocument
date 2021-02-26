
create or replace
PROCEDURE WMS_WORKGROUPUNAUDITING
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
    V_count NUMBER(10) :=0;
BEGIN
   select  count(*) INTO V_count  from wms_Workgroup WHERE  GUID = v_BillGuid and NVL(IsAuditing,0) = 0;
   if V_count>0 THEN
       begin
         V_ReturnMsg := '单据还未审核，无需反审！' ;
         V_ReturnValue := -1 ;
         RETURN;
       end;
   END IF;
   Begin
    update wms_Workgroup  set ISAUDITING=0,AUDITINGGUID='',AUDITINGDATE=NULL WHERE GUID = V_BillGuid and NVL(IsAuditing,0)=1;
    EXCEPTION  WHEN OTHERS THEN
            v_ReturnMsg:='反审失败!';
            v_ReturnValue := 2;
            ROLLBACK;
            RETURN;
   End;
   Commit;
	V_ReturnMsg := ' ' ;
    V_ReturnValue := 0 ;
	Return;
END;