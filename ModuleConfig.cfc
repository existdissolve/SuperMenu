/**
Module Directives as public properties
this.title 				= "Title of the module";
this.author 			= "Author of the module";
this.webURL 			= "Web URL for docs purposes";
this.description 		= "Module description";
this.version 			= "Module Version"

Optional Properties
this.viewParentLookup   = (true) [boolean] (Optional) // If true, checks for views in the parent first, then it the module.If false, then modules first, then parent.
this.layoutParentLookup = (true) [boolean] (Optional) // If true, checks for layouts in the parent first, then it the module.If false, then modules first, then parent.
this.entryPoint  		= "" (Optional) // If set, this is the default event (ex:forgebox:manager.index) or default route (/forgebox) the framework
									       will use to create an entry link to the module. Similar to a default event.

structures to create for configuration
- parentSettings : struct (will append and override parent)
- settings : struct
- datasources : struct (will append and override parent)
- webservices : struct (will append and override parent)
- interceptorSettings : struct of the following keys ATM
	- customInterceptionPoints : string list of custom interception points
- interceptors : array
- layoutSettings : struct (will allow to define a defaultLayout for the module)
- routes : array Allowed keys are same as the addRoute() method of the SES interceptor.
- modelMappings : structure of model mappings. Allowed keys are the alias and path, same as normal model mappings.

Available objects in variable scope
- controller
- appMapping (application mapping)
- moduleMapping (include,cf path)
- modulePath (absolute path)
- log (A pre-configured logBox logger object for this object)

Required Methods
- configure() : The method ColdBox calls to configure the module.

Optional Methods
- onLoad() 		: If found, it is fired once the module is fully loaded
- onUnload() 	: If found, it is fired once the module is unloaded

*/
component {
	property name="appPath" inject="coldbox:setting:applicationPath";
	
	// Module Properties
	this.title 				= "SuperMenu";
	this.author 			= "Joel Watson";
	this.webURL 			= "http://existdissolve.com";
	this.description 		= "SuperMenu helps you create customizable menus that can be used anywhere on your ColdBox site";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "SuperMenu";
	
	function configure(){
		
		// parent settings
		parentSettings = {
		
		};
	
		// module settings - stored in modules.name.settings
		settings = {
			map = []
		};
		
		// Layout Settings
		layoutSettings = {
			defaultLayout = ""
		};
		
		// datasources
		datasources = {
		
		};
		
		// web services
		webservices = {
		
		};
		
		// SES Routes
		routes = [
			// Module Entry Point
			{ pattern="/", handler="menu", action="index" },
			// Edit Menu
			{ pattern="edit/:menu", handler="menu", action="edit" },
			// Delete Menu
			{ pattern="delete/:menu", handler="menu", action="delete" },
			// Convention Route
			{ pattern="/:handler/:action?" }	
		];		
		
		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};
		
		// Custom Declared Interceptors
		interceptors = [
			{ class="#moduleMapping#.interceptors.SuperMenu", name="SuperMenu" }
		];
		// services
		binder.map("SuperMenuService@SuperMenu").to("#moduleMapping#.model.SuperMenuService");
		binder.map("MenuItemService@SuperMenu").to("#moduleMapping#.model.MenuItemService");
	}
	
	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad() {
		// ContentBox loading
		if( structKeyExists( controller.getSetting("modules"), "contentbox" ) ){
			// Let's add ourselves to the main menu in the Modules section
			var menuService = controller.getWireBox().getInstance("AdminMenuService@cb");
			// Add Menu Contribution
			menuService.addSubMenu(
				topMenu=menuService.MODULES,
				name="SuperMenu",
				label="SuperMenu",
				href="#menuService.buildModuleLink( 'SuperMenu', 'menu.index' )#"
			);
		}
	}
	
	/**
	* Fired when the module is activated
	*/
	function onActivate(){
		// active ORM-auto-update during installation
		var SettingService = controller.getWireBox().getInstance( "SettingService@cb" );
		// store default settings
		var setting = SettingService.findWhere( criteria={ name="cbox-supermenu-map" } );
		if( isNull( setting ) ){
			var args = { name="cbox-supermenu-map", value=serializeJSON( settings ) };
			var SuperMenuSettings = SettingService.new(properties=args);
			SettingService.save( SuperMenuSettings );
		}
	}
	
	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		// ContentBox unloading
		if( structKeyExists( controller.getSetting("modules"), "contentbox" ) ){
			// Let's remove ourselves to the main menu in the Modules section
			var menuService = controller.getWireBox().getInstance("AdminMenuService@cb");
			// Remove Menu Contribution
			menuService.removeSubMenu(topMenu=menuService.MODULES,name="SuperMenu");
		}
	}
	/**
    * Updates Application.cfc to either allow or prevent auto-ORM udpates
    * @active {String} Flag for whether to activate or disable auto-ORM updates
    */
	private void function processORMUpdate( required String active ){
		var appCFCPath = controller.getAppRootPath() & "Application.cfc";
		var c = fileRead( appCFCPath );
		c = active ? replaceNoCase( c, '"none"', '"update"' ) : replaceNoCase( c, '"update"', '"none"' );
		fileWrite( appCFCPath, c );
	}
}