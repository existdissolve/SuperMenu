<cfoutput>
#renderView( "viewlets/assets" )#
#renderView( view="viewlets/sidebar",args={page="about"} )#
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			About Super Menu
		</div>
        #renderView( "viewlets/submenu" )#
		<!--- Body --->
		<div class="body" id="mainBody">
		    <div class="body_vertical_nav clearfix">
				<!--- Navigation Bar --->
				<ul class="vertical_nav">
					<li>
					    <a href="##tuning_options"><img height="16" src="#prc.cbRoot#/includes/images/tables_icon.png" alt="modifiers"/> Zones</a>
                    </li>
                    <li>
					    <a href="##tuning_options"><img height="16" src="#prc.cbRoot#/includes/images/filter.png" alt="modifiers"/> Menus</a>
                    </li>
                    <li>
					    <a href="##tuning_options"><img height="16" src="#prc.cbRoot#/includes/images/settings_black.png" alt="modifiers"/> Usage</a>
                    </li>
				</ul>
				<div class="main_column">
    				<!-- Content area that wil show the form and stuff -->
    				<div class="panes_vertical">        
        				<!--- Zones --->
        				<div>
        					<fieldset>
        						<legend>
        						    <img src="#prc.cbRoot#/includes/images/tables_icon.png" alt="modifiers"/> <strong>Zones</strong>
                                </legend>
                                <p>Zones are ways of identifying placeholders for your menus. You can use zones in two ways:</p>
                                <ul class="in-content">
                                    <li>Specify a default zone for a given menu. This will render the menu for that zone anywhere where you specify
                                     that zone in your layouts or views.</li>
                                    <li>Override a zone per page. When editing a page, you can select the menu that you would like to apply to the specified zone,
                                    regardless of any prior configuration in the view.</li>
                                </ul>
                                <p>(See <strong>Usage</strong> for examples)</p>
        					</fieldset>
        				</div>
                        
                        <!--- Menus --->
        				<div>
        					<fieldset>
        						<legend>
        						    <img src="#prc.cbRoot#/includes/images/filter.png" alt="modifiers"/> <strong>Menus</strong>
                                </legend>
                                <p>The beauty of creating menus with Super Menu is that they are as flexible as you need them to be. You can do the following in your menu:</p>
        						<ul class="in-content">
        						    <li>Nest content in any structure you'd like with a super-easy drag-n-drop interface</li>
                                    <li>Include published pages in any order you want</li>
                                    <li>Include blog posts in any order you want</li>
                                    <li>Make your own custom links!</li>
        						</ul>
                                <p>(See <strong>Usage</strong> for examples)</p>
                            </fieldset>
        				</div>
                        
                        <!--- Usage --->
        				<div>
        					<fieldset>
        						<legend>
        						    <img src="#prc.cbRoot#/includes/images/settings_black.png" alt="modifiers"/> <strong>Usage</strong>
                                </legend>
                                <p>There are several ways to use Super Menu, all with complete flexibility in mind.</p>
                                <h4>Zones with Default Menus</h4>
                                <p>One of the most flexible ways to use Super Menu is to create a zone "placeholder" and then associate it with a menu. To do this:</p>
                                <ul class="in-content">
                                    <li>First, create a zone (e.g., "Sidebar")</li>
                                    <li>Next, adjust your layout with the code to embed Super Menu:<br />
                                    	<strong>getPlugin( plugin="SuperMenu", module="SuperMenu" ).renderIt( zone="Sidebar" )</strong>
                                    </li>
                                    <li>Finally, edit one of your menus and select "Sidebar" as the zone.</li>                                
                                </ul>
                                <p>The menu should now appear in all pages where the layout with the plugin code is used!
                                And better yet, if you ever change the menu that is associated to the zone, the new menu content will be instantly reflected in your rendered content.</p>
                                <h4>Menu Slug</h4>
                                <p>Of course, you don't have to use zones if you don't want to. You can also simply plunk a menu into a layout or view by using the menu's "slug". To do this:</p>
                                <ul class="in-content">
                                    <li>First, create your custom menu (e.g., slug="custom-menu")</li>
                                    <li>Next, add the folowing to your layout:<br />
                                    	<strong>getPlugin( plugin="SuperMenu", module="SuperMenu" ).renderIt( slug="custom-menu" )</strong>	
                                    </li>
                                </ul>
                                <p>As with the zone example, this will now render the specified menu (by slug) where the plugin code is used.</p>
                                <h4>Page Overrides for Zones</h4>
                                <p>One powerful option with Super Menu is ability to override zone defaults at a page level. To do this:</p>
                                <ul class="in-content">
                                    <li>In the desired page, select the menu that you'd like to use for the selected zone.</li>
                                    <li>Save the page.</li>
                                </ul>
                                <p>You should now see whatever menu you selected when editing the page, 
                                regardless of what the menu default for the zone might be.</p>
                            </fieldset>
        				</div>
    				</div> <!--- end vertical panes --->
				</div> <!--- end main_column --->

			</div> <!--- End vertical nav --->
		</div>
	</div>
</div>
</cfoutput>