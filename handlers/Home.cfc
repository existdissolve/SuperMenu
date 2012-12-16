/**
* A normal ColdBox Event Handler
*/
component extends="Base" {
	property name="ORMService" inject="coldbox:plugin:ORMService";

	/**
    * default entry point
    */
	public void function index( required Any event, required Struct rc, required Struct prc ) {
		// set appropriate view
		event.setView( "home/index" );
	}
	
	/**
    * sets view and warning message for users when database is not properly configured
    */
	public void function chooseInstallOption( required Any event, required Struct rc, required Struct prc ) {
		// get module root
		prc.moduleRoot = getModuleSettings( "SuperMenu" ).mapping;
		// show black arrow under link in menu?
		prc.tabModules_SuperMenu = true;
		// set warning message
		getPlugin( "MessageBox" ).warn( "Database is not configured correctly for SuperMenu!" );
		// set appropriate view
		event.setView( "home/install" );
	}
	
	/**
    * rewrites ORM entities to be persiste, and optionally runs SQL scripts
    */
	public void function install( required Any event, required Struct rc, required Struct prc ) {	
		// switch on install type	
		switch( rc.installtype ) {
			// only need to update entity files to be persistent
			case "partial":
				// update entities
				SuperMenuService.activateORMEntities();
				break;
			// need to create tables AND update entity files to be persistent
			case "auto":
        		// run db script
        		SuperMenuService.runSQLScript();
        		//update entities
        		SuperMenuService.activateORMEntities();
				break;
		}
		// reload ORM to process new persistent entities
		ormReload();
		// update service references in SuperMenuService
		SuperMenuService.setupORMServices( true );
		// installation successful; redirect to menu management
		cb.setNextModuleEvent( "SuperMenu", "menu" );
	}
}