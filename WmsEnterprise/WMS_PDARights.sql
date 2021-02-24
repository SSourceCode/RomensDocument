create or replace
PROCEDURE          "WMS_PDARIGHTS" 
----------PDA获取权限
(
  v_OperatorCode-- 当前操作人员GUID
   IN VARCHAR2 DEFAULT NULL ,
  v_ReturnMsg-- 返回提示或错误信息
   OUT VARCHAR2,
  v_RightModel
   OUT VARCHAR2,
  v_ReturnValue-- 返回提示或错误信息
   OUT NUMBER
)
AS
   V_COUNT number;
   v_OperatorGuid varchar2(100);
   v_RightModelGuid varchar2(50);
   v_RightValue varchar2(1000);
   v_rightinfo varchar2(1000);
   v_RightModeltemp varchar2(500);
   v_RightModelname varchar2(2000);

begin

    BEGIN
    select guid into v_OperatorGuid from operators where code = UPPER(v_OperatorCode);
    exception when others then
        V_RETURNMSG:='获取操作人员编号失败！'||sqlerrm(sqlcode);
        V_RETURNVALUE := -1 ;
        RETURN;
    END;
    
    v_RightModelGuid := 'a929152b-88c8-4180-8e3f-e36beafb61e4';
    select rightinfo2 into v_rightinfo from rightmodel where guid = v_RightModelGuid;
    
    v_RightModel := ' ';

      
      --按人授权
      V_COUNT := 0;
      SELECT COUNT(1) INTO V_COUNT FROM rights WHERE rightmodelguid=v_RightModelGuid AND OperatorGuid=v_OperatorGuid;
      IF V_COUNT = 1 THEN
        begin
          select RightValue2 into v_RightValue from rights where rightmodelguid=v_RightModelGuid and OperatorGuid=v_OperatorGuid;
          select wm_concat(modelname) into v_RightModel from (select column_value as modelname,rownum xuhao from table(WMS_strsplit(v_rightinfo)))a1
          inner join (select column_value as rightname,rownum xuhao from table(WMS_strsplit(v_RightValue)))a2 on a1.xuhao = a2.xuhao where a2.rightname = 1;
          exception when others then
            V_RETURNMSG:=SQLERRM(SQLCODE);
            v_ReturnValue := -1;
            return;
        end;
        BEGIN
        IF v_RightModel IS NULL THEN
          v_RightModel := ' ';
          V_RETURNMSG := ' ' ;
          v_ReturnValue := 0;
        return;
        END IF;
        END;
        V_RETURNMSG := ' ';
        v_ReturnValue := 0;
        return;
      END IF;
      --按小组授权
      V_COUNT := 0;
      select count(1) into V_COUNT from operatorGroupmember where Operatorguid=v_OperatorGuid;
      IF V_COUNT > 0 THEN
        BEGIN
          FOR C IN (select GroupGuid from operatorGroupmember where Operatorguid=v_OperatorGuid) LOOP
            V_COUNT := 0;
            select COUNT(1) into V_COUNT from rightgroup where OperatorGroupGuid=C.Groupguid and rightmodelguid=v_RightModelGuid;
            IF V_COUNT = 1 THEN
              BEGIN
                select rightvalue2 into v_RightValue from rightgroup where OperatorGroupGuid=C.Groupguid and rightmodelguid=v_RightModelGuid;
                select wm_concat(modelname) into v_RightModeltemp from (select column_value as modelname,rownum xuhao from table(WMS_strsplit(v_rightinfo)))a1
                inner join (select column_value as rightname,rownum xuhao from table(WMS_strsplit(v_RightValue)))a2 on a1.xuhao = a2.xuhao where a2.rightname = 1;
                exception when others then
                  V_RETURNMSG:=SQLERRM(SQLCODE);
                  v_ReturnValue := -1;
                  return;
              END;
             if v_RightModelname is null then
               v_RightModelname := v_RightModeltemp;
             else
               v_RightModelname := v_RightModelname||','||v_RightModeltemp;
             end if;
             
            END IF;
          END LOOP;
           SELECT wm_concat(valuename) into v_RightModel FROM (select distinct(column_value) AS valuename from table(WMS_strsplit(v_RightModelname)));
           IF v_RightModel IS NULL THEN
            v_RightModel := ' ';
            V_RETURNMSG := ' ' ;
            v_ReturnValue := 0;
          return;
          END IF;
           V_RETURNMSG := ' ';
           v_ReturnValue := 0;
           return;
        END;
      END IF;



    V_RETURNMSG := '当前人员没有任何权限' ;
    V_RETURNVALUE := -1 ;
    RETURN;

END;
 