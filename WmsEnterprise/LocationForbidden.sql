create or replace PROCEDURE  LocationForbidden
( v_BillGuid IN VARCHAR2 DEFAULT NULL, -- 待审核的表单单据GUID
  v_BillTypeGuid IN VARCHAR2 DEFAULT NULL, --待审核的表单GUID
  v_OperatorGuid IN VARCHAR2 DEFAULT NULL ,--操作人员内码
  v_ReturnMsg OUT NVARCHAR2,-- 返回提示或错误信息
  v_ReturnValue OUT NUMBER
)
As
    v_count number(10);
begin

    Select count(guid) into v_count from GoodsPlace  where isnull(IsForbidden,'0')='1' and guid=v_BillGuid;
	--判断是否审核
	IF v_count > 0 then
        Begin
            v_ReturnMsg :='本单据已禁用，无法重复禁用!';
            v_ReturnValue:=-1;
            return;
        End;
	End IF;
	BEGIN
        v_count := 0;
	    --检测是否已启用，库位GUID 与 CODE 必须保持一致
	    SELECT count(1) INTO v_count FROM GoodsPlaceBalance WHERE GOODSPLACENO  = v_BillGuid And NVL(Quantity,0)>0;
        IF v_count > 0 Then
            Begin
                v_ReturnMsg := '货位已启用,不允许删除！';
                v_ReturnValue := - 1;
                RETURN;
            End;
        End IF;
        v_count := 0;
        select count(1) INTO v_count from phk a inner join goodsplace b on a.KH = b.Code and a.StockID = b.WarehouseGuid where B.GUID = v_BillGuid AND A.SL > 0;
        IF( v_count > 0) THEN
         Begin
            set @ReturnMsg='当前库位已在PHK中使用无法禁用!';
            set @ReturnValue=-1;
            return;
         End;
        End IF;
    END;
	Begin
	    update GoodsPlace set IsForbidden = 1, FORBIDDENDATE=v_AuditingDate, FORBIDDENGUID=v_OperatorGuid where guid=v_BillGuid;
	    EXCEPTION WHEN OTHERS THEN
         V_RETURNMSG := '启用执行失败！';
         V_RETURNVALUE := -1;
         ROLLBACK;
         RETURN;
	End;
	COMMIT;
    V_RETURNMSG := ' ';
    V_RETURNVALUE :=0;
    RETURN;
