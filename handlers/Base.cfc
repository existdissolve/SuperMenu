component {
	property name="cb" inject="cbHelper@cb";
	property name="SuperMenuService" inject="SuperMenuService@SuperMenu";
	
	this.prehandler_except = "chooseInstallOption,install";

	/**
    * Prehandler to setup links, common variables, etc.
    */
	public void function preHandler( required Any event, required Struct rc, required Struct prc ) {
		// get module root
		prc.moduleRoot = getModuleSettings( "SuperMenu" ).mapping;
		// show black arrow under link in menu?
		prc.tabModules_SuperMenu = true;
		// if data isn't setup, redirect user
		if( !SuperMenuService.isDataSetup() ) {
			cb.setNextModuleEvent( "SuperMenu", "home.chooseInstallOption" );
		}
	}
}