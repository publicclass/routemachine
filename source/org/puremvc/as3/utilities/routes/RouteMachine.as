package org.puremvc.as3.utilities.routes {	import org.puremvc.as3.interfaces.INotification;	import org.puremvc.as3.patterns.mediator.Mediator;	import flash.utils.describeType;	/**	 * Controls the applications state based on "routes".	 * 	 * @see Route					Handles the parsing of the route strings.	 * @see ApplicationRoutes		Where the routes are defined.	 * @see RoutedMediator			Convenience Mediator which avoids redundancy.	 * 	 * @author Robert Sköld, robert(at)publicclass.se	 */	public class RouteMachine extends Mediator {		public static const VERSION			: String = "0.9.1";		public static const NAME 			: String = "RouteMachine";				/** Sets the RouteMachine into DEBUG-mode if set to <code>true</code>. */		public static var VERBOSE 			: Boolean = false;		public static var TRACE_LOG			: Function = function( ...args ) : void { trace( args ); };		public static var TRACE_ERROR		: Function = function( ...args ) : void { ( args as Array ).unshift( "ERROR! " ); TRACE_LOG.apply( args ); };				/**		 * Setting for how the RouteMachine should handle failed CONTINUE calls.		 * 		 * <p>If <code>false</code> an error will be thrown when a CONTINUE has 		 * been attempted even though the application is not currently in a CANCELLED 		 * state.</p> 		 * 		 * <p>This should <i>only</i> be set to <code>true</code> if the application 		 * can handle the CANCELLING of an INTERRUPTED state properly.</p>		 * 		 * <p>If not the concequences of the ignored CONTINUE (i.e. moving along 		 * even though a CONTINUE is expected) will most likely result in a 		 * failed application.</p>		 */  		routes static var IGNORE_FAILED_CONTINUE : Boolean = false;				/**		 * Called to change the current route (a.k.a View state).		 * 		 * @example		 * 		 * <p>If we're at route <i>PAGE_A</i> ("/page/a") and want to go		 * to route <i>PAGE_B</i> ("/page/b") we have a route called 		 * <i>PAGE</i> ("/page/{name}") which will be used for both.</p>		 * 		 * <p>In <i>PAGE_A</i> we press a link to <i>PAGE_B</i> which calls:</p>		 * 		 * <code>sendNotification( RouteMachine.GOTO , { name: "b" } , ApplicationRoutes.PAGE );</code>		 * 		 */		public static const GOTO 			: String = NAME + "/note/goto";				/**		 * Call this to "pause" the ongoing transition.		 * 		 * @example		 * 		 * <p><strong>How to use the <code>RouteMachine.INTERRUPT</code> and <code>RouteMachine.CONTINUE</code>.</strong></p>		 * 		 * <p>Assuming we're currently in <code>ApplicationRoute.CURRENT</code> and has called		 * <code>sendNotification( RouteMachine.GOTO , {} , ApplicationRoutes.NEXT );</code></p>		 * 		 * <p>This also assumes the use of the <code>RoutedMediator</code>.</p>		 * 		 * <listing version="3.0"><pre>		 * override public function onExitingRoute( notification : RouteNotification ) : void {		 * 		switch( notification.fromRoute ) {		 * 			case ApplicationRoute.CURRENT:		 * 				currentView.addEventListener( Event.COMPLETE , onFadedOut );		 * 				currentView.fadeOut();		 * 				sendNotification( RouteMachine.INTERRUPT );		 * 				break;		 * 			// Handling of other routes here		 * } 		 * private function onFadedOut() : void {		 * 		currentView.removeEventListener( Event.COMPLETE , onFadedOut );		 * 		sendNotification( RouteMachine.CONTINUE );		 * }		 * </pre></listing>		 *  		 * @see RoutedMediator			 */		public static const INTERRUPT		: String = NAME + "/note/interrupt";				/**		 * Call this to abort a "paused" transition.		 * 		 * @example 		 * 		 * <p><strong>How to use the <code>RouteMachine.INTERRUPT</code> and <code>RouteMachine.CANCEL</code>.</strong></p>		 * 		 * <p>Assuming we're currently in <code>ApplicationRoute.PREVIOUS</code> and has called		 * <code>sendNotification( RouteMachine.GOTO , {} , ApplicationRoutes.CURRENT );</code></p>		 * 		 * <p>This also assumes the of the <code>RoutedMediator</code>.</p>		 * 		 * <listing version="3.0"><pre>		 * override public function onEnteringRoute( notification : RouteNotification ) : void {		 * 		switch( notification.toRoute ) {		 * 			case ApplicationRoute.CURRENT:		 * 				currentView.addEventListener( Event.COMPLETE , onContentLoaded );		 * 				currentView.addEventListener( IOErrorEvent.IO_ERROR , onContentLoadError );		 * 				currentView.loadContent();		 * 				sendNotification( RouteMachine.INTERRUPT );		 * 				break;		 * 			// Handling of other routes here		 * } 		 * private function onContentLoaded() : void {		 * 		currentView.removeEventListener( Event.COMPLETE , onContentLoaded );		 * 		currentView.removeEventListener( IOErrorEvent.IO_ERROR , onContentLoadError );		 * 		sendNotification( RouteMachine.CONTINUE );		 * }		 * private function onContentLoadError() : void {		 * 		currentView.removeEventListener( Event.COMPLETE , onContentLoaded );		 * 		currentView.removeEventListener( IOErrorEvent.IO_ERROR , onContentLoadError );		 * 		// Display a proper error message here, and go back to the previous route		 * 		sendNotification( RouteMachine.CANCEL );		 * }		 * </pre></listing>		 * 		 * @see #INTERRUPT		An example of interruption handling.		 */		public static const CANCEL			: String = NAME + "/note/cancel";				/**		 * Call this to continue a "paused" transition.		 * 		 * @see #INTERRUPT		An example of how to use interruption handling.		 * @see #CANCEL			An example of how to abort a transition.		 */		public static const CONTINUE		: String = NAME + "/note/continue";				/**		 * Called when trying to go to a Route that doesn't exist.		 * 		 * Mostly used by RouteMachine plugins like the <code>SWFAddressMediator</code>, 		 * which is why it's hiding behind a namespace.		 * 		 * @see SWFAddressMediator			Example usage of this notification.		 */		routes static const INVALID			: String = NAME + "/note/invalid";				public static const ENTERING 		: String = NAME + "/note/entering";		public static const EXITING 		: String = NAME + "/note/exiting";		public static const CHANGED 		: String = NAME + "/note/changed";		private var _currentRoute 			: Route;		private var _currentLocation 		: String;		private var _cached 				: Array = new Array();				private var _inTransition 			: Boolean;		private var _interrupted 			: Boolean;		private var _skipEnter 				: Boolean;		private var _skipExit 				: Boolean;		private var _continueData 			: Object;		private var _continueRoute 			: Route;				/**		 * @param routeClass				A class containing all the routes. By convention 		 * 									it's called "ApplicationRoutes".		 */		public function RouteMachine( routeClass : Class ) {			super( NAME, extractRoutes( routeClass ) );		}				/**		 * Listen to the RouteMachine interests.		 * 		 * @private		 */		override public function listNotificationInterests() : Array {			return [ RouteMachine.GOTO , RouteMachine.INTERRUPT , RouteMachine.CANCEL , RouteMachine.CONTINUE ];		}				/**		 * Part of the RouteMachine magic is done here.		 * 		 * @see #transitionTo		More detailed info of what happens when RouteMachine.GOTO has been called. 		 */		override public function handleNotification(notification : INotification) : void {			switch( notification.getName( ) ) {				case RouteMachine.GOTO:					if( _inTransition ) {						if( VERBOSE ) TRACE_LOG( NAME + "#GOTO ignored because currently in a transition." );						return;					}					var location : String = notification.getType();					var route : Route = getMatchingRoute( location );					if( !route ) {						if( VERBOSE ) TRACE_LOG( NAME + "#INVALID" );						sendNotification( RouteMachine.routes::INVALID, notification.getBody( ), notification.getType() );						return;					}					var data : Object = notification.getBody() || route.extractData( location );					if( isEmpty( data ) ) {						if( VERBOSE ) TRACE_LOG( NAME + "#GOTO data is currently empty, setting it to defaultData" );						data = route.defaultData;					}					if( VERBOSE ) TRACE_LOG( NAME + "#GOTO " , notification.getType( ) , route.toString() , data , route.defaultData , {body: notification.getBody() , extractData: route.extractData( location ) } );					transitionTo( route , data );					break;				case RouteMachine.INTERRUPT:					if( VERBOSE ) TRACE_LOG( NAME + "#INTERRUPT" );					_interrupted = true;					break;				case RouteMachine.CANCEL:					if( VERBOSE ) TRACE_LOG( NAME + "#CANCEL" );					reset();					break;				case RouteMachine.CONTINUE:					if( VERBOSE ) TRACE_LOG( NAME + "#CONTINUE " + ( ( _skipEnter ) ? "(from enter)" : ( _skipExit ) ? "(from exit)" : "error" ) , _continueRoute );					if( !_inTransition ) {						if( RouteMachine.routes::IGNORE_FAILED_CONTINUE ) {							if( VERBOSE ) TRACE_LOG( NAME + "#CONTINUE ignored because not currently in a transition." );							return;						} else {							throw new Error( "Need to CANCEL before continuing. Or use GOTO instead." );							}						}										transitionTo( _continueRoute, _continueData );					break;			}		}				/**		 * Makes the RouteMachine as good as new. 		 * And now the GOTO may be called again...		 */		protected function reset() : void {			_interrupted = false;			_continueRoute = null;			_continueData = null;			_skipEnter = _skipExit = false;			_inTransition = false;		}		/**		 * Does the magic of the RouteMachine.		 * 		 * <ol>		 * 	<li>Makes sure there's an actual change of route.</li>		 * 	<li>Tells all listeners that it's currently EXITING.</li>		 * 	<li>Checks for an interruption while EXITING and if there are holds the app in an INTERRUPTED state (which then waits for a CANCEL of CONTINUE notification).</li>		 * 	<li>Otherwise it moves on to the next route and tells all listeners that it has CHANGED.</li>		 * </ol>		 */		protected function transitionTo( nextRoute : Route , data : Object ) : void {						var nextLocation : String = nextRoute.injectData( data );						// Same location means it's the same, so skip it.			if( _currentLocation && _currentLocation == nextLocation ) {				reset(); // Allow it to try again...				if( VERBOSE ) TRACE_LOG( NAME + "#Skipping transition because it's the same as the current.", nextLocation, _currentLocation ); 				return;			}						// Clear the interrupt flag			_interrupted = false;			_inTransition = true;							// Exit the current  			if( VERBOSE ) TRACE_LOG( NAME + "#EXITING " + nextLocation ); 			if( _currentRoute != null && !_skipExit )				facade.notifyObservers( new RouteNotification( RouteMachine.EXITING , _currentRoute , _currentLocation , nextRoute , nextLocation , data ) );			_skipExit = true;						// Check to see whether the transition has been canceled			if( _interrupted ) {				if( VERBOSE ) TRACE_LOG( NAME + "#INTERRUPTED (during exit)" );				_continueRoute = nextRoute;				_continueData = data;				return;			}						if( VERBOSE ) TRACE_LOG( NAME + "#ENTERING " + nextLocation ); 			// Enter the next			if( !_skipEnter )				facade.notifyObservers( new RouteNotification( RouteMachine.ENTERING , _currentRoute , _currentLocation , nextRoute , nextLocation , data ) );			_skipEnter = true;						// Check to see whether the transition has been canceled			if( _interrupted ) {				if( VERBOSE ) TRACE_LOG( NAME + "#INTERRUPTED (during enter)" );				_continueRoute = nextRoute;				_continueData = data;				return;			}						// Allow the route to be changed again.			reset();									if( VERBOSE ) TRACE_LOG( NAME + "#CHANGED " + nextLocation, data ); 						// Send the notification configured to be sent when this specific state becomes current 			facade.notifyObservers( new RouteNotification( RouteMachine.CHANGED, _currentRoute , _currentLocation , nextRoute , nextLocation , data ) );						// Save the current route			_currentRoute = nextRoute;			_currentLocation = nextLocation;		}				/**		 * A simple method to check if an object is empty (i.e has no keys or properties).		 * 		 * @private		 */		private function isEmpty( obj : Object ) : Boolean {			if( !obj ) 				return true;			for( var key : String in obj ) 				return false;			return true;		}				/**		 * Checks each route to see if it matches the current location.		 * 		 * Results are cached to a route will only have to do the heavy work once.		 * 		 * @private		 */		protected function getMatchingRoute( location : String ) : Route {			if( _cached[ location ] ) 				return _cached[ location ];			for each( var route : Route in routes ) 				if( route.isLocation( location ) )					return _cached[ location ] = route;			return null;		}				/**		 * Goes through the routeClass sent in to the constructor and 		 * creates a Route object for every constant in that class.		 * 		 * @private		 */		protected function extractRoutes( routeClass : Class ) : Array {			var desc : XML = describeType( routeClass );			var routes : Array = [];			for each( var state : XML in desc.constant )				routes.push( new Route( routeClass[state.@name] ) );			return routes;		}				/**		 * All the routes found in the routeClass.		 * 		 * @private		 */		protected function get routes() : Array {			return viewComponent as Array;		}	}}