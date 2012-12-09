SuperMenu
=========

A Custom Menu Module for ContentBox
===================================
Super Menu is all about giving you control over your site's menus. While it's nice to have some menus be auto-generated, Super Menu gives you the control to create your own menus and use them however--and wherever--you want.

Whether you are creating a customized global site navigation, or a page-specific mini-menu, Super Menu makes it easy!

Zones
=====
Zones are ways of identifying placeholders for your menus. You can use zones in two ways:

* Specify a default zone for a given menu. This will render the menu for that zone anywhere where you specify that zone in your layouts or views.
* Override a zone per page. When editing a page, you can select the menu that you would like to apply to the specified zone, regardless of any prior configuration in the view.
(See Usage for examples)

Menus
=====
The beauty of creating menus with Super Menu is that they are as flexible as you need them to be. You can do the following in your menu:

* Nest content in any structure you'd like with a super-easy drag-n-drop interface
* Include published pages in any order you want
* Include blog posts in any order you want
* Make your own custom links!
(See Usage for examples)

Usage
=====
There are several ways to use Super Menu, all with complete flexibility in mind.

*Zones with Default Menus*
One of the most flexible ways to use Super Menu is to create a zone "placeholder" and then associate it with a menu. To do this:

* First, create a zone (e.g., "Sidebar")
* Next, adjust your layout with the code to embed Super Menu:
getPlugin( plugin="SuperMenu", module="SuperMenu" ).renderIt( zone="Sidebar" )
* Finally, edit one of your menus and select "Sidebar" as the zone.

The menu should now appear in all pages where the layout with the plugin code is used! And better yet, if you ever change the menu that is associated to the zone, the new menu content will be instantly reflected in your rendered content.

*Menu Slug*
Of course, you don't have to use zones if you don't want to. You can also simply plunk a menu into a layout or view by using the menu's "slug". To do this:

* First, create your custom menu (e.g., slug="custom-menu")
* Next, add the folowing to your layout:
getPlugin( plugin="SuperMenu", module="SuperMenu" ).renderIt( slug="custom-menu" )
* As with the zone example, this will now render the specified menu (by slug) where the plugin code is used.

*Page Overrides for Zones*
One powerful option with Super Menu is ability to override zone defaults at a page level. To do this:

* In the desired page, select the menu that you'd like to use for the selected zone.
* Save the page.
You should now see whatever menu you selected when editing the page, regardless of what the menu default for the zone might be.