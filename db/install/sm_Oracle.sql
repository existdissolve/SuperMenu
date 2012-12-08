ALTER TABLE "sm_MenuItem" DROP CONSTRAINT "fk_sm_MenuItem";
ALTER TABLE "sm_LinkMenuPage" DROP CONSTRAINT "fk_sm_LinkMenuPage";
ALTER TABLE "sm_LinkMenuLayout" DROP CONSTRAINT "fk_sm_LinkMenuLayout";

ALTER TABLE "sm_Menu"DROP CONSTRAINT "";
ALTER TABLE "sm_MenuItem"DROP CONSTRAINT "";

DROP TABLE "sm_Menu";
DROP TABLE "sm_MenuItem";
DROP TABLE "sm_LinkMenuPage";
DROP TABLE "sm_LinkMenuLayout";

CREATE TABLE "sm_Menu" (
"MenuID" NUMBER(11) NOT NULL,
"Slug" VARCHAR2(255) NOT NULL,
"Orientation" VARCHAR2(12) NOT NULL,
PRIMARY KEY ("MenuID") 
);

CREATE TABLE "sm_MenuItem" (
"MenuItemID" NUMBER(11) NOT NULL,
"MenuID" NUMBER(11) NOT NULL,
"Label" VARCHAR2(255) NOT NULL,
"Title" VARCHAR2(255) NULL,
"Slug" VARCHAR2(255) NOT NULL,
PRIMARY KEY ("MenuItemID") 
);

CREATE TABLE "sm_LinkMenuPage" (
"ContentID" NUMBER(11) NOT NULL,
"MenuID" NUMBER(11) NOT NULL
);

CREATE TABLE "sm_LinkMenuLayout" (
"Layout" VARCHAR2(255) NOT NULL,
"MenuID" NUMBER(11) NOT NULL
);


ALTER TABLE "sm_MenuItem" ADD CONSTRAINT "fk_sm_MenuItem" FOREIGN KEY ("MenuID") REFERENCES "sm_Menu" ("MenuID");
ALTER TABLE "sm_LinkMenuPage" ADD CONSTRAINT "fk_sm_LinkMenuPage" FOREIGN KEY ("MenuID") REFERENCES "sm_Menu" ("MenuID");
ALTER TABLE "sm_LinkMenuLayout" ADD CONSTRAINT "fk_sm_LinkMenuLayout" FOREIGN KEY ("MenuID") REFERENCES "sm_Menu" ("MenuID");

