RouteMachine
============

A [http://puremvc.org](PureMVC) utility for ActionScript 3 to handle view states based on a url-like string (called "route").

Huh?
----

The idea is that an application keeps it's view states based on the url it's at - "/city/stockholm/" would render different from "/city/newyork/" for example.

The routes of the application is, by convention (not required), kept in _ApplicationRoutes_ as constants which defines the routes and the variables that the routes may include, the example above for instance could be defined as:

	public static const CITY : String = "/city/{city}/";
	
Which, in this example, would make either "stockholm" or "newyork" into a variable part of the route.

An example of how a ApplicationRoutes might look like can be found [here](http://github.com/publicclass/routemachine/blob/master/source/se/publicclass/example/ApplicationRoutes.as).


Ok, so how is this used?
------------------------

Besides setting up the view states of the application itself as constants in your ApplicationRoutes, to change the view state, send a notification to the RouteMachine like this:

	sendNotification( RouteMachine.GOTO , { city: "newyork" } , ApplicationRoutes.CITY );
	
And then the views (Mediators) which would be interested in that particular route would simply listen to either a _RouteMachine.EXITING_, _RouteMachine.ENTERING_ or _RouteMachine.CHANGED_ notification to reflect that view state and update it's view components properly based on the variables which was sent with the route.

Usually then we get everything started with a SimpleCommand with these two lines:

	facade.registerMediator( new RouteMachine( ApplicationRoutes ) );
	sendNotification( RouteMachine.GOTO , {} , ApplicationRoutes.START );
	
The first line initialized the whole machinery and the second one kicks off the application by going to the _ApplicationRoutes.START_-route. 

To see more what's available [I've generated some docs](https://publicclass.s3.amazonaws.com/routemachine/docs/index.html) for your reading pleasure.


So, URLs as in SWFAddress?
--------------------------

Objviously there's a bonus in using url-like strings to represent a view state: very simple SWFAddress integration. Pretty much all you need to do to keep the user updated on the current view state is that the second line in the SimpleCommand above needs to be replaced with this:

	facade.registerMediator( new SWFAddressMediator( ApplicationRoutes.START ) );
	
It sets up proper listeners to the exiting and entering and then keeps address bar updated with the current route, and the other way around of course.


I find it very repetitive, any suggestions?
--------------------------------------------

There's a convenience Mediator, the _RoutedMediator_, which you can extend which then handles the listening to the proper notifications by overriding the _onEnteringRoute_, _onExitingRoute_ and _onChangedRoute_ methods. 

Here's a very simple example of what I mean from the docs:

	package {
		public class ExampleMediator extends RoutedMediator {
			
			public function ExampleMediator( name : String , viewComponent : ExampleView ) {
				super( name , viewComponent );
			}
				
			override public function onEnteringRoute( notification : RouteNotification ) : void {
				switch( notification.toRoute ) {
					case ApplicationRoutes.EXAMPLE:
						exampleView.animateIn();
						break;	
				}
			}
				
			override public function onExitingRoute( notification : RouteNotification ) : void {
				switch( notification.fromRoute ) {
					case ApplicationRoutes.EXAMPLE:
						exampleView.animateOut();
						break;	
				}
			}
				
			public function get exampleView() : ExampleView {
				return viewComponent as ExampleView;
			}
				
		}	
	}

You can of course still use `listNotificationInterests()` and `handleNotification()` as usual, but the routing parts is already taken care of.

It's actually used by the _SWFAddressMediator_ for its routing magic. 


This sounds kind of interesting, is there a more complete example of WTF you're talking about?
----------------------------------------------------------------------------------------------

In this repository you'll find a (quite lazy) port of the [SWFAddress demo site](http://www.asual.com/swfaddress/samples/seo/) which is very simple (but complete) and shows how the routing stuff works. Don't mind the rest though, I really just wanted something up and running. I put up an example [here](https://publicclass.s3.amazonaws.com/routemachine/index.html).


I looked at the example and saw some _RouteMachine.INTERRUPT_ notifications, what are those?
---------------------------------------------------------------------------------------------

Ah, I thought you'd never ask! Well, from my experience, most of the times the transitions between two view states would take longer than a simple hide/show transition. It could be because something has to be loaded, some very cool animations that take "forever" etc. 

So while those things are running along we can tell send the RouteMachine and _RouteMachine.INTERRUPT_ notification to tell it to wait until further notice. So when the load of that asset has completed (which is SOOO important for that next view state) we tell the RouteMachine _RouteMachine.CONTINUE_ and the transitions to the next view state will continue.

However, sometimes things doesn't go as desired. So let's say that load didn't work very well (we received an ErrorEvent from Loader) in that case, since the loading of that asset was so important, we instead send the RouteMachine a _RouteMachine.CANCEL_ notification to tell it to give up on that transition and let you get on with another one, like navigating to the _ApplicationRoutes.EPIC\_LOADING\_FAILURE_ route instead. 
