<cfscript>
	event.paramValue( "title", "" );
	event.paramValue( "slug", "" );
	event.paramValue( "listtype", "" );
	event.paramValue( "menuclass", "" );
	event.paramValue( "id", "" );
	event.paramValue( "zone", "" );
	event.paramValue( "content", "" );
	event.paramValue( "JSONContent", "" );
	if( structKeyExists( prc, "menu" ) ) {
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
	//var pageSelectionHTML = "";
	/*function buildMiniMenu( required Array menu, required Array pageHash=[], required String type="page" ) {
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
    				content &= buildMiniMenu( page.getChildren(), pageHash );
    			}	
			}
		}
		content &="</ul>";
		return content;
	}
	miniPagesMenu = buildMiniMenu( menu=prc.pages.pages, type="page" );
	miniBlogsMenu = buildMiniMenu( menu=prc.blogs.entries, type="blog" );*/
</cfscript>
<cfoutput>
<link href="#prc.moduleRoot#/includes/supermenu_style.css" type="text/css" rel="stylesheet" />
<style type="text/css">
    .collapse_arrow {width: 20px;height: 20px;float: right;position: absolute;top: 9px;right: 5px;background-image:url(#prc.moduleRoot#/includes/images/arrows.png)}
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
            									<!---<a href="#prc.xehEditLink#/menu/#menu.id#">#menu.title#</a>--->
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
            			#html.startForm( action="cbadmin.module.supermenu.menu.save", name="settingsForm", id="supermenu_form" )#
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
            						value="#event.getValue( 'id' )#"
            					)#
            					#html.hiddenField( 
            						name="supermenu_content",
            						value="#event.getValue( 'content' )#"
            					)#
            				</fieldset>
            			
						
						<cfscript>
							function createDraggableHTML( required Any item ) {
								var extraClass = "";
								if( item.getType() != "custom" ) {
									var content = item.getContentID();
									// if publish date is in the future
                    				if( !content.getIsPublished() || content.getPublishedDate() > now() ) {
                    					extraClass = "notpublished";
                    				}
                    				// if published page has expired
                    				if( !isNull( content.getExpireDate() ) && content.getExpireDate() < now() ) {
                    					extraClass = "notpublished";
                    				}
								}
								var content = '
                                    <div class="collapsible_wrapper">
                                        <div class="collapsible_title #extraClass#">#item.getLabel()#<div class="content_type">#item.getType()#</div><div class="collapse_arrow"></div></div>
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
                        			content &= '<input type="hidden" name="contentID" value="#item.getContentID().getContentID()#" />';
                        		}
                                content &=
                                		    '</table>
                                            <div class="removal">
                                                <a href="javascript:void(0);"><img src="#prc.cbRoot#/includes/images/delete.png" alt="Control"/>  Remove Menu Item</a>
                                            </div>
    									</div>
                                	</div>';
                                return content;
							}
							function buildMenu( required Array menu, required String menuString="", inChild=false ) {
								for( var item in arguments.menu ) {
									var skipItem = false;
									// check menuMap for itemid
									if( !isNull( item.getParentID() ) && !inChild ) {
										skipItem = true;
									}
									if( !skipItem ) {
    									menuString &= '<li id="key_#item.getMenuItemID()#">';
    									menuString &= createDraggableHTML( item );
    									if( item.hasChildren() ) {
    										menuString &='<ul>';
    										menuString &= buildMenu( menu=item.getChildren(), inChild=true );
    										menuString &='</ul>';
    									}
    									menuString &='</li>';	
									}
								}
								return menuString;
							}
						</cfscript>	
            			<fieldset id="menucreator" class="sortable-menu">
            			    <legend>
            			        <img src="#prc.cbRoot#/includes/images/filter.png" height="16" alt="modifiers"/> 
                                Menu Creator
                            </legend>
            			    <ul class="sortable">
            			        <cfif structKeyExists( prc, "menu" )  and prc.menu.hasItems()>
                			        <cftry>
                                    	#buildMenu( prc.menu.getItems() )#
    									<cfcatch type="any">
    										<cfdump var="#cfcatch#">
    									</cfcatch>
    								</cftry>
								</cfif>
                            </ul>
            			</fieldset>
                        
                        	<!--- Submit --->
            				<div class="actionBar center">
            				    <cfif structKeyExists( prc, "menu" )>
									#html.button(value="Delete Menu",class="buttonred",id="delete_menu",title="Delete this Super Menu")#
								</cfif>
            					#html.button(value="Save Super Menu",class="button",id="save_menu",title="Save this Super Menu")#
            				</div>
            			#html.endForm()#
                        <script>
                            $( '.collapsible_title' ).live('click', function(){
                                $( this ).next().slideToggle();
                            });
                            $( '.panel_header' ).click(function() {
                                $( this ).next().slideToggle( 'fast' );
                            })
                            $( '##page_adder' ).click(function(){
                                addPages( 'page' );
                            });
                            $( '##blog_adder' ).click(function(){
                                addPages( 'blog' );
                            });
                            $( '##link_adder' ).click(function(){
                                var slug = $( '##customlink_slug' ).val();
                                if( $( '##customlink_slug' ).val()=='http://' || $( '##customlink_slug' ).val()=='' ) {
                                    apprise( 'You should enter a real URL for your custom link ;)', {});
                                    return false;
                                }
                                if( $( '##customlink_title' ).val()=='' ) {
                                    apprise( 'Please enter a labels for your custom link!', {});
                                    return false;
                                }
                                var uuid = jQuery.guid++;
                                var data = {
                                    id:   uuid,
                                    title:$( '##customlink_title' ).val(),                                    
                                    url:  $( '##customlink_url' ).val(),
                                    type: $( '##customlink_type' ).val()  
                                };
                                addLink( data ); 
                            });
                            $( '##save_menu' ).click(function(){
                                saveMenu(); 
                            });
                            $( '##delete_menu' ).click(function(){
                                deleteMenu();
                            })
                            $( '##menu_selector' ).change(function() {
                                window.location= $( '##menu_selector option:selected' ).val();
                            })
                            $( '.removal a' ).live('click', function(){
                                var me = this;
                                $( this ).parent( 'div' ).parent( 'div' ).parent( 'div' ).parent( 'li' ).slideToggle(
                                    'slow',
                                    function() {
                                        $( this ).remove();
                                    }
                                );
                            });
                            $('.sortable').nestedSortable({
                                handle: 'div',
                                items: 'li',
                                toleranceElement: '> div',
                                listType: 'ul',
                                placeholder: 'placeholder',
                                forcePlaceholderSize: true
                            });
                            function getMenu() {
                                var hierarchy = $('.sortable').nestedSortable( 'toHierarchy' );
                                console.log( hierarchy )
                                console.log( $.quoteString( $.toJSON( hierarchy ) ) );
                            }
                            function saveMenu() {
                                var hierarchy = $('.sortable').nestedSortable( 'toHierarchy' );
                                if( !hierarchy.length ) {
                                    apprise( 'Please add at least one menu item before saving this menu!', {});
                                    return false;
                                }
                                $( 'input[name=supermenu_content]' ).val( $.toJSON( hierarchy ) );
                                $( '##supermenu_form' )[0].submit();
                            }
                            function deleteMenu() {
                                var form = $( '##supermenu_form' )[0]
                                form.action = '#prc.xehDeleteLink#/menu/#event.getValue( "id" )#';
                                apprise( 'Are you sure you want to delete this menu?', {
                                    verify:true
                                },function(r) {
                                    if(r) {
                                        form.submit();
                                    }
                                });
                                return false;
                            }
                            function addPages( type ) {
                                $( '##' + type + '_selector' ).find( 'input[type=checkbox]:checked' ).each(function( index ) {
                                    var selector = $( this ).attr('id').split('_')[1];
                                    var data = {
                                        id: selector,
                                        title: $( '##title_' + selector ).val(),
                                        url: $( '##url_' + selector ).val(),
                                        contentID: $( '##contentID_' + selector ).val(),
                                        type: type
                                    }
                                    addPage( data );
                                });
                            }
                            function addPage( data ) {
                                var sortable = $( '.sortable' );
                                var content = [
                                    '<li id=key_' + data.id + '>',
                                        '<div class="collapsible_wrapper">',
                                            '<div class="collapsible_title">' + data.title + '<div class="content_type">' + data.type + '</div><div class="collapse_arrow"></div></div>',
                                            '<div class="collapsible_content">',
        										'<table border="0" cellspacing="0" cellpadding="0">',
                                            		'<tr>',
                                            		    '<td>',
                                            		        '<label>Label:</label>',
                                            		    '</td>',
                                                        '<td>',
                                                            '<input type="text" name="label" value="' + data.title + '" />',
                                                        '</td>',
                                                        '<td>',
                                            		        '<label>Title:</label>',
                                            		    '</td>',
                                                        '<td>',
                                                            '<input type="text" name="title" value="' + data.title + '" />',
                                                            '<input type="hidden" name="url" value="' + data.url + '" />',
                                                            '<input type="hidden" name="type" value="' + data.type + '" />',
                                                            '<input type="hidden" name="contentID" value="' + data.contentID + '" />', 
                                                        '</td>',
                                            		'</tr>',
                                                '</table>',
                                                '<div class="removal">',
                                                    '<a href="javascript:void(0);">Remove Menu Item</a>',
                                                '</div>',
        									'</div>',
                                    	'</div>',
    								'</li>' 
                                ];
                                var finalString = content.join('');
                                sortable.append( finalString );  
                                $( '##' + data.type + '_selector' ).find( 'input[type=checkbox]:checked' ).each(function( index ) {$
                                    $( this ).removeAttr( 'checked' );
                                });
                            }
                            function addLink( data ) {
                                var sortable = $( '.sortable' );                        
                                var content = [
                                    '<li id=key_' + data.id + '>',
                                        '<div class="collapsible_wrapper">',
                                            '<div class="collapsible_title">' + data.title + '<div class="content_type">' + data.type + '</div><div class="collapse_arrow"></div></div>',
                                            '<div class="collapsible_content">',
        										'<table border="0" cellspacing="0" cellpadding="0">',
                                            		'<tr>',
                                            		    '<td>',
                                            		        '<label>Label:</label>',
                                            		    '</td>',
                                                        '<td>',
                                                            '<input type="text" name="label" value="' + data.title + '" />',
                                                        '</td>',
                                                        '<td>',
                                            		        '<label>Title:</label>',
                                            		    '</td>',
                                                        '<td>',
                                                            '<input type="text" name="title" value="' + data.title + '" />',                                                            
                                                            '<input type="hidden" name="type" value="' + data.type + '" />',
                                                        '</td>',
                                            		'</tr>',
                                                    '<tr>',
                                                        '<td>',
                                            		        '<label>URL:</label>',
                                            		    '</td>',
                                                        '<td colspan="3">',
                                                            '<input type="text" name="url" value="' + data.url + '" style="width:98%;" />',
                                                        '</td>',
                                                    '</tr>',
                                                '</table>',
                                                '<div class="removal">',
                                                    '<a href="javascript:void(0);"><img src="#prc.cbRoot#/includes/images/delete.png" alt="Control"/> Remove Menu Item</a>',
                                                '</div>',
        									'</div>',
                                    	'</div>',
    								'</li>' 
                                ];
                                var finalString = content.join('');
                                sortable.append( finalString );  
                                $( '##customlink_url' ).val( 'http://' );
                                $( '##customlink_title' ).val( '' );
                            }
                        </script>
            		</div>
            	</div>
    		</div>
		</div>
	</div>
</div>
</cfoutput>