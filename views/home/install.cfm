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
		<!--- Body --->
		<div class="body nobg" id="mainBody">
		    <!---message box--->
			#getPlugin("MessageBox").renderit()#
			<p>
            	In order to use SuperMenu, a couple new tables need to be added to ContentBox. There are a few options for how to get everything configured properly:
            </p>
            <ol>
                <li>
                    <strong>Full Manual Install:</strong>
                    Manually create tables (via provided SQL scripts) and manually update SuperMenu entities to be persistent.
                </li>
                <li>
                    <strong>Partial-Automatic:</strong>
                    Manually create tables (via provided SQL scripts) but automatically setup SuperMenu entities.
                </li> 
            	<li>
            	    <strong>Full Automatic:</strong>
                    Let SuperMenu create the tables for you AND automatically make necessary file changes.
                </li>
            </ol>
			<!--- Navigation Bar --->
            <div>
                <div class="main_column">
					<!-- Content area that wil show the form and stuff -->
					<div class="panes_vertical">
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