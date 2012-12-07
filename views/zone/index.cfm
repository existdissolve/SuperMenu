<cfscript>
	event.paramValue( "zoneID", "" );
	event.paramValue( "name", "" );
	if( structKeyExists( prc, "zone" ) ) {
		event.setValue( "zoneID", prc.zone.getZoneID() );
		event.setValue( "name", prc.zone.getName() );
	}
</cfscript>
<cfoutput>
<link href="#prc.moduleRoot#/includes/supermenu_style.css" type="text/css" rel="stylesheet" />
<style type="text/css">
    .sortable-menu ul { min-height:10px; }
    .sortable-menu ul ul {margin-left:40px;}
    .sortable-menu li {list-style:none;}
    div.collapsible_wrapper { width: 400px; border:solid 1px ##ccc;border-radius:3px;margin-bottom:5px;background:##efefef; }
    div.collapsible_title,div.collapsible_content {padding:5px;}
    div.collapsible_title {background:##dadada;font-weight:bold;cursor:pointer;}
    .collapsible_content {display:none;}
    .placeholder {width:400px;outline: 1px dashed ##4183C4;margin-bottom:5px;}
    .collapse_arrow {width:20px;height:20px;float:right;position:relative;top:5px;right:-5px;background-image:url(#prc.moduleRoot#/includes/images/arrows.png)}
</style>
<link href="#prc.moduleRoot#/includes/css/jquery-ui.css" type="text/css" rel="stylesheet" />
<link href="#prc.moduleRoot#/includes/css/apprise.min.css" type="text/css" rel="stylesheet" />
<script src="#prc.moduleRoot#/includes/js/jquery.json-2.4.min.js"></script>
<script src="#prc.moduleRoot#/includes/js/jquery.ui.core.js"></script>
<script src="#prc.moduleRoot#/includes/js/jquery.ui.widget.js"></script>
<script src="#prc.moduleRoot#/includes/js/jquery.ui.mouse.js"></script>
<script src="#prc.moduleRoot#/includes/js/jquery.ui.sortable.js"></script>
<script src="#prc.moduleRoot#/includes/js/jquery.nestedsortable.js"></script>
<script src="#prc.moduleRoot#/includes/js/apprise-1.5.min.js"></script>
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
                        <script>
                            $( '##save_zone' ).click(function(){
                                saveZone(); 
                            });
                            $( '##delete_zone' ).click(function(){
                                deleteZone();
                            })
                            $( '##zone_selector' ).change(function() {
                                window.location= $( '##zone_selector option:selected' ).val();
                            })
                            function saveZone() {                              
                                $( '##zone_form' )[0].submit();
                            }
                            function deleteZone() {
                                var form = $( '##zone_form' )[0]
                                form.action = '#prc.xehDeleteLink#/zone/#event.getValue( "zoneID" )#';
                                apprise( 'Are you sure you want to delete this zone? This will remove this zone from any menus that specify it.', {
                                    verify:true
                                },function(r) {
                                    if(r) {
                                        form.submit();
                                    }
                                });
                                return false;
                            }
                        </script>
            		</div>
            	</div>
    		</div>
		</div>
	</div>
</div>
</cfoutput>