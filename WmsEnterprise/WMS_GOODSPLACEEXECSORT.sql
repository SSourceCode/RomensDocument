create or replace
PROCEDURE          "WMS_GOODSPLACEEXECSORT"
---排序
(
  v_BillGuid-- 表单单据GUID
   IN VARCHAR2 DEFAULT NULL ,
  v_billTemplateGuid-- 表单GUID
   IN VARCHAR2 DEFAULT NULL ,
   v_ProType-- 类型 1=> ;2=>> ;3=<; 4=<<;5=上移；6=下移；7=置顶;8=置底
   IN VARCHAR2 DEFAULT NULL ,
  v_SiteNum-- 序号
   IN number DEFAULT 0 ,
  v_OperatorGuid-- 当前操作人员GUID
   IN VARCHAR2 DEFAULT NULL ,
  v_ReturnMsg-- 返回提示或错误信息
   OUT VARCHAR2,
  v_ReturnValue-- 返回提示或错误信息
   OUT NUMBER
)
AS

   v_count number;
   v_Num number;
BEGIN
    select count(*) into v_count from tt_selectguid where type='WMS_GoodsPlaceSort' and operatorguid=v_OperatorGuid;
    if (v_count=0) then
    begin
          v_ReturnMsg := '无记录，操作失败！' ;
          v_ReturnValue := -1 ;
          RETURN;
    end;
    end if ;
    update  WMS_GOODSPLACESORT set iszt='' where MAINGUID=v_billguid and BILLTEMPLATEGUID=v_BILLTEMPLATEGUID;
 ---------1,2,3,4
    if (v_ProType='1') then  -----1.>
    begin
        -----------1.先重新排序
        BEGIN
              update WMS_GOODSPLACESORT set SORTNUMBER=NVL(SORTNUMBER,0)+V_COUNT where SORTNUMBER>NVL(v_SiteNum,0) and BILLTEMPLATEGUID=V_BILLTEMPLATEGUID and mainguid=v_billguid ;
              EXCEPTION WHEN OTHERS THEN
              v_ReturnMsg := '>移位更新排序出错：'||sqlerrm(sqlcode);
              GOTO SQLERR1;
        END;
        -----------2.插入新纪录
        BEGIN
            insert into WMS_GOODSPLACESORT(GUID,BILLTEMPLATEGUID,GOODSPLACEGUID,MAINGUID,SORTNUMBER,iszt)
            SELECT SYS_GUID(),V_BILLTEMPLATEGUID,A.GUID,V_BILLGUID,
            A.DETAILNO+NVL(v_SiteNum,0),'Y' FROM tt_selectguid A
            LEFT JOIN (select guid ,GOODSPLACEGUID from WMS_GOODSPLACESORT where BILLTEMPLATEGUID=V_BILLTEMPLATEGUID)B ON B.GOODSPLACEGUID=A.GUID
            where A.type='WMS_GoodsPlaceSort' and A.operatorguid=v_OperatorGuid AND B.GUID IS NULL ;
            EXCEPTION WHEN OTHERS THEN
            v_ReturnMsg := '>移位出错：'||sqlerrm(sqlcode);
            GOTO SQLERR1;
        END;
    END;
    ELSE if (v_ProType='2') then -----2.>>
    begin
        -----------1.先重新排序
        BEGIN
              MERGE INTO WMS_GOODSPLACESORT A
              USING (
              SELECT GUID FROM tt_selectguid where type='WMS_GoodsPlaceSort' and operatorguid=v_OperatorGuid
              ) B ON (B.GUID=A.GOODSPLACEGUID AND A.BILLTEMPLATEGUID=V_BILLTEMPLATEGUID)
              WHEN MATCHED THEN UPDATE SET A.SORTNUMBER=NVL(SORTNUMBER,0)+V_COUNT where SORTNUMBER>NVL(v_SiteNum,0);
              EXCEPTION WHEN OTHERS THEN
              v_ReturnMsg := '>>移位更新排序出错：'||sqlerrm(sqlcode);
              GOTO SQLERR1;
        END;
        -----------2.插入新纪录
        BEGIN
            insert into WMS_GOODSPLACESORT(GUID,BILLTEMPLATEGUID,GOODSPLACEGUID,MAINGUID,SORTNUMBER,iszt)
            SELECT SYS_GUID(),V_BILLTEMPLATEGUID,A.GUID,V_BILLGUID,A.DETAILNO+NVL(v_SiteNum,0),'Y' FROM tt_selectguid A
            LEFT JOIN  (select guid ,GOODSPLACEGUID from WMS_GOODSPLACESORT where BILLTEMPLATEGUID=V_BILLTEMPLATEGUID) B ON B.GOODSPLACEGUID=A.GUID  where A.type='WMS_GoodsPlaceSort' and A.operatorguid=v_OperatorGuid   AND B.GUID IS NULL ;
            EXCEPTION WHEN OTHERS THEN
            v_ReturnMsg := '>>移位出错：'||sqlerrm(sqlcode);
            GOTO SQLERR1;
        END;
    END;
    else if (v_ProType='3') then -----3.<
    begin
        BEGIN
            DELETE FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID AND GUID IN (SELECT GUID FROM  tt_selectguid where type='WMS_GoodsPlaceSort' and operatorguid=v_OperatorGuid);
            EXCEPTION WHEN OTHERS THEN
            v_ReturnMsg := '<移位出错：'||sqlerrm(sqlcode);
            GOTO SQLERR1;
        END;
        --------重新排序
        begin
            Merge into  WMS_GOODSPLACESORT a
            USING (
            SELECT guid,row_number() over(partition by Mainguid  order by SORTNUMBER) AS SORTID  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID
            ) b on (b.guid=a.guid )
            when matched then update set a.SORTNUMBER=b.SORTID;
            EXCEPTION WHEN OTHERS THEN
            v_ReturnMsg := '<移位排序出错：'||sqlerrm(sqlcode);
            GOTO SQLERR1;
        end;
    END;
    ELSE if (v_ProType='4') then -----4.<<
    begin
        ------ 20200907 弃用
