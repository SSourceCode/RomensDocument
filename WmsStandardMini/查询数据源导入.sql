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


-- 表单插入语句
-- 表单插入语句
INSERT INTO BILLTEMPLATEDATASOURCE SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data Source=58.56.178.146,11433;User ID=sa;Password=密码').F4ERP.dbo.BILLTEMPLATEDATASOURCE WHERE CODE like '10051508005%' or code like '10051508006%'or code like'10051508007%' or code like '10051508008%' OR CODE LIKE  '100515010150%';
INSERT INTO BILLTEMPLATE SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data Source=58.56.178.146,11433;User ID=sa;Password=密码').F4ERP.dbo.BILLTEMPLATE WHERE CODE = '10051508005' or code = '10051508006'or code ='10051508007' or code = '10051508008' OR CODE ='100515010150';
INSERT INTO BILLNUMBER SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data Source=58.56.178.146,11433;User ID=sa;Password=密码').F4ERP.dbo.BILLNUMBER WHERE BILLNO='10051508005' or BILLNO = '10051508006'or BILLNO ='10051508007' or BILLNO = '10051508008' or billno = '100515010150';
INSERT INTO DATAITEM SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data Source=58.56.178.146,11433;User ID=sa;Password=密码').F4ERP.dbo.DATAITEM WHERE CODE='10051508005' or code = '10051508006'or code ='10051508007' or code = '10051508008' or code = '100515010150';
INSERT INTO MENUSUBFUNCTION SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data Source=58.56.178.146,11433;User ID=sa;Password=密码').F4ERP.dbo.MENUSUBFUNCTION WHERE CODE='10051508005' or code = '10051508006'or code ='10051508007' or code = '10051508008' or code = '100515010150';
-- 表单标准选择数据源

INSERT INTO DATASELECTTYPE SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data 
Source=58.56.178.146,11433;User 
ID=sa;Password=密码').F4ERP.dbo.DATASELECTTYPE where  CODE 
='20200927005'or CODE ='20200928005'or CODE ='20200929001'or CODE ='20200929002'or 
CODE ='20200929005'or CODE ='20201027005';


INSERT INTO DATASELECTDEFINE SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data 
Source=58.56.178.146,11433;User 
ID=sa;Password=密码').F4ERP.dbo.DATASELECTDEFINE WHERE 
DATASELECTTYPE in 
('20200927005','20200928005','20200929001','20200929002','20200929005','20201027005');


INSERT INTO DataSelectType SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data 
Source=58.56.178.146,11433;User 
ID=sa;Password=密码').F4ERP.dbo.DataSelectType where CODE = 
'CKDBDZK-KH-SELECT'

INSERT INTO DATASELECTDEFINE  SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data 
Source=58.56.178.146,11433;User 
ID=sa;Password=密码').F4ERP.dbo.DATASELECTDEFINE where 
DataSelectType = 'CKDBDZK-KH-SELECT'


-- 变更 仓库调拨单明细货号选择数据源
delete  DataSelectType where CODE = 'StockDBMaterielSelect'

delete DATASELECTDEFINE where DataSelectType = 'StockDBMaterielSelect'



INSERT INTO DataSelectType SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data 
Source=58.56.178.146,11433;User 
ID=sa;Password=密码').F4ERP.dbo.DataSelectType where CODE = 
'StockDBMaterielSelect'

INSERT INTO DATASELECTDEFINE  SELECT * FROM OPENDATASOURCE('SQLOLEDB','Data 
Source=58.56.178.146,11433;User 
ID=sa;Password=密码').F4ERP.dbo.DATASELECTDEFINE where 
DataSelectType = 'StockDBMaterielSelect'


--接口数据源
insert into DataQueryDefine select * from OPENDATASOURCE('SQLOLEDB','Data Source=58.56.178.146,11433;User ID=sa;Password=密码').F4ERP.dbo.DataQueryDefine WHERE DataQueryType like '%WMS-PDA'

update DATAQUERYDEFINE  set selectsql = upper(Cast(selectsql as varchar(8000))) 
WHERE DataQueryType like '%WMS-PDA'


-- 是否集中拣货标志
insert into SystemProfile (guid, moduleid, sectionname, keyname, keyvalue, keydescription, systemtype, forder)
values(newid(),'1000','WMS-PDA','IsTaskGroup',0,'PDA是否启用集中拣货:0不启用1启用',0,30)


insert into rightmodel Select * From OPENDATASOURCE('SQLOLEDB','Data Source=58.56.178.146,11433;User ID=sa;Password=romens@technology1').F4ERP.dbo.rightmodel where guid = '6d66d794-6881-49a2-9347-4a5064502369';