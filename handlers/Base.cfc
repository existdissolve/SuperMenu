component {
	property name="cb" inject="cbHelper@cb";
	property name="SuperMenuService" inject="SuperMenuService@SuperMenu";

	/**
    * Prehandler to setup links, common variables, etc.
    */
	public void function preHandler( required Any event, required Struct rc, required Struct prc ) {
		// if data isn't setup, redirect user
		if( !SuperMenuService.isDataSetup() ) {
			cb.setNextModuleEvent( "SuperMenu", "home.chooseInstallOption" );
		}
		// get module root
		prc.moduleRoot = getModuleSettings( "SuperMenu" ).mapping;
		// show black arrow under link in menu?
		prc.tabModules_SuperMenu = true;
	}
}