--         BEGIN
--             UPDATE GOODSPLACE SET UPORDER=null WHERE GOODSPLACEAREAGUID=V_BILLGUID;
--             EXCEPTION WHEN OTHERS THEN
--             v_ReturnMsg := '<<移位更新出错：'||sqlerrm(sqlcode);
--             GOTO SQLERR1;
--         END;
        BEGIN
            DELETE FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID;
            EXCEPTION WHEN OTHERS THEN
            v_ReturnMsg := '<<移位出错：'||sqlerrm(sqlcode);
            GOTO SQLERR1;
        END;
    end;
    end if ;
    end if ;
    end if ;
    end if ;
 -------------------------------*********移位***************----------------
  if (v_ProType='5') then ----------上移
  begin
      --------1.更新选择行 以上的记录
      BEGIN
            update WMS_GOODSPLACESORT set SORTNUMBER=NVL(SORTNUMBER,0)+V_COUNT  where SORTNUMBER=NVL(v_SiteNum,0)-1 and BILLTEMPLATEGUID=V_BILLTEMPLATEGUID and mainguid=v_billguid ;
            EXCEPTION WHEN OTHERS THEN
            v_ReturnMsg := '上移移位更新排序出错：'||sqlerrm(sqlcode);
            GOTO SQLERR1;
      END;
      --------------2.更新选择行的位置
      BEGIN
            MERGE INTO WMS_GOODSPLACESORT A
            USING (
            SELECT GUID FROM tt_selectguid where type='WMS_GoodsPlaceSort' and operatorguid=v_OperatorGuid
            ) B ON (B.GUID=A.GUID AND A.BILLTEMPLATEGUID=V_BILLTEMPLATEGUID)
            WHEN MATCHED THEN UPDATE SET A.SORTNUMBER=NVL(SORTNUMBER,0)-1,iszt='Y';
            EXCEPTION WHEN OTHERS THEN
            v_ReturnMsg := '上移排序出错：'||sqlerrm(sqlcode);
            GOTO SQLERR1;
      END;
       --------重新排序
      begin
          Merge into  WMS_GOODSPLACESORT a
          USING (
          SELECT guid,row_number() over(partition by Mainguid  order by SORTNUMBER) AS SORTID  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID
          ) b on (b.guid=a.guid )
          when matched then update set a.SORTNUMBER=b.SORTID;
          EXCEPTION WHEN OTHERS THEN
          v_ReturnMsg := '上移排序出错：'||sqlerrm(sqlcode);
          GOTO SQLERR1;
      end;
  end;
  else if (v_ProType='6') then -------下移
  begin
      --------1.更新选择行 以上的记录
          BEGIN
                update WMS_GOODSPLACESORT set SORTNUMBER=NVL(SORTNUMBER,0)-v_count where SORTNUMBER=NVL(v_SiteNum,0)+v_count and BILLTEMPLATEGUID=V_BILLTEMPLATEGUID and mainguid=v_billguid

                ;
                EXCEPTION WHEN OTHERS THEN
                v_ReturnMsg := '下移移位更新排序出错：'||sqlerrm(sqlcode);
                GOTO SQLERR1;
          END;
           --------------2.更新选择行的位置
          BEGIN
                MERGE INTO WMS_GOODSPLACESORT A
                USING (
                SELECT GUID FROM tt_selectguid where type='WMS_GoodsPlaceSort' and operatorguid=v_OperatorGuid
                ) B ON (B.GUID=A.GUID AND A.BILLTEMPLATEGUID=V_BILLTEMPLATEGUID)
                WHEN MATCHED THEN UPDATE SET A.SORTNUMBER=NVL(SORTNUMBER,0)+1,iszt='Y';
                EXCEPTION WHEN OTHERS THEN
                v_ReturnMsg := '下移排序出错：'||sqlerrm(sqlcode);
                GOTO SQLERR1;
          END;
           --------重新排序
      begin
          Merge into  WMS_GOODSPLACESORT a
          USING (
          SELECT guid,row_number() over(partition by Mainguid  order by SORTNUMBER) AS SORTID  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID
          ) b on (b.guid=a.guid )
          when matched then update set a.SORTNUMBER=b.SORTID;
          EXCEPTION WHEN OTHERS THEN
          v_ReturnMsg := '下移排序出错：'||sqlerrm(sqlcode);
          GOTO SQLERR1;
      end;
  end;
  else if (v_ProType='7') then   ---------置顶
  begin
  SELECT count(*) into v_Num FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID;
  ----------------先更新 选择的记录的 序号
     BEGIN
            MERGE INTO WMS_GOODSPLACESORT A
            USING (
            SELECT GUID FROM tt_selectguid where type='WMS_GoodsPlaceSort' and operatorguid=v_OperatorGuid
            ) B ON (B.GUID=A.GUID AND A.BILLTEMPLATEGUID=V_BILLTEMPLATEGUID)
            WHEN MATCHED THEN UPDATE SET A.SORTNUMBER=NVL(SORTNUMBER,0)-v_Num,iszt='Y';
            EXCEPTION WHEN OTHERS THEN
            v_ReturnMsg := '置顶移位更新排序出错：'||sqlerrm(sqlcode);
            GOTO SQLERR1;
      END;
       --------重新排序
      begin
          Merge into  WMS_GOODSPLACESORT a
          USING (
          SELECT guid,row_number() over(partition by Mainguid  order by SORTNUMBER) AS SORTID  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID
          ) b on (b.guid=a.guid )
          when matched then update set a.SORTNUMBER=b.SORTID;
          EXCEPTION WHEN OTHERS THEN
          v_ReturnMsg := '置顶排序出错：'||sqlerrm(sqlcode);
          GOTO SQLERR1;
      end;
  end;
  else if (v_ProType='8') then ------------置底
  begin
  SELECT count(*) into v_Num FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID;
  ----------------先更新 选择的记录的 序号
     BEGIN
            MERGE INTO WMS_GOODSPLACESORT A
            USING (
            SELECT GUID FROM tt_selectguid where type='WMS_GoodsPlaceSort' and operatorguid=v_OperatorGuid
            ) B ON (B.GUID=A.GUID AND A.BILLTEMPLATEGUID=V_BILLTEMPLATEGUID)
            WHEN MATCHED THEN UPDATE SET A.SORTNUMBER=NVL(SORTNUMBER,0)+v_Num,iszt='Y';
            EXCEPTION WHEN OTHERS THEN
            v_ReturnMsg := '置底移位更新排序出错：'||sqlerrm(sqlcode);
            GOTO SQLERR1;
      END;
       --------重新排序
      begin
          Merge into  WMS_GOODSPLACESORT a
          USING (
          SELECT guid,row_number() over(partition by Mainguid  order by SORTNUMBER) AS SORTID  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID
          ) b on (b.guid=a.guid )
          when matched then update set a.SORTNUMBER=b.SORTID;
          EXCEPTION WHEN OTHERS THEN
          v_ReturnMsg := '置底排序出错：'||sqlerrm(sqlcode);
          GOTO SQLERR1;
      end;
  end;
  end if ;
  end if ;
  end if ;
  end if ;

   -----------排序*********************如果是新单据，要在此处 添加 排序逻辑************-----------------------------------
    if (v_ProType!='4') then
    begin
    --------更新货位
          ----------货位表
     ------ 20200907 弃用
