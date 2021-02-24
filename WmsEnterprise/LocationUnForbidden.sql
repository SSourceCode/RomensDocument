CREATE OR REPLACE PROCEDURE LocationUnForbidden
(
    v_BillGuid IN VARCHAR2 DEFAULT NULL,
    v_BillTypeGuid IN VARCHAR2 DEFAULT NULL,
    v_OperatorGuid IN VARCHAR2 DEFAULT NULL ,
    v_ReturnMsg OUT NVARCHAR2,
    v_ReturnValue OUT NUMBER
)
As
    v_count number(10);
Begin
    Select count(1) into v_count from GoodsPlace  where NVL(IsForbidden , 0 ) = 1 and guid = v_BillGuid;
	--判断是否审核
	IF v_count >0 Then
	Begin
		v_ReturnMsg := '本单据尚未禁用，不能启用!';
		v_ReturnValue :=-1;
		return;
	End;
	End If;
	BEGIN
        Update GoodsPlace set IsForbidden=0,FORBIDDENDATE=NULL,FORBIDDENGUID=' ' where GUID = v_BillGuid;
        EXCEPTION WHEN OTHERS THEN
             V_RETURNMSG := '禁用执行失败！';
             V_RETURNVALUE := -1;
             ROLLBACK;
             RETURN;
    End;
    COMMIT;
    V_RETURNMSG := ' ';
    V_RETURNVALUE :=0;
    RETURN;
END;
