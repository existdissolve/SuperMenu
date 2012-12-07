<cfoutput>
<!--============================Sidebar============================-->
<div class="sidebar">

	<!--- Info Box --->
	<div class="small_box expose">
		<div class="header">
			<img src="#prc.cbroot#/includes/images/info.png" alt="info" width="24" height="24" />Need Help?
		</div>
		<div class="body">
			<a href="http://www.ortussolutions.com" target="_blank" title="The Gurus behind ColdBox and ContentBox">
			<div class="center"><img src="#prc.cbroot#/includes/images/ortus-top-logo.png" alt="Ortus Solutions" border="0" /></a><br/></div>

			<p><strong>Ortus Solutions</strong> is the company behind anything ColdBox and ContentBox. Need professional support, architecture analysis,
			code reviews, custom development or anything ColdFusion, ColdBox, ContentBox related?
			<a href="mailto:help@ortussolutions.com">Contact us</a>, we are here
			to help!</p>

			<p>
				<h2>Resource Links</h2>
				<ul>
					<li>
						<a href="http://code.google.com/p/htmlcompressor/" target="_blank">HTML Compressor Google Code</a>
					</li>
					<li>
						<a href="http://htmlcompressor.googlecode.com/svn/trunk/doc/com/googlecode/htmlcompressor/compressor/HtmlCompressor.html" target="_blank">HTML Compressor Java Docs</a>
					</li>
				</ul>
			</p>
		</div>
	</div>

</div>
<!--End sidebar-->
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			Super Menu!
		</div>
		<!--- Body --->
		<div class="body" id="mainBody">
		    <!---message box--->
			#getPlugin("MessageBox").renderit()#
			<!---main message area--->
			<p>
				Super Menus are super-simple to create. Simply select the pages or links that you'd like to add to a Super Menu, and then drag it into position. Once you give your Super Menu a name and save it, it will appear
                when creating and editing pages. Easy, right?
			</p>
            <!---start form--->
			#html.startForm(action="cbadmin.module.supermenu.home.saveSuperMenu",name="settingsForm")#
				<fieldset>
    				<legend>
    				    <img src="#prc.cbRoot#/includes/images/settings_black.png" alt="modifiers"/> <strong>Create Super Menu</strong>
                   	</legend>
					#html.textField( 
						name="supermenu_title", 
						label="Title:", 
						class="textfield width98", 
						required="required"
					)#
					#html.select( 
						name="supermenu_orientation", 
						label="Orientation:", 
						class="textfield width98", 
						required="required",
						options="Vertical,Horizontal"
					)#
					#html.hiddenField( 
						name="supermenu_menuid"
					)#
					#html.hiddenField( 
						name="supermenu_menucontent",
						value="[{label:'Money',path:'/money'}]"
					)#
				</fieldset>
				<!--- Submit --->
				<div class="actionBar center">
					#html.submitButton(value="Save Super Menu",class="buttonred",title="Save this Super Menu")#
				</div>
			#html.endForm()#
		</div>
	</div>
</div>
</cfoutput>