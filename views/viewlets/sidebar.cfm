<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">

	<!--- Info Box --->
	<div class="small_box expose">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/info.png" alt="info" width="24" height="24" />
            <cfswitch expression="#args.page#">
				<cfcase value="about">
                About Super Menu
				</cfcase>
				<cfcase value="zone">
                About Zones
				</cfcase>
				<cfcase value="menu">
                About Menus
				</cfcase>
			</cfswitch>
		</div>
		<div class="body">
			<!---main message area--->
			<cfswitch expression="#args.page#">
				<cfcase value="about">
					<p>
                        Super Menu is all about giving you control over your site's menus. While it's nice to have some menus be auto-generated,
                        Super Menu gives you the control to create your own menus and use them however--and wherever--you want.
                    </p>                             
                    <p>
                        Whether you are creating a customized global site navigation, or a page-specific mini-menu, Super Menu makes it easy! 
                    </p>
				</cfcase>
                <cfcase value="zone">
					<p>
                        Zones allow you to create placeholders for custom menus. Once a zone is defined, you can easily define it as a default for a menu,
                        and from then on that menu will be automatically rendered wherever the zone is included in your layout or view.
                    </p>
				</cfcase>
				<cfcase value="menu">
					<p>
                        Menus can be as flexible as you want them to be. You can add custom lists and orderings of pages, blog posts, and even custom links!
                    </p>
                    <p>
                        To add a menu, click "Create Menu" in the control panel. Then, simply give it a title and start adding content to the "Menu Creator" by using the panels in the sidebar.
                    </p>
                    <p>Once you've added content to the Menu Creator, you can easily reorder and even nest the items, simply by dragging and dropping. You can even customize the title and label for the items, if you want.</p>
				</cfcase>
			</cfswitch>
		</div>
	</div>

</div>
<!--End sidebar-->
</cfoutput>