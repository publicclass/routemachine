package org.puremvc.as3.utilities.routes {
	import flash.utils.describeType;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * Convenience Mediator for RouteMachine enabled Mediators.
	 * 
	 * Automatically listens to route changes if those methods are
	 * available in the Mediator.
	 * 
	 * @example
	 * 
	 * Writing a Mediator with routes is now as simple as:
	 * 
	 * <listing version="3.0"><pre>
	 * package {
	 * 		public class ExampleMediator extends RoutedMediator {
	 * 		
	 * 			public function ExampleMediator( name : String , viewComponent : ExampleView ) {
	 * 				super( name , viewComponent );
	 * 			}
	 * 			
	 * 			override public function onEnteringRoute( notification : RouteNotification ) : void {
	 * 				switch( notification.toRoute ) {
	 * 					case ApplicationRoutes.EXAMPLE:
	 * 						exampleView.animateIn();
	 * 						break;	
	 * 				}
	 * 			}
	 * 			
	 * 			override public function onExitingRoute( notification : RouteNotification ) : void {
	 * 				switch( notification.fromRoute ) {
	 * 					case ApplicationRoutes.EXAMPLE:
	 * 						exampleView.animateOut();
	 * 						break;	
	 * 				}
	 * 			}
	 * 			
	 * 			public function get exampleView() : ExampleView {
	 * 				return viewComponent as ExampleView;
	 * 			}
	 * 			
	 * 		}	
	 * }
	 * </pre></listing>
	 * 
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class RoutedMediator extends Mediator {
		private var _notificationInterests : Array;
		
		public function RoutedMediator( name : String , viewComponent : Object = null ) {
			super( name , viewComponent );
		}

		/**
		 * Using flash.utils.describeType() it checks if the Mediator which subclasses
		 * RoutedMediator overrides any of the onRoute methods and will then call those
		 * when a RouteMachine.EXITING, RouteMachine.ENTERING or RouteMachine.CHANGED
		 * notification has been sent.
		 * 
		 * NOTE: Don't forget to call super.listNotificationInterests() if you override 
		 * this method or the reflected route events will not work.
		 * 
		 */
		override public function listNotificationInterests() : Array {
			if( !_notificationInterests ) {
				_notificationInterests = new Array();
				var desc : XML = describeType( this );
				if( desc.method.( @name == "onExitingRoute" && @declaredBy != "org.puremvc.as3.utilities.routes::RoutedMediator" ).length() > 0 ) {
					_notificationInterests.push( RouteMachine.EXITING );
				}
				if( desc.method.( @name == "onEnteringRoute" && @declaredBy != "org.puremvc.as3.utilities.routes::RoutedMediator" ).length() > 0 ) {
					_notificationInterests.push( RouteMachine.ENTERING );
				}
				if( desc.method.( @name == "onChangedRoute" && @declaredBy != "org.puremvc.as3.utilities.routes::RoutedMediator" ).length() > 0 ) {
					 _notificationInterests.push( RouteMachine.CHANGED );
				}
			}
			return _notificationInterests;
		}
		
		override public function handleNotification( notification : INotification ) : void {
			switch( notification.getName( ) ) {
				case RouteMachine.EXITING:
					onExitingRoute( notification as RouteNotification );
					break;
				case RouteMachine.ENTERING:
					onEnteringRoute( notification as RouteNotification );
					break;
				case RouteMachine.CHANGED:
					onChangedRoute( notification as RouteNotification );
					break;
			}
		}
		
		/**
		 * Override this to get notified when a route is EXITING.
		 * 
		 * NOTE: notification.fromRoute is probably the most interesting.
		 */
		public function onExitingRoute( notification : RouteNotification ) : void {}
		
		/**
		 * Override this to get notified when a route is ENTERING.
		 * 
		 * NOTE: notification.toRoute is probably the most interesting.
		 */
		public function onEnteringRoute( notification : RouteNotification ) : void {}
		
		/**
		 * Override this to get notified when a route has CHANGED.
		 * 
		 * NOTE: notification.toData is probably the most interesting as it may 
		 * contain arbitrary data (things that can't be in the address bar).
		 */
		public function onChangedRoute( notification : RouteNotification ) : void {}
		
	}
}
