/// ZenTutorial.CustomComponents.MenuComposite
Class ZenTutorial.CustomComponents.MenuComposite Extends %ZEN.Component.composite
{

/// This is the XML namespace for this component.
Parameter NAMESPACE = "http://www.intersystems.com/ZenTutorial";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">

/*
 * Styles for components in this composite component
 *
 */
.title {
	background: #C5D6D6;
	color: black;
	font-size: 1.5em;
	font-weight: bold;
	padding: 5px;
	border-bottom: 1px solid black;
	text-align: center;
}

/* 
 * Default style overrides
 */
/* Override default menu item style */
a.menuItem {
	font-size: 0.9em;
	color: black;
}

a.menuItemDisabled {
	font-size: 0.9em;
	color: black;
}
</style>
}

/// Contents of this composite component.
XData Contents
{
<composite>
<html id="title" enclosingClass="title">ZEN Contacts</html>
<hmenu width="100%">
<menuItem id="m1" caption="Home" link="ZenTutorial.HomePage.cls" help="Go to display page" />
<menuItem id="m2" caption="TBA" link="" help="To Be Added" />
<menuItem id="m3" caption="TBA" link="" help="To Be Added" />
</hmenu>
</composite>
}

}
