<cfoutput>
    <script>
        $( document ).ready(function() {
            // form validators
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
                var errors = '';
                if( $( 'input[name=supermenu_title]' ).val()=='' ) {
                    errors += 'Please enter a title for your menu!<br />';
                }
                if( $( 'input[name=supermenu_slug]' ).val()=='' ) {
                    errors += 'Please enter a slug for your menu!<br />';
                }
                if( !hierarchy.length ) {
                    errors += 'Please add at least one item to your menu!';
                }
                if( errors != '' ) {
                    apprise( errors, {});
                    return false;
                }
                $( 'input[name=supermenu_content]' ).val( $.toJSON( hierarchy ) );
                $( '##supermenu_form' )[0].submit();
            }
            function deleteMenu() {
                var form = $( '##supermenu_form' )[0];
                var id = $( '##menuID' ).val();
                form.action = '#prc.xehDeleteLink#/menu/' + id;
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
                                    '<tr>',
                                        '<td>',
                                            '<label>Original:</label>',
                                        '</td>',
                                        '<td>',
                                            '<span style="font-size:12px;">' + data.title + '</span>',
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
        });
    </script>
</cfoutput>