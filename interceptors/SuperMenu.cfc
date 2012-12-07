component extends="coldbox.system.Interceptor"{

	// DI
	property name="SuperMenuService" inject="SuperMenuService@SuperMenu";
	property name="ORMService" inject="coldbox:plugin:ORMService";
	/**
	* Compress layouts+views upon rendering.
	*/
	function cbadmin_pageEditorSidebarAccordion( required Any event ) {
		var rc = event.getCollection();
		var menus = SuperMenuService.getAll();
		var zones = ORMService.getAll( entityName="Zone" );
		var existing = ORMService.findAllWhere( entityName="LinkMenuContent", criteria={
			ContentID = ORMService.get( "cbContent", rc.contentID )
		});
		appendToBuffer( renderView( view='menu/menuselect', module="SuperMenu", args={ 
			menus=menus,
			existing=existing,
			zones=zones 
		}) );
	}
	
	function cbadmin_postPageSave( required Any event, required struct interceptData ) {
		var rc = event.getCollection();
		var zones = ORMService.getAll( entityName="Zone" );
		for( var zone in zones ) {
    		// if a menu was selected...
    		if( structKeyExists( rc, "supermenu_#zone.getZoneID()#" ) && rc[ "supermenu_#zone.getZoneID()#" ] != "" ) {
    			// look up existing item
    			var menuLink = ORMService.findWhere( entityName='LinkMenuContent', criteria={
    				ContentID = ORMService.get( "cbContent", rc.contentID ),
    				ZoneID = zone
    			});
    			// if it doesn't exist, create it
    			if( isNull( menuLink ) ) {
    				menuLink = ORMService.new( entityName="LinkMenuContent", properties={
    					ContentID = ORMService.get( "cbContent", rc.contentID )
    				});
    			}
    			// set the menu link
    			menuLink.setMenuID( ORMService.get( "Menu", rc[ "supermenu_#zone.getZoneID()#" ] ) );
    			menuLink.setZoneID( zone );
    			// save 
    			ORMService.save( entity=menuLink );
    		}
    		// otherwise, delete any existing links for this page
    		else {
    			ORMService.deleteWhere( entityName='LinkMenuContent', ContentID = ORMService.get( "cbContent", rc.contentID ), ZoneID=zone );
    		}	
		}
	}
}