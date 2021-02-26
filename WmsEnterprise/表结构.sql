-- 容器

CREATE TABLE WMS_VESSEL(

        GUID    varchar2 (50) primary key ,

        LOGISTICSCENTERGUID    varchar2(50) NULL,

        OPERATORGUID    varchar2(50) NULL,

        VESSELTYPE    varchar2(50) NULL,

        CODE    varchar2(50) NULL,

        ISSTATUS   number(10)  NULL,

        REMARK    varchar2(200) NULL,

        ISFORBIDDEN   number(10)  NULL
    );

-- 容器类型
CREATE TABLE WMS_VESSELTYPE(

       GUID varchar2(50)  primary key ,

       CODE varchar2(50) NULL,

       NAME varchar2(50) NULL,

       VOLUME number(16, 6) NULL,

       VOLUMEPERCENT number(8, 6) NULL,

       REMARK varchar2(500) NULL,

       OPERATORGUID varchar2(50) NULL,

       TYPE number(10) NULL
    );

-- 工作小组

CREATE TABLE WMS_WORKGROUP(

       GUID varchar2(50) primary key,

       CODE varchar2(20) NULL,

       NAME varchar2(20) NULL,

       HELPCODE varchar2(20) NULL,

       LOGISTICSCENTERGUID varchar2(50) NULL,

       REMARK varchar2(50) NULL,

       OPERATORGUID varchar2(50) NULL,

       ISFORBIDDEN number(1) NULL,

       FORBIDDENGUID varchar2(50) NULL,

       FORBIDDENDATE date NULL,

       ISAUDITING number(1) NULL,

       AUDITINGDATE date NULL,

       AUDITINGGUID varchar2(50) NULL
    );

-- 工作小组明细
CREATE TABLE WMS_WORKGROUPDETAIL(

       GUID varchar2(50) primary key,

       WORKGROUPGUID varchar2(50) NULL,

       EMPLOYEEGUID varchar2(50) NULL,

       ISUPSCAN number(1) NULL,

       ISDOWNSCAN number(1) NULL
    );

--拣货策略主表

CREATE TABLE  WMS_DOWNSTRATEGY(

       GUID varchar2(50) primary key,

       LOGISTICSCENTERGUID varchar2(50) NULL,

       CODE varchar2(50) NULL,

       NAME varchar2(50) NULL,

       WORKGROUPGUID varchar2(50) NULL,

       REMARK varchar2(50) NULL,

       OPERATORGUID varchar2(50) NULL,

       ISFORBIDDEN number(1) NULL,

       FORBIDDENGUID varchar2(50) NULL,

       FORBIDDENDATE date NULL,

       ISWHOLE number(1) NULL,

       BULKTYPE number(10) NULL,

       WHOLETYPE number(10) NULL,

       ISSTATUS number(1) NULL,

       ISAUDITING number(1) NULL,

       AUDITINGGUID varchar2(50) NULL,

       AUDITINGDATE date NULL,

       VESSELTYPE varchar2(50) NULL,

       SORTID number(12, 0) NULL,

       ELETAGS number(10) NULL
    );

 --拣货策略子表
CREATE TABLE WMS_DOWNSTRATEGYDETAIL(
       GUID varchar2(50) NOT NULL,
       MAINGUID varchar2(50) NULL,
       DETAILNO varchar2(50) NULL,
       GOODSPLACEAREAGUID varchar2(50) NULL,
       GOODSPLACEGUID varchar2(50) NULL,
       SELLOUTORDER number(12, 0) NULL
);

--同库调拨记录
CREATE TABLE TKDBJL(
	GUID varchar2(50) primary key ,
	DRStockId varchar2(50) NULL,
	DCStockId varchar2(50) NULL,
	DRKH varchar2(50) NULL,
	DCKH varchar2(50) NULL,
	HH varchar2(50) NULL,
	PH varchar2(50) NULL,
	SL DECIMAL(18,6) default 0,
	DH varchar2(50) NULL,
	DBRQ datetime NULL,
	USERGUID varchar2(50) NULL
);

--集中拣货记录主表
CREATE TABLE WMS_TASKGROUP(
	GUID varchar2(50)  primary key ,
	CODE varchar2(50) NULL,
	NAME varchar2(50) NULL,
	CREATEDATE date NULL,
	OPERATORGUID varchar2(50) NULL,
	ISAUDITING number(1) NULL,
	AUDITINGGUID varchar2(50) NULL,
	AUDITINGDATE date NULL,
	ISPICKING number(1) NULL
);

--集中拣货记录子表
CREATE TABLE WMS_TASKGROUPDETAIL(
	GUID varchar2(50) primary key ,
	TASKGROUPGUID varchar2(50) NULL,
	FAHUOHEADGUID varchar2(50) NULL,
	NOTES varchar2(200) NULL
    )


CREATE TABLE  WMS_GOODSPLACESORT(
	GUID varchar2(50) primary key ,
	BILLTEMPLATEGUID varchar2(50) NULL,
	GOODSPLACEGUID varchar2(50) NULL,
	SORTNUMBER number(10) NULL,
	MAINGUID varchar2(50) NULL,
	ISZT varchar2(20) NULL
 )