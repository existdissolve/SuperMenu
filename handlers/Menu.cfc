/**
* A normal ColdBox Event Handler
*/
component extends="Base" {
	property name="SuperMenuService" inject="SuperMenuService@SuperMenu";
	property name="MenuService"		inject="entityService:Menu";
	property name="PageService"		inject="id:pageService@cb";
	property name="EntryService"	inject="id:EntryService@cb";
	property name="MenuItemService" inject="MenuItemService@SuperMenu";
	property name="ZoneService"		inject="entityService:Zone";
	
	this.prehandler_only = "index,edit";
	
	/**
    * Prehandler for index/edit events to setup links, common variables, etc.
    */
	public void function preHandler( required Any event, required Struct rc, required Struct prc ) {
		// if data isn't set up correctly, show trouble-shooting page
		if( !SuperMenuService.isDataSetup() ) {
			cb.setNextModuleEvent( "SuperMenu", "home.chooseInstallOption" );
		}
		else {
			// links and paths
			prc.xehCreateMenuLink = cb.buildModuleLink( "SuperMenu", "menu.index" );
    		prc.xehEditLink = cb.buildModuleLink("SuperMenu","menu.edit");
    		prc.xehDeleteLink = cb.buildModuleLink("SuperMenu","menu.delete");
    		prc.moduleRoot = getModuleSettings( "SuperMenu" ).mapping;
    		// show the black arrow in the modules menu bar?
    		prc.tabModules_SuperMenu = true;
    		// some lists and what-not
    		prc.editableMenus = MenuService.getAll();
    		prc.zones 		  = ZoneService.getAll();
    		prc.miniPagesMenu = SuperMenuService.buildOptionMenu( menu=PageService.findPublishedPages().pages, type="page" );
    		prc.miniBlogsMenu = SuperMenuService.buildOptionMenu( menu=EntryService.findPublishedEntries().entries, type="blog" );
		}
		super.preHandler( argumentCollection=arguments );
	}
	
	/**
    *  Main entry point for editing menus
    */
	public void function index( required Any event, required Struct rc, required Struct prc ) {
		// set the appropriate view
		event.setView( "menu/index" );
	}
	
	/**
    * Presents existing menu to be edited
    */
	public void function edit( required Any event, required Struct rc, required Struct prc ){	
		// get menu based on incoming rc parameter
		prc.menu = MenuService.get( rc.menu );
		// build out the editable menu content
		prc.menuContent = SuperMenuService.buildEditableMenu( prc.menu.getItems() );
		// set the appropriate view
		event.setView( "menu/index" );
	}
	
	/**
    * Deltes a menu
    */
	public void function delete( required Any event, required Struct rc, required Struct prc ) {
		// get the menu we want to delete
		var menu = SuperMenuService.get( rc.menu );
		// do the business
		SuperMenuService.delete( menu );	
		// Prepare confirmation message
		getPlugin( "MessageBox" ).info( "Menu was successfully deleted!" );
		// Relocate via CB Helper
		cb.setNextModuleEvent( "SuperMenu", "menu.index" );
	}
	
	/**
    * Creates a new menu, or updates an existing menu
    */
	public void function save( required Any event, required Struct rc, required Struct prc ){
		// check if this is a new menu or an existing one
		var isNewMenu = rc.supermenu_id=="" ? true : false;
		var successMessage = "";
		// get the menu; will be existing instance, or auto-created new instance
		var menu = MenuService.get( rc.supermenu_id );
		// get the zone to which the menu is attached (if any)
		var zone = rc.supermenu_zone != "" ? ZoneService.get( rc.supermenu_zone ) : JavaCast( "null", "" );
		// set up args for population
		var menuArgs = {
			Title=rc.supermenu_title,
			ListType=rc.supermenu_listtype,
			MenuClass=rc.supermenu_menuclass,
			Slug=rc.supermenu_slug
		};
		// populate the model
		MenuService.populate( target=menu, memento=menuArgs );
		// if zone is null, update value to null; otherwise, attach the zone instance to the menu
		menu.setZone( rc.supermenu_zone != "" ? ZoneService.get( rc.supermenu_zone ) : JavaCast( "null", "" ) );
		// save menu
		MenuService.save( entity=menu, flush=true );	
		// clear all existing menu items
		MenuItemService.deleteWhere( MenuID=menu );	
		// save current menuItems
		MenuItemService.saveMenuItems( Menu=menu, menuItems=deserializeJSON( rc.supermenu_content ) );
		// get correct message
		if( isNewMenu) {
			successMessage = "'<strong>#rc.supermenu_title#</strong>' was successfully created!";
		}
		// update menu setting
		else {
			successMessage = "'<strong>#rc.supermenu_title#</strong>' was successfully updated!";
		}
		// Messagebox
		getPlugin( "MessageBox" ).info( successMessage );
		// Relocate via CB Helper
		cb.setNextModuleEvent( "SuperMenu", "menu.index" );
	}
}