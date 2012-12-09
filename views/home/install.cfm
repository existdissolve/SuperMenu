<cfoutput>
#renderView( "viewlets/assets" )#
#renderView( view="viewlets/sidebar",args={page="about"} )#
<!--============================Main Column============================-->
<div class="main_column">
	<div class="box">
		<!--- Body Header --->
		<div class="header">
			Super Menu Installation
		</div>
		<!--- Body --->
		<div class="body nobg" id="mainBody">
		    <!---message box--->
			#getPlugin("MessageBox").renderit()#
			<p>
            	In order to use Super Menu, a couple new tables need to be added to ContentBox. There are a few options for how to get everything configured properly:
            </p>
            <ol>
                <li>
                    <strong>Full Manual Install:</strong>
                    Manually create tables (via provided SQL scripts) and manually update Super Menu entities (SuperMenu/model/orm) to be persistent. 
                    After you've done this, simply reload ORM and you should be ready to roll.
                </li>
                <li>
                    <strong>Partial-Automatic:</strong>
                    Manually create tables (via provided SQL scripts) but automatically setup Super Menu entities.
                </li> 
            	<li>
            	    <strong>Full Automatic:</strong>
                    Let Super Menu create the tables for you AND automatically make necessary file changes.
                </li>
            </ol>
			<!--- Navigation Bar --->
            <div>
                <div class="main_column">
					<!-- Content area that wil show the form and stuff -->
					<div class="panes_vertical">
					    #getPlugin( "MessageBox" ).renderMessage( "warning", "You should really consider backing up your files and data before proceeding!" )#
                        <!---start form--->
            			#html.startForm( action="cbadmin.module.supermenu.home.install", name="settingsForm", id="supermenu_form" )#
            				<fieldset>
                				<legend>
                				    <img src="#prc.cbRoot#/includes/images/settings_black.png" alt="modifiers"/> 
                                    <strong>Pick Your Poison</strong>
                               	</legend>
            					<input type="radio" name="installtype" value="partial" /> Update Entity Files  (Make sure tables exist!!!)<br />
                                <input type="radio" name="installtype" value="auto" /> Create Tables & Update Entity Files<br /><br />
                      			#html.submitbutton(value="Let's Do It!",class="buttonred",title="Proceed with Last Installation Steps")#
            				</fieldset>
                    	#html.endForm()#
            		</div>
            	</div>
    		</div>
		</div>
	</div>
</div>
</cfoutput>