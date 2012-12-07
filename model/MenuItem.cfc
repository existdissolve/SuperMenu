component persistent="true" table="sm_MenuItem" cachename="smMenuItem" cacheuse="read-write" {

	// Properties
	property name="MenuItemID" fieldtype="id" generator="native";
	property name="Title" column="Title" notnull="true" ormtype="string" default="Me";
	property name="URL" column="URL" ormtype="string" default="Me";
	property name="Label" column="Label" ormtype="string" default="Me";
	property name="Type" column="Type" ormtype="string" default="page";

	property name="MenuID" fieldtype="many-to-one" cfc="Menu" fkcolumn="MenuID";
	property name="ParentID" column="ParentID" fieldtype="many-to-one" cfc="MenuItem";
	property name="ContentID" column="ContentID" fieldtype="many-to-one" cfc="contentbox.model.content.BaseContent" fkcolumn="ContentID";
	property name="Children" fieldtype="one-to-many" cfc="MenuItem" fkcolumn="ParentID" lazy="false" fetch="join";
	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	MenuItem function init(){
		return this;
	}

	/************************************** PUBLIC *********************************************/
}