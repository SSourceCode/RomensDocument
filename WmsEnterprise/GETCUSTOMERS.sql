create or replace
FUNCTION       "GETCUSTOMERS"
--获取客户名称
(
  V_downstrategyguid IN VARCHAR2
)
RETURN VARCHAR2
AS
   v_Value VARCHAR2(2000);
BEGIN
SELECT listagg(A.MC,',') within GROUP(ORDER BY NULL) into v_Value FROM ( SELECT DISTINCT T2.MC FROM WMS_TASKGROUPDETAIL t inner join  FAHUOHEAD t1 on  t.LSH = t1.BillNo  INNER JOIN GL_CUSTOM t2 ON t1.CustomGuid = t2.TJBH where t.TASKGROUPGUID = V_downstrategyguid ) A;
   RETURN v_Value;
END;