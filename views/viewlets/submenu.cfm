<cfoutput>
    <ul class="sub-menu">
        <li>
            <a href="#prc.cbHelper.buildModuleLink( "SuperMenu", "home.index" )#" <cfif prc.currentView eq "home/index">class="selected"</cfif>>About</a>
        </li>
        <li>
            <a href="#prc.cbHelper.buildModuleLink( "SuperMenu", "zone.index" )#" <cfif prc.currentView eq "zone/index">class="selected"</cfif>>Manage Zones</a>
        </li>
        <li>
            <a href="#prc.cbHelper.buildModuleLink( "SuperMenu", "menu.index" )#" <cfif prc.currentView eq "menu/index">class="selected"</cfif>>Manage Menus</a>
        </li>
    </ul>
</cfoutput>