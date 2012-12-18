DROP TABLE IF EXISTS sm_LinkMenuContent;
DROP TABLE IF EXISTS sm_MenuItem;
DROP TABLE IF EXISTS sm_Menu;
DROP TABLE IF EXISTS sm_Zone;


CREATE TABLE PUBLIC.SM_LINKMENUCONTENT (
	LINKMENUCONTENTID INTEGER NOT NULL,
	CONTENTID INTEGER NOT NULL,
	MENUID INTEGER NOT NULL,
	ZONEID INTEGER,
	PRIMARY KEY (LINKMENUCONTENTID)
);

CREATE TABLE PUBLIC.SM_MENU (
	MENUID INTEGER NOT NULL,
	TITLE VARCHAR(255) NOT NULL,
	SLUG VARCHAR(255) NOT NULL,
	MENUCLASS VARCHAR(255),
	LISTTYPE VARCHAR(12),
	ZONEID INTEGER,
	PRIMARY KEY (MENUID)
);


CREATE TABLE PUBLIC.SM_MENUITEM (
	MENUITEMID INTEGER NOT NULL,
	MENUID INTEGER NOT NULL,
	LABEL VARCHAR(255) NOT NULL,
	TITLE VARCHAR(255),
	URL VARCHAR(255),
	PARENTID INTEGER,
	CONTENTID INTEGER,
	"Type" VARCHAR(255),
	PRIMARY KEY (MENUITEMID)
);


CREATE TABLE PUBLIC.SM_ZONE (
	ZONEID INTEGER NOT NULL,
	NAME VARCHAR(255) NOT NULL,
	PRIMARY KEY (ZONEID)
);

ALTER TABLE PUBLIC.SM_MENUITEM
	ADD FOREIGN KEY (CONTENTID) 
	REFERENCES CB_CONTENT (CONTENTID) ON DELETE CASCADE;

ALTER TABLE PUBLIC.SM_MENUITEM
	ADD FOREIGN KEY (MENUID) 
	REFERENCES SM_MENU (MENUID) ON DELETE CASCADE;

ALTER TABLE PUBLIC.SM_MENUITEM
	ADD FOREIGN KEY (PARENTID) 
	REFERENCES SM_MENUITEM (MENUITEMID) ON DELETE CASCADE;





ALTER TABLE PUBLIC.SM_LINKMENUCONTENT
	ADD FOREIGN KEY (CONTENTID) 
	REFERENCES CB_CONTENT (CONTENTID) ON DELETE CASCADE;

ALTER TABLE PUBLIC.SM_LINKMENUCONTENT
	ADD FOREIGN KEY (MENUID) 
	REFERENCES SM_MENU (MENUID) ON DELETE CASCADE;

ALTER TABLE PUBLIC.SM_LINKMENUCONTENT
	ADD FOREIGN KEY (ZONEID) 
	REFERENCES SM_ZONE (ZONEID) ON DELETE CASCADE;




ALTER TABLE PUBLIC.SM_MENU
	ADD FOREIGN KEY (ZONEID) 
	REFERENCES SM_ZONE (ZONEID) ON DELETE CASCADE;