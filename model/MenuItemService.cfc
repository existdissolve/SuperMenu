component extends="coldbox.system.orm.hibernate.VirtualEntityService" accessors="true" singleton {
	property name="cb" inject="cbHelper@cb";
	
	/**
	* Constructor
	*/
	MenuItemService function init(){
		// init it
		super.init( entityName="MenuItem" );
		return this;
	}
	
	/**
    * recursively loop over menu item hierarchy, saving at each level
    * @Menu - The menu to which the items belong
    * @menuItems - The hierachical representation of the items
    * @parent - The parent of which the current iteration is a child 
    */
	public Any function saveMenuItems( required Any Menu, required Array menuItems, Any parent="" ) {
		var items = [];
		// loop over menu items
		for( var menuItem in arguments.menuItems ) {
			// build out arguments for population
			var itemArgs = {
				Label=menuItem.label,
				Title=menuItem.title,
				URL=structKeyExists( menuItem, "url" ) && menuItem.url != "" ? menuItem.url : "",
				Type=menuItem.type
			};
			// if a contentID is defined, we need to get the full entity
			if( structKeyExists( menuItem, "contentID" ) && menuItem.contentID != "" ) {
				// switch on type
				switch( menuItem.type ) {
					case "page":
						itemArgs.ContentID = cb.getPageService().get( menuItem.contentID );
						break;
					case "blog":
						itemArgs.ContentID = cb.getEntryService().get( menuItem.contentID );
						break;
				}
			}
			// create new MenuItem instance
			var newItem = new( properties=itemArgs );
			// set the menuID
			newItem.setMenuID( arguments.menu );
			// if this item has children...
			if( structKeyExists( menuItem, "children" ) ) {
				// recursively call this method to build and save children
				var children = saveMenuItems( arguments.Menu, menuItem.children, newItem );
				newItem.setChildren( children );
			}
			// save the entity
			save( entity=newItem );
			arrayAppend( items, newItem );
		}
		return items;
	}
}