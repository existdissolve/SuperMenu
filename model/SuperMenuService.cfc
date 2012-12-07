component accessors="true" singleton {
	/**
	* Constructor
	*/
	SuperMenuService function init(){
		// init it
		return this;
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
	public String function buildEditableMenu( required Array menu, required String menuString="", inChild=false ) {
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
					menuString &= buildEditableMenu( menu=item.getChildren(), inChild=true );
					menuString &='</ul>';
				}
				menuString &='</li>';	
			}
		}
		return menuString;
	}
	
	private String function createDraggableHTML( required Any item ) {
		var extraClass = "";
		var extraTitle = "";
		if( item.getType() != "custom" ) {
			var content = item.getContentID();
			// if publish date is in the future
			if( !content.getIsPublished() || content.getPublishedDate() > now() ) {
				extraClass = "notpublished";
				extraTitle = "title='This content not published.'";
			}
			// if published page has expired
			if( !isNull( content.getExpireDate() ) && content.getExpireDate() < now() ) {
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