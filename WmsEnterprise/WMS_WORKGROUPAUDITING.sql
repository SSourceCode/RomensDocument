create or replace
PROCEDURE          "WMS_WORKGROUPAUDITING"
(
  v_BillGuid IN VARCHAR2,       -- 单据内码
  v_BillTypeGuid IN VARCHAR2 ,  -- 单据类型
  v_AuditingDate IN DATE,       -- 审核日期
  v_OperatorGuid IN VARCHAR2 ,  -- 操作人员内码
  v_ReturnMsg OUT VARCHAR2 ,    -- 返回提示信息
  v_ReturnValue OUT INT         -- 返回提示标志
)
AS
   v_count number(10,0);
BEGIN
   v_count:=0;
   select count(*) into v_count from wms_Workgroup WHERE  GUID = v_BillGuid and nvl(IsAuditing,0)=1;
   if v_count>0 then
   begin
    v_ReturnMsg := '单据已经审核！' ;
      v_ReturnValue := -1 ;
      RETURN;

   end;
   end if ;

   BEGIN
   update wms_Workgroup  set ISAUDITING=1,AUDITINGGUID=V_Operatorguid,AUDITINGDATE=trunc(sysdate)
   WHERE GUID = v_BillGuid and nvl(IsAuditing,0)=0;

   EXCEPTION
            when OTHERS then
                V_RETURNMSG:='审核失败！'||sqlerrm(sqlcode);
                GOTO SQLERR1;
   END;
   --------------更新人员


    begin
    for c in (select workgroup,guid from operators where INSTR( WORKGROUP,v_BillGuid)>0) loop
      UPDATE  operators a SET a.WORKGROUP=(select wm_concat(column_value) from table(WMS_STRSPLIT(c.workgroup))where  column_value<>v_BillGuid) WHERE a.guid=c.guid;
    end loop;

    for c in (select employeeguid from WMS_WORKGROUPDETAIL where WORKGROUPGUID=v_BillGuid) loop
       select count(1)into v_count from operators a where a.guid=c.employeeguid and a.WORKGROUP is null;
       if v_count=1 then
           UPDATE  operators a SET a.WORKGROUP=v_BillGuid where a.guid=c.employeeguid;
       end if;
       if v_count=0  then
            UPDATE  operators a SET a.WORKGROUP=a.WORKGROUP||','||v_BillGuid WHERE a.guid=c.employeeguid;
       end if;

    end loop;

    EXCEPTION
        WHEN OTHERS THEN
            V_RETURNMSG:='更新作业组失败！'||sqlerrm(sqlcode);
            GOTO SQLERR1;
    end;




   BEGIN
           MERGE INTO operators A
           USING (
           SELECT EMPLOYEEGUID FROM WMS_WORKGROUPDETAIL  WHERE WORKGROUPGUID=V_BILLGUID
           ) B ON (B.EMPLOYEEGUID =A.GUID)
           WHEN MATCHED THEN UPDATE SET A.WORKGROUP=CASE WHEN A.WORKGROUP>0 THEN A.WORKGROUP||','||V_BILLGUID ELSE V_BILLGUID END;
           EXCEPTION
        WHEN OTHERS THEN
            V_RETURNMSG:='XXXX！'||sqlerrm(sqlcode);
   END;

      COMMIT;
      V_RETURNMSG := ' ' ;
      V_RETURNVALUE := 0 ;
      RETURN;
   <<SQLERR1>>
   V_RETURNVALUE := -1 ;
   rollback;
   RETURN;

END;
 