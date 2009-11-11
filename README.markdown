RouteMachine
============

A PureMVC utility for actionscript 3 to handle view states based on a url-like string (called "route").

Huh?
----

The idea is that an application keeps it's view states based on the url it's at - "/city/stockholm/" would render different from "/city/newyork/" for example.

The routes of the application is, by convention (not required), kept in _ApplicationRoutes_ as constants which defines the routes and the variables that might exist in them, the example above for instance could be defined as:

	public static const CITY : String = "/city/{city}/";
	
Which would make either "stockholm" or "newyork" into a variable part of the route.

An example of how a ApplicationRoutes might look like can be found [http://github.com/publicclass/routemachine/blob/master/source/se/publicclass/example/ApplicationRoutes.as](here).


Ok, so how is this used?
------------------------

Besides setting up the view states of the application itself as constants in your ApplicationRoutes you then to change the view state you send a notification to the RouteMachine like this:

	sendNotification( RouteMachine.GOTO , { city: "newyork" } , ApplicationRoutes.CITY );
	
