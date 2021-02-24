create or replace
PROCEDURE          "WMS_DOWNSTRATEGYAUDIT"
/*Description :出库定位策略审核*/
(v_billguid     in varchar2, -- 单据内码
 v_billtypeguid in varchar2, -- 单据类型
 v_auditingdate in date, -- 审核日期
 v_operatorguid in varchar2, -- 操作人员内码
 v_returnmsg    out varchar2, -- 返回提示信息
 v_returnvalue  out int -- 返回提示标志
 ) as
  v_info    varchar2(500);
  v_iswhole number(1); --1是整货0是散
  v_num     number;
  v_count   number;
  v_hw varchar2(100);
  v_xh varchar2(100);

begin

  --数据有效检测
  select case
           when nvl(a.isauditing, 0) = 1 then
            '当前单据已审核,不允许重复审核！'
         end
    into v_info
    from wms_downstrategy a
   where a.guid = v_billguid;
  if v_info is not null then
    v_returnmsg   := v_info;
    v_returnvalue := -1;
    return;
  end if;

  BEGIN
    --检测是否有明细数据
    v_count := 0;
    SELECT COUNT(1)
      INTO v_count
      FROM wms_downstrategydetail
     WHERE MAINGUID = v_billguid;
    IF v_count = 0 THEN
      v_returnmsg   := '没有明细数据，不允许审核';
      v_returnvalue := -1;
      return;
    END IF;
  END;

--   --检测明细中分区是否跟 表头的 存储属性一致
--   select iswhole
--     into v_iswhole
--     from wms_downstrategy
--    where guid = v_billguid;
--   begin
--     select case
--              when a.iswhole != v_iswhole then
--               '顺序号为[' || t.detailno || ']的明细存储属性与表头不一致！'
--            end
--       into v_info
--       from wms_downstrategydetail t
--       left join wms_goodsplacearea a
--         on t.goodsplaceareaguid = a.guid
--      where t.mainguid = v_billguid
--        and rownum <= 1;
--     if v_info is not null then
--       v_returnmsg   := v_info;
--       v_returnvalue := -1;
--       return;
--     end if;
--   end;

--   begin
--     --明细里不允许出现零货分区和整货分区混合在一起的
--     select count(1)
--       into v_num
--       from wms_downstrategydetail t
--       left join wms_goodsplacearea a
--         on t.goodsplaceareaguid = a.guid
--      where t.mainguid = v_billguid and a.iswhole = (select a.iswhole
--                           from wms_downstrategydetail t
--                           left join wms_goodsplacearea a
--                             on t.goodsplaceareaguid = a.guid
--                          where t.mainguid = v_billguid
--                            and rownum <= 1);
--
--     select count(1)
--       into v_count
--       from wms_downstrategydetail t
--       left join wms_goodsplacearea a
--         on t.goodsplaceareaguid = a.guid
--      where t.mainguid = v_billguid;
--
--     if v_num != v_count then
--       v_returnmsg   := '明细中不允许同时存在零货分区和整货分区';
--       v_returnvalue := -1;
--       return;
--     end if;
--   end;

  begin
    --检查一个货位只能维护一次出库配位属性
    begin
    select t.goodsplaceguid,t.detailno into v_hw,v_xh from WMS_DOWNSTRATEGYDETAIL t where t.mainguid = v_billguid
    and t.goodsplaceguid in (select a.goodsplaceguid from WMS_DOWNSTRATEGYDETAIL a where a.mainguid <> v_billguid) and rownum = 1 ;
    exception when others then
      v_hw := '';
    end;
    IF v_hw IS NOT NULL THEN
      BEGIN
        select '明细中序号:'||v_xh||',货位:'||t2.code||',在出库策略ID:'||t1.code||'中已经定义过,审核失败！' into v_returnmsg
        from WMS_DOWNSTRATEGYDETAIL t inner join WMS_DOWNSTRATEGY t1 on t.mainguid = t1.guid left join GOODSPLACE t2 on t.goodsplaceguid = t2.guid
        where t.goodsplaceguid = v_hw and t.mainguid <> v_billguid and rownum = 1;
        v_returnvalue := -1;
        return;
      END;
    END IF;


  end;

  begin
    --更新审核状态 审核人 审核时间
    UPDATE wms_downstrategy
       SET IsAuditing   = 1,
           AuditingDate = trunc(v_AuditingDate),
           AuditingGuid = v_OperatorGuid
     WHERE Guid = v_BillGuid;
  end;

  v_returnmsg   := '';
  v_returnvalue := 0;
  commit;
  return;
exception
  when others then
    v_returnmsg := '审核发生异常,错误信息：' || sqlerrm(sqlcode);
    rollback;
    v_returnvalue := -1;
    return;
end;
 