--           if(v_billTemplateGuid='90001065005') then
--           begin
--                UPDATE WMS_GOODSPLACE SET UPORDER=null WHERE GOODSPLACEAREAGUID=V_BILLGUID;
--               BEGIN
--                     MERGE INTO WMS_GOODSPLACE A
--                     USING (
--                     SELECT GOODSPLACEGUID,SORTNUMBER FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID
--                     ) B ON (B.GOODSPLACEGUID=A.GUID )
--                     WHEN MATCHED THEN UPDATE SET A.UPORDER=B.SORTNUMBER;
--                     EXCEPTION WHEN OTHERS THEN
--                     v_ReturnMsg := '移位货位排序出错：'||sqlerrm(sqlcode);
--                     GOTO SQLERR1;
--               END;
--           end;
--           end if ;
          -------------出库策略
          if(v_billTemplateGuid='10651520020') then
          begin
              UPDATE WMS_DownStrateGyDetail SET SELLOUTORDER=null WHERE MAINGUID=V_BILLGUID;
              BEGIN
                  MERGE INTO WMS_DownStrateGyDetail A
                  USING (
                  SELECT GOODSPLACEGUID,SORTNUMBER FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID
                  ) B ON (B.GOODSPLACEGUID=A.GOODSPLACEGUID )
                  WHEN MATCHED THEN UPDATE SET A.SELLOUTORDER=B.SORTNUMBER;
                  EXCEPTION WHEN OTHERS THEN
                  v_ReturnMsg := '移位货位排序出错：'||sqlerrm(sqlcode);
                  GOTO SQLERR1;
              END;
          end;
          end if ;
  -------------运输线路
    -- 运输线路
--           if(v_billTemplateGuid='90001035005') then
--           begin
--               BEGIN
--                   MERGE INTO wms_tranLinedetail A
--                   USING (
--                   SELECT GOODSPLACEGUID,SORTNUMBER FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =V_BILLTEMPLATEGUID AND Mainguid=V_BILLGUID
--                   ) B ON (B.GOODSPLACEGUID=A.GUID )
--                   WHEN MATCHED THEN UPDATE SET A.linenumber=B.SORTNUMBER;
--                   EXCEPTION WHEN OTHERS THEN
--                   v_ReturnMsg := '排序出错：'||sqlerrm(sqlcode);
--                   GOTO SQLERR1;
--               END;
--           end;
--           end if ;
    /*其他单据在此添加*/
  end;
  end if ;


      COMMIT;
      V_RETURNMSG := ' ' ;
      V_RETURNVALUE := 0 ;
      RETURN;
   <<SQLERR1>>
   V_RETURNVALUE := -1 ;
   rollback;
   RETURN;

END;
 