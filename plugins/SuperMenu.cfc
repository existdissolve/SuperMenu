/**
* A cool basic widget that renders SuperMenus
*/
component extends="coldbox.system.Plugin" singleton {
	// DI
	property name="SuperMenuService" inject="SuperMenuService@SuperMenu";
	property name="MenuService" inject="entityService:Menu";
	property name="ZoneService" inject="entityService:Zone";
	property name="LinkMenuContentService" inject="entityService:LinkMenuContent";
	property name="cb" inject="cbHelper@cb";
	
	SuperMenu function init( controller ){
		// super init
		super.init( controller );

		// Widget Properties
		setPluginName( "SuperMenu" );
		setPluginVersion( "1.0" );
		setPluginDescription( "Include a SuperMenu in your layout" );
		setPluginAuthor( "Joel Watson" );
		setPluginAuthorURL( "http://existdissolve.com" );

		return this;
	}

	/**
	* Render the menu by slug lookup
	* @slug.hint The menu slug that should be rendered
	*/
	public String function renderIt( String slug, String zone ){
		var menu = "";
		var targetZone = "";
		var menuString = "";
		var contentID = "";
		// set flags
		var hasSlug = structKeyExists( arguments, "slug" ) ? true : false;
		var hasZone = structKeyExists( arguments, "zone" ) ? true : false;
		
		// if we have a slug, try to get the menu based on slug
		if( hasSlug ) {
			// get the menu by slug
    		menu = MenuService.findWhere(criteria={
    			Slug=arguments.slug
    		});
		}
		// if we have a zone, try to look it up based on the name
		if( hasZone ) {
			// get the zone by name
    		targetZone = ZoneService.findWhere(criteria={
    			Name=arguments.zone
    		});
		}
		
		// if no slug is defined BUT we have a target, see if there is a menu defined for this zone
		if( !isSimpleValue( targetZone ) && !isNull( targetZone ) && !hasSlug ) {
			menu = MenuService.findAllWhere(criteria={
				Zone=targetZone
			});
			if( arrayLen( menu ) ) {
				menu=menu[1];
			}
		} 
		
		// switch on page/entry types to get contentID
		if( cb.isPageView() ) {
			contentID = cb.getCurrentPage();
		}
		if( cb.isEntryView() ) {
			contentID = cb.getCurrentEntry();
		}
		// if we have a contentID, check and see if there are page-level overrides for the zone
		if( !isSimpleValue( contentID ) && !isSimpleValue( targetZone ) && !isNull( targetZone ) ) {
			var menuLink = LinkMenuContentService.findWhere(criteria={
				ContentID = contentID,
				ZoneID = targetZone
			});
			if( !isNull( menuLink ) ) {
				menu = MenuService.get( menuLink.getMenuID().getMenuID() );
			}
		}
		// if we have a menu, build out the html for it
		if( !isNull( menu ) ) {
			savecontent variable="menuString" {
				writeoutput( "<ul>#buildMenu( menu=menu.getItems() )#</ul>" );
			}			
		}
		return menuString;
	}
	
	/**
    * Helper method to build menu of variable depth
    * @menu.hint The array of menu items to build into html
    * @menuString.hint The string that's being built into menu html
    * @inChild.hint Argument used during recursion to help differentiate menu items from one another
    */
	private String function buildMenu( required Array menu, required String menuString="", inChild=false ) output=true {
		// iterate menu items
		for( var item in arguments.menu ) {
			var skipItem = false;
			var type = item.getType();
			var content = "";
			// if item has a parent and it's not currently be processed at its own level, skip
			if( !isNull( item.getParentID() ) && !inChild ) {
				//skipItem = true;
				continue;
			}
			// if blog or page, try to get content
			if( listContainsNoCase( "page,blog", item.getType() ) ) {
				switch( type ) {
					case "page":
						content = cb.getPageService().get( item.getContentID().getContentID() );
						break;
					case "blog":
						content = cb.getEntryService().get( item.getContentID().getContentID() );
						break;	
				}
			}
			
			// if blog or page, check if item is published
			if( !isNull( content ) && !isSimpleValue( content ) ) {
				// if publish date is in the future
				if( !content.getIsPublished() || content.getPublishedDate() > now() ) {
					continue;
				}
				// if published page has expired
				if( !isNull( content.getExpireDate() ) && content.getExpireDate() < now() ) {
					continue;
				}
			}

			// if we're not skipping, render html for list item
			menuString &= '<li id="key_#item.getMenuItemID()#">';
			var linkPath = "";
			var target = "_self";
			// switch on menu item type so we can build the correct url
			switch( type ) {
				// pages
				case "page":
					if( !isNull( content ) && !isSimpleValue( content ) ) {
						linkPath = getRequestContext().buildLink( linkto=content.getSlug() );
					}
					break;
				// blog entries
				case "blog":
					if( !isNull( content ) && !isSimpleValue( content ) ) {
						// get blog entry point from cbhelper
						linkPath = getRequestContext().buildLink( linkto= cb.getBlogEntryPoint() & "/" & content.getSlug() );
					}
					break;
				// custom links
				case "custom":
					linkPath = item.getURL();
					target = "_blank";
					break;
			}
			menuString &= '<a href="#linkPath#" target="#target#" title="#item.getLabel()#">#item.getTitle()#</a>';
			// if item has children, create sub list items and recurse this method to build those
			if( item.hasChildren() ) {
				menuString &='<ul>';
				menuString &= buildMenu( menu=item.getChildren(), inChild=true );
				menuString &='</ul>';
			}
			menuString &='</li>';	
		}
		return menuString;
	}
}