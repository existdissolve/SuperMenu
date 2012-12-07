component extends="coldbox.system.orm.hibernate.VirtualEntityService" accessors="true" singleton {
	property name="SettingService" 	inject="SettingService@cb";

	/**
	* Constructor
	*/
	SuperMenuService function init(){
		// init it
		super.init( entityName="Menu" );
		return this;
	}

	/**
    * 
    *
    */
	public Array function getMenuList() {
		/*var menuList = [];
		var criteria = SettingService.newCriteria();
		criteria.like( "name", "%cbox-supermenu-menu-%" );
		var menus = criteria.list();
		for( var menu in menus ) {
			var item = deserializeJSON( menu.getValue() );
			var editable = {
				"title"=item.title,
				"id"=item.id
			};
			arrayAppend( menuList, editable );
		}
		return menuList;*/
		return getAll();
	}
	
	public String function buildOptionMenu( required Array menu, required Array pageHash=[], required String type="page" ) {
		var content = "<ul id='#arguments.type#_selector' class='checkbox_selectors'>";
		for( var page in arguments.menu ) {
			var printItem = true;
			if( page.hasParent() && !arrayContains( pageHash, page.getParent().getContentID() ) ) {
				printItem = false;
			}
			if( printItem ) {
				arrayAppend( pageHash, page.getContentID() );
    			content &= "<li>
    				<input type='hidden' id='title_#page.getContentID()#' name='title' value='#page.getTitle()#' />
    				<input type='hidden' id='url_#page.getContentID()#' name='url' value='#page.getSlug()#' />
    				<input type='hidden' id='contentID_#page.getContentID()#' name='contentID' value='#page.getContentID()#' />
    				<input type='checkbox' id='checkbox_#page.getContentID()#' class='page-selector' />#page.getTitle()#";	
    			if( page.hasChild() ) {
    				content &= buildOptionMenu( page.getChildren(), pageHash );
    			}	
			}
		}
		content &="</ul>";
		return content;
	}
	
	public Boolean function isDataSetup() {
		try {
			var testMenu = EntityLoad( "Menu" );
			return true;
		}
		catch( Any e ) {
			return false;
		}
	}
}