package org.puremvc.as3.utilities.routes {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;

	import org.puremvc.as3.interfaces.INotification;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class SWFAddressMediator extends RoutedMediator {
		
		public static const NAME : String = "SWFAddressMediator";
		
		private var _currentRoute : String;

		public function SWFAddressMediator( initialRoute : String ) {
			super( NAME, initialRoute );
		}

		override public function listNotificationInterests() : Array {
			return super.listNotificationInterests( ).concat( [ RouteMachine.routes::INVALID ] );
		}

		override public function handleNotification(notification : INotification) : void {
			switch( notification.getName( ) ) {
				case RouteMachine.routes::INVALID:
					if( initialRoute )
						sendNotification( RouteMachine.GOTO, null, initialRoute );
					break;
			}
			super.handleNotification( notification );
		}

		override public function onRegister() : void {
			SWFAddress.addEventListener( SWFAddressEvent.INIT, onAddressInit );
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE, onAddressChange );
		}
		
		private function onAddressInit(event : SWFAddressEvent) : void {
			sendNotification( RouteMachine.GOTO , null, event.value || initialRoute );
		}
		
		private function onAddressChange(event : SWFAddressEvent) : void {
			if( RouteMachine.DEBUG )  RouteMachine.DEBUG_LOG( "SWFAddressMediator#onAddressChange: Current: " + _currentRoute , "To: " + event.value );
			
			// Only sends a cancel if the application won't throw errors
			if( RouteMachine.routes::IGNORE_FAILED_CONTINUE ) 
				sendNotification( RouteMachine.CANCEL );
				 
			sendNotification( RouteMachine.GOTO , null, event.value );
		}

		override public function onRemove() : void {
			SWFAddress.removeEventListener( SWFAddressEvent.INIT, onAddressInit );
			SWFAddress.removeEventListener( SWFAddressEvent.CHANGE, onAddressChange );
		}

		override public function onChangedRoute( notification : RouteNotification ) : void {
			changeAddress( notification.routes::nextRoute.injectData( notification.toData ) );
		}
		
		private function changeAddress( location : String ) : void {
			if( RouteMachine.DEBUG )  RouteMachine.DEBUG_LOG( "SWFAddressMediator#changeAddress: From: " + _currentRoute , "To: " + location );
			if( location == _currentRoute ) return;
			SWFAddress.removeEventListener( SWFAddressEvent.CHANGE, onAddressChange );
			SWFAddress.setValue( location );
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE, onAddressChange );
			_currentRoute = location;
		}

		public function get initialRoute() : String {
			return viewComponent as String;
		}
		
	}
}
