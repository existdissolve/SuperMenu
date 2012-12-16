IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[sm_LinkMenuContent]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[sm_LinkMenuContent];
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[sm_MenuItem]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[sm_MenuItem];
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[sm_Menu]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[sm_Menu];
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[sm_Zone]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[sm_Zone];

CREATE TABLE [dbo].[sm_Menu](
	[MenuID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](255) NOT NULL,
	[Slug] [varchar](255) NOT NULL,
	[MenuClass] [varchar](255) NULL,
	[ListType] [varchar](12) NULL,
	[ZoneID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];  

CREATE TABLE [dbo].[sm_MenuItem](
	[MenuItemID] [int] IDENTITY(1,1) NOT NULL,
	[MenuID] [int] NOT NULL,
	[Label] [varchar](255) NOT NULL,
	[Title] [varchar](255) NULL,
	[URL] [varchar](255) NULL,
	[ParentID] [int] NULL,
	[ContentID] [int] NULL,
	[Type] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MenuItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];


CREATE TABLE [dbo].[sm_LinkMenuContent](
	[LinkMenuContentID] [int] IDENTITY(1,1) NOT NULL,
	[ContentID] [int] NOT NULL,
	[MenuID] [int] NOT NULL,
	[ZoneID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LinkMenuContentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];

CREATE TABLE [dbo].[sm_Zone](
	[ZoneID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ZoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[sm_Zone] ADD  DEFAULT (NULL) FOR [Name];

ALTER TABLE [dbo].[sm_Menu] ADD  DEFAULT (NULL) FOR [Title];
ALTER TABLE [dbo].[sm_Menu] ADD  DEFAULT (NULL) FOR [MenuClass];
ALTER TABLE [dbo].[sm_Menu] ADD  DEFAULT ('ul') FOR [ListType];
ALTER TABLE [dbo].[sm_Menu] ADD  DEFAULT (NULL) FOR [ZoneID];
ALTER TABLE [dbo].[sm_Menu]  WITH CHECK ADD  CONSTRAINT [FK_sm_Menu_sm_Zone] FOREIGN KEY([ZoneID])
REFERENCES [dbo].[sm_Zone] ([ZoneID]);
ALTER TABLE [dbo].[sm_Menu] CHECK CONSTRAINT [FK_sm_Menu_sm_Zone];


ALTER TABLE [dbo].[sm_MenuItem] ADD  DEFAULT (NULL) FOR [Title];
ALTER TABLE [dbo].[sm_MenuItem] ADD  DEFAULT (NULL) FOR [URL];
ALTER TABLE [dbo].[sm_MenuItem] ADD  DEFAULT (NULL) FOR [ParentID];
ALTER TABLE [dbo].[sm_MenuItem] ADD  DEFAULT (NULL) FOR [ContentID];
ALTER TABLE [dbo].[sm_MenuItem] ADD  DEFAULT (NULL) FOR [Type];

ALTER TABLE [dbo].[sm_MenuItem]  WITH CHECK ADD  CONSTRAINT [FK_sm_MenuItem_cb_content] FOREIGN KEY([ContentID])
REFERENCES [dbo].[cb_content] ([contentID])
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE [dbo].[sm_MenuItem] CHECK CONSTRAINT [FK_sm_MenuItem_cb_content];

ALTER TABLE [dbo].[sm_MenuItem]  WITH CHECK ADD  CONSTRAINT [FK_sm_MenuItem_sm_Menu] FOREIGN KEY([MenuID])
REFERENCES [dbo].[sm_Menu] ([MenuID])
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE [dbo].[sm_MenuItem] CHECK CONSTRAINT [FK_sm_MenuItem_sm_Menu];

ALTER TABLE [dbo].[sm_MenuItem]  WITH CHECK ADD  CONSTRAINT [FK_sm_MenuItem_sm_MenuItem] FOREIGN KEY([ParentID])
REFERENCES [dbo].[sm_MenuItem] ([MenuItemID]);

ALTER TABLE [dbo].[sm_MenuItem] CHECK CONSTRAINT [FK_sm_MenuItem_sm_MenuItem];




ALTER TABLE [dbo].[sm_LinkMenuContent] ADD  DEFAULT (NULL) FOR [ZoneID];

ALTER TABLE [dbo].[sm_LinkMenuContent]  WITH CHECK ADD  CONSTRAINT [FK_sm_LinkMenuContent_cb_content] FOREIGN KEY([ContentID])
REFERENCES [dbo].[cb_content] ([contentID])
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE [dbo].[sm_LinkMenuContent] CHECK CONSTRAINT [FK_sm_LinkMenuContent_cb_content];

ALTER TABLE [dbo].[sm_LinkMenuContent]  WITH CHECK ADD  CONSTRAINT [FK_sm_LinkMenuContent_sm_Menu] FOREIGN KEY([MenuID])
REFERENCES [dbo].[sm_Menu] ([MenuID])
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE [dbo].[sm_LinkMenuContent] CHECK CONSTRAINT [FK_sm_LinkMenuContent_sm_Menu];

ALTER TABLE [dbo].[sm_LinkMenuContent]  WITH CHECK ADD  CONSTRAINT [FK_sm_LinkMenuContent_sm_Zone] FOREIGN KEY([ZoneID])
REFERENCES [dbo].[sm_Zone] ([ZoneID])
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE [dbo].[sm_LinkMenuContent] CHECK CONSTRAINT [FK_sm_LinkMenuContent_sm_Zone];