create or replace
PROCEDURE  WMS_DOWNSTRATEGYDELETE
(
  v_BillGuid
   IN VARCHAR2 DEFAULT NULL ,
  v_BillTypeGuid
   IN VARCHAR2 DEFAULT NULL ,
  v_OperatorGuid
   IN VARCHAR2 DEFAULT NULL ,
  v_ReturnMsg
   OUT NVARCHAR2,
  v_ReturnValue
   OUT NVARCHAR2
)
AS
   v_count INT := 0;
BEGIN
   SELECT nvl(ISAUDITING,0) into  v_count FROM WMS_DOWNSTRATEGY WHERE  GUID = v_BillGuid;
   IF v_count <> 0 THEN
   BEGIN
       v_ReturnMsg := '该策略已审核,不能删除!' ;
       v_ReturnValue := -1 ;
       RETURN;
   END;
   end if;
    Begin
     DELETE WMS_DOWNSTRATEGY  WHERE GUID = v_BillGuid and NVL(ISAUDITING,'0')='0';
        EXCEPTION WHEN OTHERS THEN
        v_ReturnMsg := '删除数据出错！' ;
        GOTO SQLERR1;
    End;
    Begin
        DELETE WMS_DOWNSTRATEGYDETAIL  WHERE mainguid = v_BillGuid ;
            EXCEPTION  WHEN OTHERS THEN
            v_ReturnMsg := '删除数据出错！' ;
            GOTO SQLERR1;
    End;
   ----------删除排序
    Begin
        DELETE WMS_GOODSPLACESORT where BILLTEMPLATEGUID='10651520020' and mainguid=v_Billguid;
            EXCEPTION WHEN OTHERS THEN
            v_ReturnMsg := '删除数据出错！' ;
            GOTO SQLERR1;
    End;
   commit;
   v_ReturnMsg := '' ;
   v_ReturnValue := 0 ;
   RETURN;
    <<SQLERR1>>
      V_RETURNVALUE:=-1;
      ROLLBACK;
      RETURN;
END;