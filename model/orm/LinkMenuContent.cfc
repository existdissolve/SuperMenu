component table="sm_LinkMenuContent" {

	// Properties
	property name="LinkMenuContentID" fieldtype="id" generator="native";
	property name="MenuID" fieldtype="many-to-one" cfc="Menu" fkcolumn="MenuID";
	property name="ContentID" fieldtype="many-to-one" cfc="contentbox.model.content.BaseContent" fkcolumn="ContentID" lazy=false;
	property name="ZoneID" fieldtype="many-to-one" cfc="Zone" fkcolumn="ZoneID";
	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	LinkMenuContent function init(){
		return this;
	}

	/************************************** PUBLIC *********************************************/
}