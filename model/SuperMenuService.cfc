component accessors="true" singleton {
	property name="cb" inject="cbHelper@cb";
	property name="ContentService" inject="entityService:cbContent";
	property name="PageService"	inject="id:pageService@cb";
	property name="EntryService" inject="id:EntryService@cb";
	property name="MenuService";
	property name="MenuItemService";
	property name="ZoneService";
	property name="LinkMenuContentService";
	
	/**
	* Constructor
	* @ORMService.inject coldbox:plugin:ORMService
	*/
	SuperMenuService function init( required Any ORMService ){
		// init it
		variables.ORMService = arguments.ORMService;
		setupORMServices();
		return this;
	}
	
	/**
	* Checks if ORM entities are setup correctly
	* returns {Boolean} whether  or not ORM entities are setup correctly
	*/
	public Boolean function isDataSetup() {
		try {
			var testMenu = EntityLoad( "Menu" );
			return true;
		}
		catch( Any e ) {
			return false;
		}
	}
	
	/**
	* Creates a nice list of either menu or zone options
	* @type {String} the type of menu to build
	* returns {String} a list of menu options
	*/
	public String function createOptionMenu( required String type ) {
		var args = {
			type = arguments.type,
			menu = type=="page" ? PageService.findPublishedPages().pages : EntryService.findPublishedEntries().entries
		};
		return buildOptionMenu( argumentCollection=args );
	}
	
	/**
	* Creates a menu item that can be used in the drag-n-drop admin
	* @menu {Array} the menu to parse
	* @menuString {String} build-up string for menu content
	* @inChild {Boolean} flag for whether the content item is being evaluated as itself, or as a child of another item
	* returns {String} the built out menu
	*/
	public String function buildEditableMenu( required Array menu, required String menuString="", inChild=false ) {
		// loop over menu items
		for( var item in arguments.menu ) {
			var skipItem = false;
			// if item has a parent, and it's being evaluated on the same level as its parent, skip it
			if( !isNull( item.getParentID() ) && !inChild ) {
				skipItem = true;
			}
			// build out the item
			if( !skipItem ) {
				menuString &= '<li id="key_#item.getMenuItemID()#">';
				// create the content of the menu item
				menuString &= createDraggableHTML( item );
				// if this item has children, recursively call this method to build them out too
				if( item.hasChildren() ) {
					menuString &='<ul>';
					menuString &= buildEditableMenu( menu=item.getChildren(), inChild=true );
					menuString &='</ul>';
				}
				menuString &='</li>';	
			}
		}
		return menuString;
	}
		
	/**
	* This is a cleanup method to handle orphan menu links when a page is modified
	* @collection {Struct} the request collection
	* @content {Any} the page or entry content that was modified
	* returns void
	*/
	public void function manageContentMenuLinks( required Struct collection, required Any content ) {
		if( isDataSetup() ) {
        	var zones = ZoneService.getAll();
    		for( var zone in zones ) {
        		// if a menu was selected...
        		if( structKeyExists( arguments.collection, "supermenu_#zone.getZoneID()#" ) && arguments.collection[ "supermenu_#zone.getZoneID()#" ] != "" ) {
        			// look up existing item
        			var menuLink = LinkMenuContentService.findWhere( criteria={
        				ContentID = arguments.content,
        				ZoneID = zone
        			});
        			// if it doesn't exist, create it
        			if( isNull( menuLink ) ) {
        				menuLink = LinkMenuContentService.new( properties={
        					ContentID = arguments.content
        				});
        			}
        			// set the menu link
        			menuLink.setMenuID( MenuService.get( arguments.collection[ "supermenu_#zone.getZoneID()#" ] ) );
        			menuLink.setZoneID( zone );
        			// save 
        			LinkMenuContentService.save( entity=menuLink );
        		}
        		// otherwise, delete any existing links for this page
        		else {
        			LinkMenuContentService.deleteWhere( ContentID = arguments.content, ZoneID=zone );
        		}	
    		}
    	}	
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
			var newItem = MenuItemService.new( properties=itemArgs );
			// set the menuID
			newItem.setMenuID( arguments.menu );
			// if this item has children...
			if( structKeyExists( menuItem, "children" ) ) {
				// recursively call this method to build and save children
				var children = saveMenuItems( arguments.Menu, menuItem.children, newItem );
				newItem.setChildren( children );
			}
			// save the entity
			MenuItemService.save( entity=newItem );
			arrayAppend( items, newItem );
		}
		return items;
	}
    
    /**
    * Builds up a collection of content that 
    * @collection {Struct} the request collection
    * returns {Struct} collection of data
    */
	public Struct function getAccordionContent( required Struct collection ) {
		var rc = arguments.collection;
		var menus = MenuService.getAll();
		var zones = ZoneService.getAll();
		var existing = [];
		
		if( structKeyExists( rc, "contentID" ) ) {
    		// get existing zone relationships for the current page
    		var existing = LinkMenuContentService.findAllWhere( criteria={
    			ContentID = ContentService.get( rc.contentID )
    		});	
		}
		return { 
			menus=menus,
			existing=existing,
			zones=zones 
		};
	}
	
	/**
    * Adds child services to be added to this service
    * @bypass {Boolean} Whetther or not dataSetup() check should be bypassed
    * returns void
    */
	public void function setupORMServices( required bypass=false ) {
		if( isDataSetup() || arguments.bypass ) {
			setMenuService( ORMService.createService( "Menu" ) );
			setMenuItemService( ORMService.createService( "MenuItem" ) );
			setZoneService( ORMService.createService( "Zone" ) );
			setLinkMenuContentService( ORMService.createService( "LinkMenuContent" ) );
		}
	}
	
	/**
    * Reverts child services of this service
    * returns void
    */
	public void function teardownORMServices() {
		setMenuService( "" );
		setMenuItemService( "" );
		setZoneService( "" );
		setLinkMenuContentService( "" );
	}
	
	/**
    * runs a static SQL script (based on configured database type) to install needed tables
    */	
	public void function runSQLScript() {
		// get orm utils
		var orm = new coldbox.system.orm.hibernate.util.ORMUtilFactory().getORMUtil();
		// figure out the default datasource
		var dsn = orm.getDefaultDatasource();
		include "DBInfo.cfm";
		// use dbinfo to lookup db version
		var db = result.database_productname;
		var sql = "";
		// switch on db version
		switch( db ) {
			case "MySQL":
				sql = fileRead( cb.getModuleSettings( "SuperMenu" ).path & "/db/install/sm_MySQL.sql" );
				break;
            case "HSQL Database Engine":
            	sql = fileRead( cb.getModuleSettings( "SuperMenu" ).path & "/db/install/sm_HSQL.sql" );
            	break;
			case "Microsoft SQL Server":
				sql = fileRead( cb.getModuleSettings( "SuperMenu" ).path & "/db/install/sm_SQLServer.sql" );
				break;
			case "Oracle":
				sql = fileRead( cb.getModuleSettings( "SuperMenu" ).path & "/db/install/sm_Oracle.sql" );
				break;
			case "PostgreSQL":
				sql = fileRead( cb.getModuleSettings( "SuperMenu" ).path & "/db/install/sm_PostgreSQL.sql" );
				break;
		}
		// run the sql script
		if( sql != "" ) {
			if( db=="MySQL" || db=="HSQL Database Engine" ) {
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
	public void function activateORMEntities() {
		var entityPaths = [ "Menu.cfc", "MenuItem.cfc", "Zone.cfc", "LinkMenuContent.cfc" ];
		var modelPath = cb.getModuleSettings( "SuperMenu" ).modelsPhysicalPath;
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
	
	/**
    * updates model files to no longer be persistent; will let developers take care of cleaning up db tables for now...
    */
    public void function deactivateORMEntities() {
    	var entityPaths = [ "Menu.cfc", "MenuItem.cfc", "Zone.cfc", "LinkMenuContent.cfc" ];
		var modelPath = cb.getModuleSettings( "SuperMenu" ).modelsPhysicalPath;
		for( var path in entityPaths ) {
    		// get entity paths
    		var entityPath = modelPath & "/orm/#path#";
    		// read the file contents
    		var c = fileRead( entityPath );
    		// add "persistent=true"
    		c = replacenocase( c, 'persistent="true"','', "one" );
    		// overwrite with updates
    		fileWrite( entityPath, c );	
		}
    }
	
	/**
	* puts together an option menu for different types
	* @menu {Array} the menu whose items will become the menu
	* @pageHash {Array} tracker cache to prevent dupes
	* @type {String} the type of menu to build
	* returns {String} the option menu string
	*/
	private String function buildOptionMenu( required Array menu, required Array pageHash=[], required String type="page" ) {
		var content = "<ul id='#arguments.type#_selector' class='checkbox_selectors'>";
		// loop over the menu items
		for( var page in arguments.menu ) {
			var printItem = true;
			// if the current item has a parent its not in the page hash, skip it and eval later
			if( page.hasParent() && !arrayContains( pageHash, page.getParent().getContentID() ) ) {
				printItem = false;
			}
			// if we process this one
			if( printItem ) {
				// add to page cache
				arrayAppend( pageHash, page.getContentID() );
				// build the content
    			content &= "<li>
    				<input type='hidden' id='title_#page.getContentID()#' name='title' value='#page.getTitle()#' />
    				<input type='hidden' id='url_#page.getContentID()#' name='url' value='#page.getSlug()#' />
    				<input type='hidden' id='contentID_#page.getContentID()#' name='contentID' value='#page.getContentID()#' />
    				<input type='checkbox' id='checkbox_#page.getContentID()#' class='page-selector' />#page.getTitle()#";	
    			// if it has a child, recurse
    			if( page.hasChild() ) {
    				content &= buildOptionMenu( page.getChildren(), pageHash );
    			}	
			}
		}
		content &="</ul>";
		return content;
	}
	
	/**
	* Creates the inner HTML (divs, fields, etc) for a draggable menu item
	* @item {model.MenuItem} the menu Item
	* returns {String the inner HTML of the menu item}
	*/
	private String function createDraggableHTML( required Any item ) {
		var extraClass = "";
		var extraTitle = "";
		if( item.getType() != "custom" ) {
			var pagecontent = item.getContentID();
			// if publish date is in the future
			if( !pagecontent.getIsPublished() || pagecontent.getPublishedDate() > now() ) {
				extraClass = "notpublished";
				extraTitle = "title='This content not published.'";
			}
			// if published page has expired
			if( !isNull( pagecontent.getExpireDate() ) && pagecontent.getExpireDate() < now() ) {
				extraClass = "notpublished";
				extraTitle = "title='This content is expired and no longer published.'";
			}
		}
		var content = '
            <div class="collapsible_wrapper">
                <div class="collapsible_title #extraClass#" #extraTitle#>#item.getLabel()#<div class="content_type">#item.getType()#</div><div class="collapse_arrow"></div></div>
                <div class="collapsible_content">
                    <table border="0" cellspacing="0" cellpadding="0">
                		<tr>
                		    <td>
                		        <label>Label:</label>
                		    </td>
                            <td>
                                <input type="text" name="label" value="#item.getLabel()#" />
                            </td>
                            <td>
                		        <label>Title:</label>
                		    </td>
                            <td>
                                <input type="text" name="title" value="#item.getTitle()#" />
                                <input type="hidden" name="type" value="#item.getType()#" />
                            </td>
                		</tr>';
		if( item.getType() == "custom" ) {
			content &='
			<tr>
				<td colspan="1">
					<label>URL:</label>
				</td>
				<td colspan="3">
					<input type="text" name="url" value="#item.getURL()#" style="width:98%;" />
				</td>
			</tr>';
		}
		else {
			content &= '
				<tr>
					<td colspan="1">
						<label>Original:</label>
					</td>
					<td colspan="3">
						<span style="font-size:12px;">#pagecontent.getTitle()#</span>
					</td>
				</tr>
			';
			content &= '<input type="hidden" name="contentID" value="#item.getContentID().getContentID()#" />';
		}
        content &=
        		    '</table>
                    <div class="removal">
                        <a href="javascript:void(0);">Remove Menu Item</a>
                    </div>
				</div>
        	</div>';
        return content;
	}
}