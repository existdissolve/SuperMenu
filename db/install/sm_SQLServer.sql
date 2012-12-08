ALTER TABLE [sm_MenuItem] DROP CONSTRAINT [fk_sm_MenuItem]
GO
ALTER TABLE [sm_LinkMenuPage] DROP CONSTRAINT [fk_sm_LinkMenuPage]
GO
ALTER TABLE [sm_LinkMenuLayout] DROP CONSTRAINT [fk_sm_LinkMenuLayout]
GO

ALTER TABLE [sm_Menu]DROP CONSTRAINT []
GO
ALTER TABLE [sm_MenuItem]DROP CONSTRAINT []
GO

DROP TABLE [sm_Menu]
GO
DROP TABLE [sm_MenuItem]
GO
DROP TABLE [sm_LinkMenuPage]
GO
DROP TABLE [sm_LinkMenuLayout]
GO

CREATE TABLE [sm_Menu] (
[MenuID] int NOT NULL,
[Slug] varchar(255) NOT NULL,
[Orientation] varchar(12) NOT NULL,
PRIMARY KEY ([MenuID]) 
)
GO

CREATE TABLE [sm_MenuItem] (
[MenuItemID] int NOT NULL,
[MenuID] int NOT NULL,
[Label] varchar(255) NOT NULL,
[Title] varchar(255) NULL,
[Slug] varchar(255) NOT NULL,
PRIMARY KEY ([MenuItemID]) 
)
GO

CREATE TABLE [sm_LinkMenuPage] (
[ContentID] int NOT NULL,
[MenuID] int NOT NULL
)
GO

CREATE TABLE [sm_LinkMenuLayout] (
[Layout] varchar(255) NOT NULL,
[MenuID] int NOT NULL
)
GO


ALTER TABLE [sm_MenuItem] ADD CONSTRAINT [fk_sm_MenuItem] FOREIGN KEY ([MenuID]) REFERENCES [sm_Menu] ([MenuID])
GO
ALTER TABLE [sm_LinkMenuPage] ADD CONSTRAINT [fk_sm_LinkMenuPage] FOREIGN KEY ([MenuID]) REFERENCES [sm_Menu] ([MenuID])
GO
ALTER TABLE [sm_LinkMenuLayout] ADD CONSTRAINT [fk_sm_LinkMenuLayout] FOREIGN KEY ([MenuID]) REFERENCES [sm_Menu] ([MenuID])
GO

