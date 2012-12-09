IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[sm_LinkMenuContent]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[sm_LinkMenuContent]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[sm_MenuItem]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[sm_MenuItem]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[sm_Menu]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[sm_Menu]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[sm_Zone]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
  DROP TABLE [dbo].[sm_Zone]
GO

CREATE TABLE [sm_LinkMenuContent] (
[LinkMenuContentID] int NOT NULL,
[ContentID] int NOT NULL,
[MenuID] int NOT NULL,
[ZoneID] int NULL DEFAULT NULL,
PRIMARY KEY ([LinkMenuContentID]) 
)
GO

CREATE INDEX [MenuID] ON [sm_LinkMenuContent] ([MenuID] )
GO
CREATE INDEX [ZoneID] ON [sm_LinkMenuContent] ([ZoneID] )
GO
CREATE INDEX [ContentID] ON [sm_LinkMenuContent] ([ContentID] )
GO

CREATE TABLE [sm_Menu] (
[MenuID] int NOT NULL,
[Title] varchar(255) NOT NULL DEFAULT '',
[Slug] varchar(255) NOT NULL,
[MenuClass] varchar(255) NULL DEFAULT '',
[ListType] varchar(12) NULL DEFAULT 'ul',
[ZoneID] int NULL DEFAULT NULL,
PRIMARY KEY ([MenuID]) 
)
GO

CREATE INDEX [fk_sm_Menu_Zone] ON [sm_Menu] ([ZoneID] )
GO

CREATE TABLE [sm_MenuItem] (
[MenuItemID] int NOT NULL,
[MenuID] int NOT NULL,
[Label] varchar(255) NOT NULL,
[Title] varchar(255) NULL DEFAULT NULL,
[URL] varchar(255) NULL DEFAULT '',
[ParentID] int NULL DEFAULT NULL,
[ContentID] int NULL DEFAULT NULL,
[Type] varchar(255) NOT NULL DEFAULT '',
PRIMARY KEY ([MenuItemID]) 
)
GO

CREATE INDEX [ParentID] ON [sm_MenuItem] ([ParentID] )
GO
CREATE INDEX [sm_MenuID_fk] ON [sm_MenuItem] ([MenuID] )
GO
CREATE INDEX [ContentID] ON [sm_MenuItem] ([ContentID] )
GO

CREATE TABLE [sm_Zone] (
[ZoneID] int NOT NULL,
[Name] varchar(255) NOT NULL DEFAULT '',
PRIMARY KEY ([ZoneID]) 
)
GO

ALTER TABLE [sm_LinkMenuContent] ADD CONSTRAINT [sm_LinkMenuContent_ibfk_2] FOREIGN KEY ([ZoneID]) REFERENCES ]sm_Zone] ([ZoneID]) ON DELETE CASCADE ON UPDATE CASCADE;
GO
ALTER TABLE [sm_LinkMenuContent] ADD CONSTRAINT [sm_LinkMenuContent_ibfk_1] FOREIGN KEY ([MenuID]) REFERENCES [sm_Menu] ([MenuID]) ON DELETE CASCADE ON UPDATE CASCADE;
GO
ALTER TABLE [sm_Menu] ADD CONSTRAINT [sm_Menu_ibfk_1] FOREIGN KEY ([ZoneID]) REFERENCES [sm_Zone] ([ZoneID]) ON DELETE CASCADE ON UPDATE CASCADE;
GO
ALTER TABLE [sm_MenuItem] ADD CONSTRAINT [sm_MenuItem_ibfk_3] FOREIGN KEY ([ContentID]) REFERENCES [cb_content] ([contentID]) ON DELETE CASCADE ON UPDATE CASCADE;
GO
ALTER TABLE [sm_MenuItem] ADD CONSTRAINT [sm_MenuItem_ibfk_1] FOREIGN KEY ([MenuID]) REFERENCES [sm_Menu] ([MenuID]) ON DELETE CASCADE ON UPDATE CASCADE;
GO
ALTER TABLE [sm_MenuItem] ADD CONSTRAINT [sm_MenuItem_ibfk_2] FOREIGN KEY ([ParentID]) REFERENCES [sm_MenuItem] ([MenuItemID]) ON DELETE CASCADE ON UPDATE CASCADE;
GO