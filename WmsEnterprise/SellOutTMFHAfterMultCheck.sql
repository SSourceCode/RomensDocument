--------2.增加个存储过程
CREATE OR REPLACE PROCEDURE SellOutTMFHAfterMultCheck
(
  v_OperatorGuid IN VARCHAR2 DEFAULT NULL ,--人员内码
  v_BRANCHGUID IN VARCHAR2 DEFAULT NULL ,--组织机构内码
  v_ReturnMsg OUT NVARCHAR2,-- 返回提示或错误信息
  v_ReturnValue OUT NUMBER
)
AS
   v_dh varchar2(50);
   v_lsh varchar2(50);
   v_boxNo varchar2(50);
   v_pickNum number(10);
BEGIN
for  wf  in ( select guid from tt_selectguid where type='TMFH_AfterMultSave' and operatorguid=v_OperatorGuid GROUP BY Guid)
loop
        SELECT lsh,WMSRECORDSTATUS into v_lsh,v_boxNo  from FAHUO where DH = v_dh;
        SELECT COUNT(1) into v_pickNum   FROM FAHUO WHERE WMSRECORDSTATUS = v_boxNo AND LSH = v_lsh  AND nvl(BoxBZ,0)= 0;
         IF(v_pickNum <= 0) Then
             Begin
                Update  WMS_VESSEL set ISSTATUS = 1 where CODE = V_boxNo;
             End;
         End IF;
end loop;
    COMMIT ;
    v_ReturnMsg :=' ' ;
    v_ReturnValue := 0 ;
    Return;
End;

