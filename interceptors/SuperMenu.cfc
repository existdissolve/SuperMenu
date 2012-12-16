component extends="coldbox.system.Interceptor"{

	// DI
	property name="SuperMenuService" inject="SuperMenuService@SuperMenu";
	
	public void function preHandler( required Any event, required Struct rc, required Struct prc ) {
		// if data isn't setup, redirect user
		if( !SuperMenuService.isDataSetup() ) {
			cb.setNextModuleEvent( "SuperMenu", "home.chooseInstallOption" );
		}
	}
	
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
		SuperMenuService.manageContentMenuLinks( collection=event.getCollection(), content=arguments.interceptData.page );
	}
	
	/**
	* Make any additions/update/deletions to entry links based on changes in entry state
	*/
	public Any function cbadmin_postEntrySave( required Any event, required struct interceptData ) {
		SuperMenuService.manageContentMenuLinks( collection=event.getCollection(), content=arguments.interceptData.entry );
	}
	
	/**
	* Make any additions/update/deletions to page links based on changes in entry state
	*/
	public Any function cbadmin_prePageRemove( required Any event, required struct interceptData ) {
		SuperMenuService.manageContentMenuLinks( collection=event.getCollection(), content=arguments.interceptData.page );
	}
	
	/**
	* Make any additions/update/deletions to entry links based on changes in entry state
	*/
	public Any function cbadmin_preEntryRemove( required Any event, required struct interceptData ) {
		SuperMenuService.manageContentMenuLinks( collection=event.getCollection(), content=arguments.interceptData.entry );
	}
	
	private void function appendToAccordion( required Any event ) {
		if( SuperMenuService.isDataSetup() ) {
    		// add menuselect view to the sidebar
    		appendToBuffer( 
    			renderView( view='menu/menuselect', module="SuperMenu", args=SuperMenuService.getAccordionContent( event.getCollection() ) ) 
            );
        }
    }
}