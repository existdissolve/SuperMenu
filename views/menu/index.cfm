<cfscript>
	event.paramValue( "menuContent", "" );
	event.paramValue( "title", "" );
	event.paramValue( "slug", "" );
	event.paramValue( "listtype", "" );
	event.paramValue( "menuclass", "" );
	event.paramValue( "id", "" );
	event.paramValue( "zone", "" );
	event.paramValue( "content", "" );
	event.paramValue( "JSONContent", "" );
	if( structKeyExists( prc, "menu" ) ) {
		event.setValue( "menuContent", prc.menuContent );
		event.setValue( "title", prc.menu.getTitle() );
		event.setValue( "slug", prc.menu.getSlug() );
		event.setValue( "listtype", prc.menu.getListType() );
		event.setValue( "id", prc.menu.getMenuID() );
		if( !isNull( prc.menu.getZone() ) ) {
			event.setValue( "zone", prc.menu.getZone().getZoneID() );
		}
		if( !isNull( prc.menu.getMenuClass() ) ) {
			event.setValue( "menuclass", prc.menu.getMenuClass() );
		}
	}
</cfscript>
<cfoutput>
#renderView( "viewlets/assets" )#
#renderView( "viewlets/sidebar" )#
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			Super Menu!
		</div>
        #renderView( "viewlets/submenu" )#
		<!--- Body --->
		<div class="body" id="mainBody">
		    <!---message box--->
			#getPlugin("MessageBox").renderit()#
			<!--- Navigation Bar --->
            <div class="body_vertical_nav clearfix">
                <div class="left_side_bar">
                    <div class="simple_panel left">
                        <div class="panel_header"><img src="#prc.cbRoot#/includes/images/settings_black.png" alt="Control"/>  Control<div class="collapse_arrow"></div></div>
                        <div class="panel_content">
                            <ul class="checkbox_selectors">
                				<li class="active">
                				    <a href="#prc.xehCreateMenuLink#"><img src="#prc.cbRoot#/includes/images/plus.png" alt="Create Menu"/>  Create Menu</a>
                               	</li>
                				<cfif arrayLen( prc.editableMenus )>
									<li>
									    <img src="#prc.cbRoot#/includes/images/edit.png" alt="Edit Existing Menu"/>
									    <select id="menu_selector">
									        <option value="javascript:void(0);">Choose a Menu</option>
									        <cfloop array="#prc.editableMenus#" index="menu">
            									<option value="#prc.xehEditLink#/menu/#menu.getMenuID()#">#menu.getTitle()#</option>            									
											</cfloop>
									    </select>
									</li>
            					</cfif>
                			</ul>    
                        </div>
                    </div>
                    <div class="simple_panel left">
                        <div class="panel_header"><img src="#prc.cbRoot#/includes/images/link.png" alt="Custom Link"/>  Custom Links<div class="collapse_arrow"></div></div>
                        <div class="panel_content">
                        	<label>URL</label>
                            <input type="text" id="customlink_url" value="http://" />
                            <label>Label</label>
                            <input type="text" id="customlink_title" value="" />
                            <input type="hidden" id="customlink_type" value="custom" />
                        	<div class="panel_footer">
								#html.button(value="Add Link",class="buttonsmall",title="Add Link",id="link_adder")#
							</div>
                        </div>
                    </div>
                    <div class="simple_panel left">
                        <div class="panel_header"><img src="#prc.cbRoot#/includes/images/page.png" alt="Pages"/>  Pages<div class="collapse_arrow"></div></div>
                        <div class="panel_content">
                        	#prc.miniPagesMenu#
                        	<div class="panel_footer">
								#html.button(value="Add Pages",class="buttonsmall",title="Add Selected Pages",id="page_adder")#
							</div>
                        </div>
                    </div>
                    <div class="simple_panel left">
                        <div class="panel_header"><img src="#prc.cbRoot#/includes/images/page.png" alt="Blog Entries"/>  Blog Entries<div class="collapse_arrow"></div></div>
                        <div class="panel_content">
                        	#prc.miniBlogsMenu#
                        	<div class="panel_footer">
								#html.button(value="Add Entries",class="buttonsmall",title="Add Selected Entries",id="blog_adder")#
							</div>
                        </div>
                    </div>
                </div>
                <div class="main_column">
					<!-- Content area that wil show the form and stuff -->
					<div class="panes_vertical">
                        <!---start form--->
            			#html.startForm( action="cbadmin.module.supermenu.menu.save", name="menuForm", id="supermenu_form" )#
            				<fieldset>
                				<legend>
                				    <img src="#prc.cbRoot#/includes/images/settings_black.png" alt="modifiers"/> 
                                    <strong>
                                        <cfif structKeyExists( prc, "menu" )>
                                        	Edit '#event.getValue( "title" )#' Menu
                                        <cfelse>
                                        	Create Super Menu
										</cfif>
                                    </strong>
                               	</legend>
            					#html.textField( 
            						name="supermenu_title", 
            						label="Title:", 
            						class="textfield width98", 
            						required="required",
            						value="#event.getValue( 'title' )#"
            					)#            					
            					#html.textField( 
            						name="supermenu_slug", 
            						label="Slug:", 
            						class="textfield width98", 
            						required="required",
            						value="#event.getValue( 'slug' )#"
            					)#            					
            					#html.select( 
            						name="supermenu_listtype", 
            						label="List Type:", 
            						class="textfield width98", 
            						required="required",
            						options="ul,ol",
									selectedValue="#event.getValue( 'listtype' )#"
            					)#
            					#html.textField( 
            						name="supermenu_menuclass", 
            						label="Extra Class:", 
            						class="textfield width98", 
            						required="required",
            						value="#event.getValue( 'menuclass' )#"
            					)#
            					<label for="supermenu_zone">Zone:</label>
            					<select name="supermenu_zone" class="textfield width98" required=false>
            					    <option value="">--Select a Zone--</option>
                                    <cfloop array="#prc.zones#" index="zone">
										<option value="#zone.getZoneID()#" <cfif event.getValue( "zone" ) eq zone.getZoneID()>selected=true</cfif>>#zone.getName()#</option>	
									</cfloop>
            					</select>
            					#html.hiddenField( 
            						name="supermenu_id",
									id="menuID",
            						value="#event.getValue( 'id' )#"
            					)#
            					#html.hiddenField( 
            						name="supermenu_content",
            						value="#event.getValue( 'content' )#"
            					)#
            				</fieldset>
                        
                			<fieldset id="menucreator" class="sortable-menu">
                			    <legend>
                			        <img src="#prc.cbRoot#/includes/images/filter.png" height="16" alt="modifiers"/> 
                                    Menu Creator
                                </legend>
                			    <ul class="sortable">
                			        <!---include the menu hierarchy--->
                			        #event.getValue( "menuContent" )#
                                </ul>
                			</fieldset>
                        
                        	<!--- Submit --->
            				<div class="actionBar center">
            				    <!---if a menu exists, show the delete button--->
            				    <cfif structKeyExists( prc, "menu" )>
									#html.button(value="Delete Menu",class="buttonred",id="delete_menu",title="Delete this Super Menu")#
								</cfif>
            					#html.button(value="Save Super Menu",class="button",id="save_menu",title="Save this Super Menu")#
            				</div>
            			#html.endForm()#
            		</div>
            	</div>
    		</div>
		</div>
	</div>
</div>
</cfoutput>