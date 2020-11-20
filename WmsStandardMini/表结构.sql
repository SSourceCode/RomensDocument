
-- 容器

/****** Object:  Table [dbo].[WMS_VESSEL]    Script Date: 2020/11/17 17:50:35 
******/

SET ANSI_NULLS ON

GO



SET QUOTED_IDENTIFIER ON

GO



CREATE TABLE [dbo].[WMS_VESSEL](

       [GUID] [varchar](50) NOT NULL,

       [LOGISTICSCENTERGUID] [varchar](50) NULL,

       [OPERATORGUID] [varchar](50) NULL,

       [VESSELTYPE] [varchar](50) NULL,

       [CODE] [varchar](50) NULL,

       [ISSTATUS] [int] NULL,

       [REMARK] [varchar](200) NULL,

       [ISFORBIDDEN] [int] NULL,

PRIMARY KEY CLUSTERED 

(

       [GUID] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

) ON [PRIMARY]

GO



-- 容器类型

/****** Object:  Table [dbo].[WMS_VESSELTYPE]    Script Date: 2020/11/17 17:50:56 
******/

SET ANSI_NULLS ON

GO



SET QUOTED_IDENTIFIER ON

GO



CREATE TABLE [dbo].[WMS_VESSELTYPE](

       [GUID] [varchar](50) NOT NULL,

       [CODE] [varchar](50) NULL,

       [NAME] [varchar](50) NULL,

       [VOLUME] [decimal](16, 6) NULL,

       [VOLUMEPERCENT] [decimal](8, 6) NULL,

       [REMARK] [varchar](500) NULL,

       [OPERATORGUID] [varchar](50) NULL,

       [TYPE] [int] NULL,

PRIMARY KEY CLUSTERED 

(

       [GUID] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

) ON [PRIMARY]

GO





-- 工作小组

/****** Object:  Table [dbo].[WMS_WORKGROUP]    Script Date: 2020/11/17 17:49:28 
******/

SET ANSI_NULLS ON

GO



SET QUOTED_IDENTIFIER ON

GO



CREATE TABLE [dbo].[WMS_WORKGROUP](

       [GUID] [varchar](50) NOT NULL,

       [CODE] [varchar](20) NULL,

       [NAME] [varchar](20) NULL,

       [HELPCODE] [varchar](20) NULL,

       [LOGISTICSCENTERGUID] [varchar](50) NULL,

       [REMARK] [varchar](50) NULL,

       [OPERATORGUID] [varchar](50) NULL,

       [ISFORBIDDEN] [char](1) NULL,

       [FORBIDDENGUID] [varchar](50) NULL,

       [FORBIDDENDATE] [datetime] NULL,

       [ISAUDITING] [char](1) NULL,

       [AUDITINGDATE] [datetime] NULL,

       [AUDITINGGUID] [varchar](50) NULL,

PRIMARY KEY CLUSTERED 

(

       [GUID] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

) ON [PRIMARY]

GO





-- 工作小组明细

/****** Object:  Table [dbo].[WMS_WORKGROUPDETAIL]    Script Date: 2020/11/17 
17:49:48 ******/

SET ANSI_NULLS ON

GO



SET QUOTED_IDENTIFIER ON

GO



CREATE TABLE [dbo].[WMS_WORKGROUPDETAIL](

       [GUID] [varchar](50) NOT NULL,

       [WORKGROUPGUID] [varchar](50) NULL,

       [EMPLOYEEGUID] [varchar](50) NULL,

       [ISUPSCAN] [char](1) NULL,

       [ISDOWNSCAN] [char](1) NULL,

PRIMARY KEY CLUSTERED 

(

       [GUID] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

) ON [PRIMARY]

GO



--拣货策略主表

/****** Object:  Table [dbo].[WMS_DOWNSTRATEGY]    Script Date: 2020/11/17 
17:48:05 ******/

SET ANSI_NULLS ON

GO



SET QUOTED_IDENTIFIER ON

GO



CREATE TABLE [dbo].[WMS_DOWNSTRATEGY](

       [GUID] [varchar](50) NOT NULL,

       [LOGISTICSCENTERGUID] [varchar](50) NULL,

       [CODE] [varchar](50) NULL,

       [NAME] [varchar](50) NULL,

       [WORKGROUPGUID] [varchar](50) NULL,

       [REMARK] [varchar](50) NULL,

       [OPERATORGUID] [varchar](50) NULL,

       [ISFORBIDDEN] [bit] NULL,

       [FORBIDDENGUID] [varchar](50) NULL,

       [FORBIDDENDATE] [datetime] NULL,

       [ISWHOLE] [bit] NULL,

       [BULKTYPE] [int] NULL,

       [WHOLETYPE] [int] NULL,

       [ISSTATUS] [int] NULL,

       [ISAUDITING] [int] NULL,

       [AUDITINGGUID] [varchar](50) NULL,

       [AUDITINGDATE] [datetime] NULL,

       [VESSELTYPE] [varchar](50) NULL,

       [SORTID] [decimal](12, 0) NULL,

       [ELETAGS] [int] NULL,

 CONSTRAINT [PK__WMS_DOWNSTRATEGY__002A5AD3] PRIMARY KEY CLUSTERED 

(

       [GUID] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

) ON [PRIMARY]

GO





--拣货策略子表



/****** Object:  Table [dbo].[WMS_DOWNSTRATEGYDETAIL]    Script Date: 2020/11/17 
17:48:35 ******/

SET ANSI_NULLS ON

GO



SET QUOTED_IDENTIFIER ON

GO



CREATE TABLE [dbo].[WMS_DOWNSTRATEGYDETAIL](

       [GUID] [varchar](50) NOT NULL,

       [MAINGUID] [varchar](50) NULL,

       [DETAILNO] [varchar](50) NULL,

       [GOODSPLACEAREAGUID] [varchar](50) NULL,

       [GOODSPLACEGUID] [varchar](50) NULL,

       [SELLOUTORDER] [decimal](12, 0) NULL,

PRIMARY KEY CLUSTERED 

(

       [GUID] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

) ON [PRIMARY]

GO




/****** Object:  Table [dbo].[TKDBJL]    Script Date: 2020/11/18 17:58:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TKDBJL](
	[GUID] [varchar](50) NOT NULL,
	[DRStockId] [varchar](50) NULL,
	[DCStockId] [varchar](50) NULL,
	[DRKH] [varchar](50) NULL,
	[DCKH] [varchar](50) NULL,
	[HH] [varchar](50) NULL,
	[PH] [varchar](50) NULL,
	[DH] [varchar](50) NULL,
	[DBRQ] [datetime] NULL,
	[USERGUID] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[GUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE WMS_TASKGROUP(
    GUID VARCHAR(50) PRIMARY KEY ,
    CODE VARCHAR(50),
    NAME VARCHAR(50),
    CREATEDATE DATETIME,
    OPERATORGUID VARCHAR(50),
    ISAUDITING BIT,
    AUDITINGGUID VARCHAR(50),
    AUDITINGDATE DATETIME
)

CREATE TABLE WMS_TASKGROUPDETAIL(
    GUID VARCHAR(50) PRIMARY KEY,
    TASKGROUPGUID VARCHAR(50),
    FAHUOGUID VARCHAR(50),
    NOTES VARCHAR(200)
)