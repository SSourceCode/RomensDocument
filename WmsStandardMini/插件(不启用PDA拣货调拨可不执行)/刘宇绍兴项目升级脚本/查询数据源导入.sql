-- 允许远程插入开关
-- 开
exec sp_configure 'show advanced options',1;
reconfigure;
exec sp_configure 'Ad Hoc Distributed Queries',1;
reconfigure;
-- 关
exec sp_configure 'Ad Hoc Distributed Queries',0;
reconfigure;
exec sp_configure 'show advanced options',0;
reconfigure;

--先删除后新增--接口数据源
delete DataQueryDefine WHERE DataQueryType like '%WMS-PDA'

insert into DataQueryDefineinsert into DataQueryDefine select * from OPENDATASOURCE('SQLOLEDB','Data Source=sjjcomeon.vicp.cc,18240;User ID=sa;Password=Romens@1').EBWMS.dbo.DataQueryDefine WHERE DataQueryType like '%WMS-PDA'


-- 是否集中拣货标志
insert into SystemProfile (guid, moduleid, sectionname, keyname, keyvalue, keydescription, systemtype, forder)
values(newid(),'1000','WMS-PDA','IsTaskGroup',0,'PDA是否启用集中拣货:0不启用1启用',0,30)


--权限
 INSERT INTO rightmodel SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data Source=sjjcomeon.vicp.cc,18240;User ID=sa;Password=Romens@1').EBWMS.dbo.rightmodel where guid = '6d66d794-6881-49a2-9347-4a5064502369';

-- 变更 仓库调拨单明细货号选择数据源（如果不启用PDA调拨请不要执行脚本）
delete  DataSelectType where CODE = 'StockDBMaterielSelect'
delete DATASELECTDEFINE where DataSelectType = 'StockDBMaterielSelect'
INSERT INTO DataSelectType SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data Source=sjjcomeon.vicp.cc,18240;User ID=sa;Password=Romens@1').EBWMS.dbo.DataSelectType where CODE = 'StockDBMaterielSelect'
INSERT INTO DATASELECTDEFINE  SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data Source=sjjcomeon.vicp.cc,18240;User ID=sa;Password=Romens@1').EBWMS.dbo.DATASELECTDEFINE where DataSelectType = 'StockDBMaterielSelect'
