create or replace
PROCEDURE          "WMS_DOWNSTRATEGYUNAUDIT" 
/*Description :出库定位策略反审核*/
(
  v_BillGuid IN VARCHAR2,       -- 单据内码
  v_BillTypeGuid IN VARCHAR2 ,  -- 单据类型
  v_OperatorGuid IN VARCHAR2 ,  -- 操作人员内码
  v_ReturnMsg OUT VARCHAR2 ,    -- 返回提示信息
  v_ReturnValue OUT INT         -- 返回提示标志
)

AS
    V_INFO varchar2( 500);
begin

  --数据有效检测
  select case when NVL(a.ISAUDITING,0) = 0 then '当前单据未审核,不允许反审核！'
              --WHEN NVL(A.ISSTATUS,0) = 1 THEN '当前单据已启用,不允许反审核！'
         END INTO v_Info
  FROM WMS_DOWNSTRATEGY A
  WHERE A.guid = v_BillGuid;

  IF v_Info IS NOT NULL THEN
    v_ReturnMsg := v_Info;
    v_ReturnValue := -1;
    RETURN;
  END IF;

  UPDATE WMS_DOWNSTRATEGY
         SET IsAuditing = 0,
             AuditingDate = '',
             AuditingGuid = ''
  WHERE Guid = v_BillGuid;

  v_ReturnMsg := '';
  v_ReturnValue := 0;
  COMMIT;
  RETURN;
EXCEPTION
  WHEN OTHERS THEN
    V_ReturnMsg:= '反审发生异常,错误信息：' ||sqlerrm( sqlcode);
    ROLLBACK;
    v_ReturnValue:=- 1;
    RETURN;
END;
 