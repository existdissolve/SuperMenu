/**
* A normal ColdBox Event Handler
*/
component{
	property name="cb" inject="cbHelper@cb";
	function preHandler( event, rc, prc ) {
		prc.moduleRoot = getModuleSettings( "SuperMenu" ).mapping;
		prc.tabModules_SuperMenu = true;
	}

	function index( event, rc, prc ) {
		event.setView( "home/index" );
	}
	
	function chooseInstallOption( event, rc, prc ) {
		prc.moduleRoot = getModuleSettings( "SuperMenu" ).mapping;
		getPlugin( "MessageBox" ).warn( "Database is not configured correctly for SuperMenu!" );
		event.setView( "home/install" );
	}
	public boolean function install( event, rc, prc ) {
		prc.moduleRoot = getModuleSettings( "SuperMenu" ).mapping;
		
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
        		// update entities
        		activateORMEntities();
				break;
		}
		cb.setNextModuleEvent( "SuperMenu", "menu" );
	}
	
	private void function runSQLScript() {
		var orm = new coldbox.system.orm.hibernate.util.ORMUtilFactory().getORMUtil();
		var dsn = orm.getDefaultDatasource();
		var db = new dbinfo( datasource=dsn ).version();
		var sql = "";
		switch( db.DATABASE_PRODUCTNAME ) {
			case "MySQL":
				sql = fileRead( getModuleSettings( "SuperMenu" ).path & "/db/install/sm_MySQL.sql" );
				break;
			case "SQL Server":
				
				break;
			case "Oracle":
				
				break;
			case "PostgreSQL":
			
				break;
		}
		if( sql != "" ) {
			var qs = new query();
				qs.setDataSource( dsn );
				qs.setSql( trim( sql ) );
				qs.execute();
		}
	}
	private void function activateORMEntities() {
		var entityPath = getModuleSettings( "SuperMenu" ).modelsPhysicalPath & "/Menu.cfc";
		var c = fileRead( entityPath );
		c = replacenocase( c, 'component ','component persistent="true" ', "one" );
		fileWrite( entityPath, c );
		ormReload();
	}
}