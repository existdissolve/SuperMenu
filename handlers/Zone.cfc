/**
* A normal ColdBox Event Handler
*/
component extends="Base" {
	
	this.prehandler_only = "index,edit";
	
	/**
    * Prehandler for index/edit events to setup links, common variables, etc.
    */
	public void function preHandler( required Any event, required Struct rc, required Struct prc ) {
		super.preHandler( argumentCollection=arguments );
		// links
		prc.xehEditLink = cb.buildModuleLink( "SuperMenu", "zone.edit" );
    	prc.xehDeleteLink = cb.buildModuleLink( "SuperMenu", "zone.delete" );
		prc.xehCreateLink = cb.buildModuleLink( "SuperMenu", "zone.index" );
		// get all zones
		prc.editableZones = SuperMenuService.getZoneService().getAll();
	}
	
	/**
    * main entry point
    */
	public void function index( required Any event, required Struct rc, required Struct prc ) {
		// set appropriate view
		event.setView( view="zone/index" );
	}
	
	/**
    * display editable form
    */
	public void function edit( required Any event, required Struct rc, required Struct prc ) {
		// get zone to edit
		prc.zone = SuperMenuService.getZoneService().get( rc.zone );
		// set appropriate view
		event.setView( "zone/index" );
	}
	
	/**
    * create zone, or update existing one
    */
	public void function save( required Any event, required Struct rc, required Struct prc ) {
		// flag for new or existing zone
		var isNewZone = rc.zoneID=="" ? true : false;
		var successMessage = "";
		// get the zone; will return new if id is null
		var zone = SuperMenuService.getZoneService().get( rc.zoneID );
			zone.setName( rc.name );
		// do the business
		SuperMenuService.getZoneService().save( zone );
		// new zone message
		if( isNewZone ) {
			successMessage = "'<strong>#rc.name#</strong>' was successfully created!";
		}
		// update zone message
		else {
			successMessage = "'<strong>#rc.name#</strong>' was successfully updated!";
		}
		// Messagebox
		getPlugin( "MessageBox" ).info( successMessage );
		// Relocate via CB Helper
		cb.setNextModuleEvent( "SuperMenu", "zone.index" );
	}
	
	/**
    * delete zone
    */
	public void function delete( required Any event, required Struct rc, required Struct prc ) {
		// get the zone
		var zone = SuperMenuService.getZoneService().get( rc.zoneID );
		var successMessage = "'<strong>#rc.name#</strong>' was successfully deleted!";
		// get any menus that are related to this zone
		var relatedMenus = SuperMenuService.getMenuService().findAllWhere( criteria={
			Zone=zone
		});
		// loop over related menus, and remove reference to zone
		for( var menu in relatedMenus ) {
			menu.setZone( JavaCast( "null", "" ) );
			SuperMenuService.getMenuService().save( menu );
		}
		// do the business
		SuperMenuService.getZoneService().delete( zone );
		// Messagebox
		getPlugin( "MessageBox" ).info( successMessage );
		// Relocate via CB Helper
		cb.setNextModuleEvent( "SuperMenu", "zone.index" );
	}
}