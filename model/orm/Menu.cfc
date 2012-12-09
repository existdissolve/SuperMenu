component persistent="true" table="sm_Menu" cachename="smMenu" cacheuse="read-write" {

	// Non-relational Properties
	property name="MenuID" column="MenuID" fieldtype="id" generator="native" setter="false";
	property name="Title" column="Title" notnull="true" ormtype="string";
	property name="Slug" column="Slug" notnull="true" ormtype="string";
	property name="MenuClass" column="MenuClass" ormtype="string";
	property name="ListType" column="ListType" ormtype="string";
	// many-to-one
	property name="Zone" fieldtype="many-to-one" cfc="Zone" fkcolumn="ZoneID";
	// one-to-many
	property name="Items" fieldtype="one-to-many" cfc="MenuItem" fkcolumn="MenuID" cascade="all-delete-orphan" inverse="true";
	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	Menu function init(){
		return this;
	}

	/************************************** PUBLIC *********************************************/
}