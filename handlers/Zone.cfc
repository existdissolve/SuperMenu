/**
* A normal ColdBox Event Handler
*/
component{
	property name="cb" inject="cbHelper@cb";
	property name="SuperMenuService" inject="SuperMenuService@SuperMenu";
	property name="ORMService" inject="coldbox:plugin:ORMService";
	
	this.prehandler_only = "index,edit";
	
	function preHandler( event, rc, prc ) {
		if( !SuperMenuService.isDataSetup() ) {
			cb.setNextModuleEvent( "SuperMenu", "home.chooseInstallOption" );
		}
		else {
			prc.xehEditLink = cb.buildModuleLink( "SuperMenu", "zone.edit" );
        	prc.xehDeleteLink = cb.buildModuleLink( "SuperMenu", "zone.delete" );
    		prc.xehCreateLink = cb.buildModuleLink( "SuperMenu", "zone.index" );
    		prc.moduleRoot = getModuleSettings( "SuperMenu" ).mapping;
    		prc.editableZones = ORMService.getAll( "Zone" );
    		prc.tabModules_SuperMenu = true;
		}
	}
	function index( event, rc, prc ) {
		event.setView( "zone/index" );
	}
	function edit( event, rc, prc ) {
		prc.zone = ORMService.get( "Zone", rc.zone );
		event.setView( "zone/index" );
	}
	function save( event, rc, prc ) {
		var isNewZone = rc.zoneID=="" ? true : false;
		var successMessage = "";
		var zone = ORMService.get( "Zone", rc.zoneID );
		zone.setName( rc.name );
		ORMService.save( zone );
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
	function delete( event, rc, prc ) {
		var zone = ORMService.get( "Zone", rc.zoneID );
		var successMessage = "'<strong>#rc.name#</strong>' was successfully deleted!";
		var relatedMenus = SuperMenuService.findAllWhere( criteria={
			Zone=zone
		});
		for( var menu in relatedMenus ) {
			menu.setZone( JavaCast( "null", "" ) );
			SuperMenuService.save( menu );
		}
		ORMService.delete( zone );
		// Messagebox
		getPlugin( "MessageBox" ).info( successMessage );
		// Relocate via CB Helper
		cb.setNextModuleEvent( "SuperMenu", "zone.index" );
	}
}