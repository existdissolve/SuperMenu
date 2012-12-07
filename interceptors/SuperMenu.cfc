component extends="coldbox.system.Interceptor"{

	// DI
	property name="SuperMenuService" inject="SuperMenuService@SuperMenu";
	property name="MenuService" inject="entityService:Menu";
	property name="ZoneService" inject="entityService:Zone";
	property name="LinkMenuContentService" inject="entityService:LinkMenuContent";
	property name="ContentService" inject="entityService:cbContent";

	/**
	* Add content page editor side-bar
	*/
	public Any function cbadmin_pageEditorSidebarAccordion( required Any event ) {
		var rc = event.getCollection();
		var menus = MenuService.getAll();
		var zones = ZoneService.getAll();
		// get existing zone relationships for the current page
		var existing = LinkMenuContentService.findAllWhere( criteria={
			ContentID = ContentService.get( rc.contentID )
		});
		// add menuselect view to the sidebar
		appendToBuffer( renderView( view='menu/menuselect', module="SuperMenu", args={ 
			menus=menus,
			existing=existing,
			zones=zones 
		}) );
	}
	
	/**
	* Make any additions/update/deletions to page links based on changes in page state
	*/
	public Any function cbadmin_postPageSave( required Any event, required struct interceptData ) {
		var rc = event.getCollection();
		var zones = ZoneService.getAll( entityName="Zone" );
		for( var zone in zones ) {
    		// if a menu was selected...
    		if( structKeyExists( rc, "supermenu_#zone.getZoneID()#" ) && rc[ "supermenu_#zone.getZoneID()#" ] != "" ) {
    			// look up existing item
    			var menuLink = LinkMenuContentService.findWhere( criteria={
    				ContentID = ContentService.get( "cbContent", rc.contentID ),
    				ZoneID = zone
    			});
    			// if it doesn't exist, create it
    			if( isNull( menuLink ) ) {
    				menuLink = LinkMenuContentService.new( properties={
    					ContentID = ContentService.get( rc.contentID )
    				});
    			}
    			// set the menu link
    			menuLink.setMenuID( MenuService.get( rc[ "supermenu_#zone.getZoneID()#" ] ) );
    			menuLink.setZoneID( zone );
    			// save 
    			LinkMenuContentService.save( entity=menuLink );
    		}
    		// otherwise, delete any existing links for this page
    		else {
    			LinkMenuContentService.deleteWhere( ContentID = ContentService.get( rc.contentID ), ZoneID=zone );
    		}	
		}
	}
}