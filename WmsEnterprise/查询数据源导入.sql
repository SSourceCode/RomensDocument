SELECT * FROM BILLTEMPLATEDATASOURCE WHERE CODE like '1065151015005%' or code like '1065152001502%'or code like'10651520020%';
SELECT * FROM BILLTEMPLATE WHERE CODE = '1065151015005' or code = '1065152001502'or code ='10651520015';
SELECT * FROM BILLNUMBER WHERE BILLNO='1065151015005' or BILLNO = '1065152001502'or BILLNO ='10651520015' ;
SELECT * FROM DATAITEM WHERE CODE = '1065151015005' or code = '1065152001502'or code ='10651520015';
SELECT * FROM MENUSUBFUNCTION WHERE CODE = '1065151015005' or code = '1065152001502'or code ='10651520015';



-- 表单标准选择数据源
 SELECT * FROM  DATASELECTTYPE where CODE ='20200927005'or CODE ='20200928005'or CODE ='20200929001'or CODE ='20200929002'or CODE ='20200929005'or CODE ='20201027005';
 SELECT * FROM DATASELECTDEFINE WHERE DATASELECTTYPE in ('20200927005','20200928005','20200929001','20200929002','20200929005','20201027005');
SELECT * FROM DataSelectType where CODE = 'CKDBDZK-KH-SELECT';
SELECT * FROM DATASELECTDEFINE where DataSelectType = 'CKDBDZK-KH-SELECT';


--接口数据源
select * from DataQueryDefine WHERE DataQueryType like '%WMS-PDA'

-- 是否集中拣货标志
insert into SystemProfile (guid, moduleid, sectionname, keyname, keyvalue, keydescription, systemtype, forder)
values(sys_guid(),'1000','WMS-PDA','IsTaskGroup',0,'PDA是否启用集中拣货:0不启用1启用',0,30)

--TOKEN
SELECT  * FROM  APPAPIMANAGER where APPID = 'RomensWMS'

--权限
SELECT * FROM rightmodel where guid = 'a929152b-88c8-4180-8e3f-e36beafb61e4';

-- 变更 仓库调拨单明细货号选择数据源（如果不启用PDA调拨请不要执行脚本）
delete DataSelectType where CODE = 'StockDBMaterielSelect'
delete DATASELECTDEFINE where DataSelectType = 'StockDBMaterielSelect'
SELECT * FROM  DataSelectType where CODE = 'StockDBMaterielSelect'
SELECT * FROM DATASELECTDEFINE where DataSelectType = 'StockDBMaterielSelect'