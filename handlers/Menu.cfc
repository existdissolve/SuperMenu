/**
* A normal ColdBox Event Handler
*/
component{
	property name="SettingService" 	inject="SettingService@cb";
	property name="SuperMenuService" inject="SuperMenuService@SuperMenu";
	property name="cb" 				inject="cbHelper@cb";
	property name="PageService"		inject="id:pageService@cb";
	property name="EntryService"	inject="id:EntryService@cb";
	property name="CategoryService"	inject="id:CategoryService@cb";
	property name="MenuItemService" inject="MenuItemService@SuperMenu";
	property name="ORMService" inject="coldbox:plugin:ORMService";
	
	this.prehandler_only = "index,edit";
	
	function preHandler( event, rc, prc ) {
		if( !SuperMenuService.isDataSetup() ) {
			cb.setNextModuleEvent( "SuperMenu", "home.chooseInstallOption" );
		}
		else {
			prc.xehCreateMenuLink = cb.buildModuleLink( "SuperMenu", "menu.index" );
    		prc.xehEditLink = cb.buildModuleLink("SuperMenu","menu.edit");
    		prc.xehDeleteLink = cb.buildModuleLink("SuperMenu","menu.delete");
    		prc.moduleRoot = getModuleSettings( "SuperMenu" ).mapping;
    		prc.editableMenus = [];
    		//prc.pages = PageService.findPublishedPages();
    		//prc.blogs = EntryService.findPublishedEntries();
    		prc.editableMenus = SuperMenuService.getAll();
    		prc.zones = ORMService.getAll( entityName="Zone" );
    		prc.tabModules_SuperMenu = true;
    		prc.miniPagesMenu = SuperMenuService.buildOptionMenu( menu=PageService.findPublishedPages().pages, type="page" );
    		prc.miniBlogsMenu = SuperMenuService.buildOptionMenu( menu=EntryService.findPublishedEntries().entries, type="blog" );
		}
	}
	function index( event, rc, prc ) {
		event.setView( "menu/index" );
	}
	function edit(event,rc,prc){	
		prc.menu = SuperMenuService.get( rc.menu );
		event.setView( "menu/index" );
	}
	function delete( event, rc, prc ) {
		var menu = SuperMenuService.get( rc.menu );
		SuperMenuService.delete( menu );	
		// Messagebox
		getPlugin( "MessageBox" ).info( "Menu was successfully deleted!" );
		// Relocate via CB Helper
		cb.setNextModuleEvent( "SuperMenu", "menu.index" );
	}
	function save( event, rc, prc ){
		// Get super menu settings
		//prc.settings = getModuleSettings( "SuperMenu" ).settings;
		var isNewMenu = rc.supermenu_id=="" ? true : false;
		var successMessage = "";
		var menu = SuperMenuService.get( rc.supermenu_id );
		var zone = rc.supermenu_zone != "" ? ORMService.get( "Zone", rc.supermenu_zone ) : JavaCast( "null", "" );
		var menuArgs = {
			"title"=rc.supermenu_title,
			"orientation"=rc.supermenu_orientation,
			"slug"=rc.supermenu_slug
		};
		SuperMenuService.populate( target=menu, memento=menuArgs );
		menu.setZone( rc.supermenu_zone != "" ? ORMService.get( "Zone", rc.supermenu_zone ) : JavaCast( "null", "" ) );
		// save menu
		SuperMenuService.save( entity=menu, flush=true );	
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