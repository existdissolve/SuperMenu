<cfoutput>
	<cfif arrayLen( args.zones )>
        <h2>
        	<img src="#prc.cbRoot#/includes/images/arrow_right.png" alt="" width="6" height="6" class="arrow_right" />
        	<img src="#prc.cbRoot#/includes/images/arrow_down.png" alt="" width="6" height="6" class="arrow_down" />
        	<img src="#prc.cbroot#/includes/images/filter.png" width=16 height=16 alt="Menus" /> Add Menu
        </h2>
        <div class="pane">
            <cfloop array="#args.zones#" index="zone">
            	<label>Zone: #zone.getName()#</label>
                <select name="supermenu_#zone.getZoneID()#" id="supermenu" class="width98">
                    <option value="">-- Select --</option>
                    <cfloop array="#args.menus#" index="menu">
            			<cfset match = hasZoneMatch( menu.getMenuID(), zone.getZoneID(), args.existing )>
            			<option value="#menu.getMenuID()#" <cfif match>selected=true</cfif>>#menu.getTitle()#</option>
            		</cfloop>
                </select>
        	</cfloop>
        </div>
	</cfif>
    <cfscript>
    	function hasZoneMatch( required Numeric menuID, required Numeric zoneID, required Array existing=[] ) {
    		var hasMatch= false;
    		if( arrayLen( arguments.existing ) ) {
        		for( var item in arguments.existing ) {
        			if( item.getMenuID().getMenuID()==arguments.menuID && !isNull( item.getZoneID() ) && item.getZoneID().getZoneID()==arguments.zoneID ) {
        				hasMatch=true;
        				break;
        			}
        		}	
    		}
    		return hasMatch;
    	}
    </cfscript>
</cfoutput>