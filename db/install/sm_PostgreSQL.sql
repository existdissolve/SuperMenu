DROP TABLE IF EXISTS sm_LinkMenuContent,sm_MenuItem,sm_Menu,sm_Zone;

CREATE TABLE "sm_LinkMenuContent" (
"LinkMenuContentID" int4 NOT NULL,
"ContentID" int4 NOT NULL,
"MenuID" int4 NOT NULL,
"ZoneID" int4 DEFAULT NULL,
PRIMARY KEY ("LinkMenuContentID") 
);

CREATE INDEX "MenuID" ON "sm_LinkMenuContent" ("MenuID");
CREATE INDEX "ZoneID" ON "sm_LinkMenuContent" ("ZoneID");
CREATE INDEX "ContentID" ON "sm_LinkMenuContent" ("ContentID");

CREATE TABLE "sm_Menu" (
"MenuID" int4 NOT NULL,
"Title" varchar(255) NOT NULL DEFAULT '',
"Slug" varchar(255) NOT NULL,
"MenuClass" varchar(255) DEFAULT '',
"ListType" varchar(12) DEFAULT 'ul',
"ZoneID" int4 DEFAULT NULL,
PRIMARY KEY ("MenuID") 
);

CREATE INDEX "fk_sm_Menu_Zone" ON "sm_Menu" ("ZoneID");

CREATE TABLE "sm_MenuItem" (
"MenuItemID" int4 NOT NULL,
"MenuID" int4 NOT NULL,
"Label" varchar(255) NOT NULL,
"Title" varchar(255) DEFAULT NULL,
"URL" varchar(255) DEFAULT '',
"ParentID" int4 DEFAULT NULL,
"ContentID" int4 DEFAULT NULL,
"Type" varchar(255) NOT NULL DEFAULT '',
PRIMARY KEY ("MenuItemID") 
);

CREATE INDEX "ParentID" ON "sm_MenuItem" ("ParentID");
CREATE INDEX "sm_MenuID_fk" ON "sm_MenuItem" ("MenuID");
CREATE INDEX "ContentID" ON "sm_MenuItem" ("ContentID");

CREATE TABLE "sm_Zone" (
"ZoneID" int4 NOT NULL,
"Name" varchar(255) NOT NULL DEFAULT '',
PRIMARY KEY ("ZoneID") 
);

ALTER TABLE "sm_LinkMenuContent" ADD CONSTRAINT "sm_LinkMenuContent_ibfk_2" FOREIGN KEY ("ZoneID") REFERENCES "sm_Zone" ("ZoneID") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sm_LinkMenuContent" ADD CONSTRAINT "sm_LinkMenuContent_ibfk_1" FOREIGN KEY ("MenuID") REFERENCES "sm_Menu" ("MenuID") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sm_Menu" ADD CONSTRAINT "sm_Menu_ibfk_1" FOREIGN KEY ("ZoneID") REFERENCES "sm_Zone" ("ZoneID") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sm_MenuItem" ADD CONSTRAINT "sm_MenuItem_ibfk_3" FOREIGN KEY ("ContentID") REFERENCES "cb_content" ("contentID") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sm_MenuItem" ADD CONSTRAINT "sm_MenuItem_ibfk_1" FOREIGN KEY ("MenuID") REFERENCES "sm_Menu" ("MenuID") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "sm_MenuItem" ADD CONSTRAINT "sm_MenuItem_ibfk_2" FOREIGN KEY ("ParentID") REFERENCES "sm_MenuItem" ("MenuItemID") ON DELETE CASCADE ON UPDATE CASCADE;