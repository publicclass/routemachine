package se.publicclass.example.view {
	import org.puremvc.as3.utilities.routes.RouteMachine;
	import se.publicclass.example.ApplicationRoutes;
	import se.publicclass.example.view.components.Menu;

	import org.puremvc.as3.utilities.routes.RouteNotification;
	import org.puremvc.as3.utilities.routes.RoutedMediator;

	import flash.events.MouseEvent;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class MenuMediator extends RoutedMediator {
		
		public static const NAME : String = "MenuMediator";
		
		public function MenuMediator( viewComponent : Object = null ) {
			super( NAME, viewComponent );
		}

		override public function onChangedRoute(notification : RouteNotification) : void {
			switch( notification.toRoute ) {
				case ApplicationRoutes.START:
					menu.setActive( null );
					break;
				case ApplicationRoutes.ABOUT:
					menu.setActive( Menu.ABOUT );
					break;
				case ApplicationRoutes.PORTFOLIO:
					menu.setActive( Menu.PORTFOLIO );
					// TODO Check for sub page
					break;
				case ApplicationRoutes.CONTACT:
					menu.setActive( Menu.CONTACT );
					break;
			}
		}

		override public function onRegister() : void {
			menu.addEventListener( MouseEvent.CLICK, onMenuItemClick );
		}
		
		private function onMenuItemClick(event : MouseEvent) : void {
			switch( event.target.name ) {
				case Menu.ABOUT:
					sendNotification( RouteMachine.GOTO, {}, ApplicationRoutes.ABOUT );
					break;
				case Menu.PORTFOLIO:
					sendNotification( RouteMachine.GOTO, {}, ApplicationRoutes.PORTFOLIO );
					break;
				case Menu.CONTACT:
					sendNotification( RouteMachine.GOTO, {}, ApplicationRoutes.CONTACT );
					break;
			}
		}

		protected function get menu() : Menu {
			return viewComponent as Menu;
		}
	}
}
