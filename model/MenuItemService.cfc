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
	public Any function saveMenuItems( required Any Menu, required Array menuItems, Any parent="" ) {
		var items = [];
		for( var menuItem in arguments.menuItems ) {
			var itemArgs = {
				label=menuItem.label,
				title=menuItem.title,
				url=structKeyExists( menuItem, "url" ) && menuItem.url != "" ? menuItem.url : "",
				type=menuItem.type
			};
			if( structKeyExists( menuItem, "contentID" ) && menuItem.contentID != "" ) {
				switch( menuItem.type ) {
					case "page":
						itemArgs.ContentID = cb.getPageService().get( menuItem.contentID );
						break;
					case "blog":
						itemArgs.ContentID = cb.getEntryService().get( menuItem.contentID );
						break;
				}
			}
			var newItem = new( properties=itemArgs );
			newItem.setMenuID( arguments.menu );
			// save the Menu Item
			if( structKeyExists( menuItem, "children" ) ) {
				var children = saveMenuItems( arguments.Menu, menuItem.children, newItem );
				newItem.setChildren( children );
			}
			save( entity=newItem );
			arrayAppend( items, newItem );
		}
		return items;
	}
}