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
		private var _ignoreChange : Boolean = false;

		public function SWFAddressMediator( initialRoute : String ) {
			super( NAME, initialRoute );
		}

		override public function listNotificationInterests() : Array {
			return super.listNotificationInterests( ).concat( [ RouteMachine.INVALID ] );
		}

		override public function handleNotification(notification : INotification) : void {
			switch( notification.getName( ) ) {
				case RouteMachine.INVALID:
					if( initialRoute )
						sendNotification( RouteMachine.GOTO, null, initialRoute );
					break;
			}
			super.handleNotification( notification );
		}

		override public function onRegister() : void {
			SWFAddress.addEventListener( SWFAddressEvent.CHANGE, onAddressChange );
			// TODO Make sure this goto doesn't mess with a direct deep link
			sendNotification( RouteMachine.GOTO , {}, initialRoute );
		}

		override public function onRemove() : void {
			SWFAddress.removeEventListener( SWFAddressEvent.CHANGE, onAddressChange );
		}

		override public function onChangedRoute( notification : RouteNotification ) : void {
			changeAddress( notification.toRoute );
		}
		
		private function changeAddress( location : String ) : void {
			if( RouteMachine.DEBUG )  trace( "RouteMachine#From: " + _currentRoute , "To: " + location );
			if( location == _currentRoute ) return;
			_ignoreChange = true;
			SWFAddress.setValue( location );
			_ignoreChange = false;
		}
		
		private function onAddressChange(e : SWFAddressEvent) : void {	
			if( _ignoreChange ) return;
			sendNotification( RouteMachine.GOTO , {}, e.value );
		}
		
		public function get initialRoute() : String {
			return viewComponent as String;
		}
		
	}
}
