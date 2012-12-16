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
				activateORMEntities();
				break;
			// need to create tables AND update entity files to be persistent
			case "auto":
        		// run db script
        		runSQLScript();
        		//update entities
        		activateORMEntities();
				break;
		}
		// reload ORM to process new persistent entities
		ormReload();
		// update service references in SuperMenuService
		SuperMenuService.setupORMServices( true );
		// installation successful; redirect to menu management
		cb.setNextModuleEvent( "SuperMenu", "menu" );
	}
	
	/**
    * runs a static SQL script (based on configured database type) to install needed tables
    */	
	private void function runSQLScript() {
		// get orm utils
		var orm = new coldbox.system.orm.hibernate.util.ORMUtilFactory().getORMUtil();
		// figure out the default datasource
		var dsn = orm.getDefaultDatasource();
		// use dbinfo to lookup db version
		var db = new dbinfo( datasource=dsn ).version();
		var sql = "";
		// switch on db version
		switch( db.DATABASE_PRODUCTNAME ) {
			case "MySQL":
				sql = fileRead( getModuleSettings( "SuperMenu" ).path & "/db/install/sm_MySQL.sql" );
				break;
			case "Microsoft SQL Server":
				sql = fileRead( getModuleSettings( "SuperMenu" ).path & "/db/install/sm_SQLServer.sql" );
				break;
			case "Oracle":
				sql = fileRead( getModuleSettings( "SuperMenu" ).path & "/db/install/sm_Oracle.sql" );
				break;
			case "PostgreSQL":
				sql = fileRead( getModuleSettings( "SuperMenu" ).path & "/db/install/sm_PostgreSQL.sql" );
				break;
		}
		// run the sql script
		if( sql != "" ) {
			if( db.DATABASE_PRODUCTNAME=="MySQL" ) {
				for( var i=1; i<=listLen( sql, ";" ); i++ ) {
					var statement = listGetAt( sql, i, ";" );
					var qs = new query();
    				qs.setDataSource( dsn );
    				qs.setSql( statement );
    				qs.execute();
				}
			}
			else {
				var qs = new query();
				qs.setDataSource( dsn );
				qs.setSql( sql );
				qs.execute();
			}
		}
	}
	
	/**
    * updates model files to be persistent; need to do this AFTER verificatin of the database to keep CF from exploding
    */
	private void function activateORMEntities() {
		var entityPaths = [ "Menu.cfc", "MenuItem.cfc", "Zone.cfc", "LinkMenuContent.cfc" ];
		var modelPath = getModuleSettings( "SuperMenu" ).modelsPhysicalPath;
		for( var path in entityPaths ) {
    		// get entity paths
    		var entityPath = modelPath & "/orm/#path#";
    		// read the file contents
    		var c = fileRead( entityPath );
    		// add "persistent=true"
    		c = replacenocase( c, 'component ','component persistent="true" ', "one" );
    		// overwrite with updates
    		fileWrite( entityPath, c );	
		}
	}
}