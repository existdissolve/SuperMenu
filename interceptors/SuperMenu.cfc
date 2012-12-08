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
	public void function cbadmin_pageEditorSidebarAccordion( required Any event ) {
		appendToAccordion( argumentCollection=arguments );
	}
	/**
	* Add content entry editor side-bar
	*/
	public void function cbadmin_entryEditorSidebarAccordion( required Any event ) {
		appendToAccordion( argumentCollection=arguments );
	}
	
	/**
	* Make any additions/update/deletions to page links based on changes in page state
	*/
	public Any function cbadmin_postPageSave( required Any event, required struct interceptData ) {
		var collection = event.getCollection();
		manageContentMenuLinks( collection=collection, content=arguments.interceptData.page );
	}
	
	/**
	* Make any additions/update/deletions to entry links based on changes in entry state
	*/
	public Any function cbadmin_postEntrySave( required Any event, required struct interceptData ) {
		var collection = event.getCollection();
		manageContentMenuLinks( collection=collection, content=arguments.interceptData.entry );
	}
	
	/**
	* Make any additions/update/deletions to page links based on changes in entry state
	*/
	public Any function cbadmin_prePageRemove( required Any event, required struct interceptData ) {
		var collection = event.getCollection();
		manageContentMenuLinks( collection=collection, content=arguments.interceptData.page );
	}
	
	/**
	* Make any additions/update/deletions to entry links based on changes in entry state
	*/
	public Any function cbadmin_preEntryRemove( required Any event, required struct interceptData ) {
		var collection = event.getCollection();
		manageContentMenuLinks( collection=collection, content=arguments.interceptData.entry );
	}
	
	private void function manageContentMenuLinks( required Struct collection, required Any content ) {
    	var zones = ZoneService.getAll( entityName="Zone" );
		for( var zone in zones ) {
    		// if a menu was selected...
    		if( structKeyExists( arguments.collection, "supermenu_#zone.getZoneID()#" ) && arguments.collection[ "supermenu_#zone.getZoneID()#" ] != "" ) {
    			// look up existing item
    			var menuLink = LinkMenuContentService.findWhere( criteria={
    				ContentID = arguments.content,
    				ZoneID = zone
    			});
    			// if it doesn't exist, create it
    			if( isNull( menuLink ) ) {
    				menuLink = LinkMenuContentService.new( properties={
    					ContentID = arguments.content
    				});
    			}
    			// set the menu link
    			menuLink.setMenuID( MenuService.get( arguments.collection[ "supermenu_#zone.getZoneID()#" ] ) );
    			menuLink.setZoneID( zone );
    			// save 
    			LinkMenuContentService.save( entity=menuLink );
    		}
    		// otherwise, delete any existing links for this page
    		else {
    			LinkMenuContentService.deleteWhere( ContentID = arguments.content, ZoneID=zone );
    		}	
		}	
    }
	
	private void function appendToAccordion( required Any event ) {
		var rc = event.getCollection();
		var menus = MenuService.getAll();
		var zones = ZoneService.getAll();
		var existing = [];
		
		if( structKeyExists( rc, "contentID" ) ) {
    		// get existing zone relationships for the current page
    		var existing = LinkMenuContentService.findAllWhere( criteria={
    			ContentID = ContentService.get( rc.contentID )
    		});	
		}
		// add menuselect view to the sidebar
		appendToBuffer( renderView( view='menu/menuselect', module="SuperMenu", args={ 
			menus=menus,
			existing=existing,
			zones=zones 
		}) );
	}
}