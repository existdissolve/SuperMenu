<cfscript>
	event.paramValue( "zoneID", "" );
	event.paramValue( "name", "" );
	if( structKeyExists( prc, "zone" ) ) {
		event.setValue( "zoneID", prc.zone.getZoneID() );
		event.setValue( "name", prc.zone.getName() );
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
			<!--- Navigation Bar --->
            <div class="body_vertical_nav clearfix">
                <div class="left_side_bar">
                    <div class="simple_panel left">
                        <div class="panel_header"><img src="#prc.cbRoot#/includes/images/settings_black.png" alt="Control"/>  Control<div class="collapse_arrow"></div></div>
                        <div class="panel_content">
                            <ul class="checkbox_selectors">
                				<li class="active">
                				    <a href="#prc.xehCreateLink#"><img src="#prc.cbRoot#/includes/images/plus.png" alt="Create Zone"/>  Create Zone</a>
                               	</li>
                				<cfif arrayLen( prc.editableZones )>
									<li>
									    <img src="#prc.cbRoot#/includes/images/edit.png" alt="Edit Existing Zone"/>
									    <select id="zone_selector">
									        <option value="javascript:void(0);">Choose a Zone</option>
									        <cfloop array="#prc.editableZones#" index="zone">
            									<option value="#prc.xehEditLink#/zone/#zone.getZoneID()#">#zone.getName()#</option>
											</cfloop>
									    </select>
									</li>
            					</cfif>
                			</ul>    
                        </div>
                    </div>                 
                </div>
                <div class="main_column">
					<!-- Content area that wil show the form and stuff -->
					<div class="panes_vertical">
					    <!---message box--->
						#getPlugin("MessageBox").renderit()#
                        <!---start form--->
            			#html.startForm( action="cbadmin.module.supermenu.zone.save", name="zoneForm", id="zone_form" )#
            				<fieldset>
                				<legend>
                				    <img src="#prc.cbRoot#/includes/images/settings_black.png" alt="modifiers"/> 
                                    <strong>
                                        <cfif structKeyExists( prc, "zone" )>
                                        	Edit '#event.getValue( "name" )#' Zone
                                        <cfelse>
                                        	Create Zone
										</cfif>
                                    </strong>
                               	</legend>
            					#html.textField( 
            						name="name", 
            						label="Zone Name:", 
            						class="textfield width98", 
            						required="required",
            						value="#event.getValue( 'name' )#"
            					)#
            					
            					#html.hiddenField( 
            						name="zoneID",
									id="zoneID",
            						value="#event.getValue( 'zoneID' )#"
            					)#
            				</fieldset>
                                                    
                        	<!--- Submit --->
            				<div class="actionBar center">
            				    <cfif structKeyExists( prc, "zone" )>
									#html.button(value="Delete Zone",class="buttonred",id="delete_zone",title="Delete this Zone")#
								</cfif>
            					#html.button(value="Save Zone",class="button",id="save_zone",title="Save this Zone")#
            				</div>
            			#html.endForm()#                
            		</div>
            	</div>
    		</div>
		</div>
	</div>
</div>
</cfoutput>