component table="sm_Zone" {

	// Properties
	property name="ZoneID" fieldtype="id" generator="native";
	property name="Name" column="Name" ormtype="string";
	/************************************** CONSTRUCTOR *********************************************/

	/**
	* constructor
	*/
	Zone function init(){
		return this;
	}

	/************************************** PUBLIC *********************************************/
}