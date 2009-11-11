package se.publicclass.example.view {
	import se.publicclass.example.ApplicationRoutes;
	import se.publicclass.example.view.components.Menu;

	import org.puremvc.as3.utilities.routes.RouteMachine;
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

		override public function onExitingRoute(notification : RouteNotification) : void {
			menu.setActive( null );
			if( notification.toRoute != ApplicationRoutes.PORTFOLIO )
				menu.hideSubMenu();
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
					switch( String( notification.toData.page ) ) {
						case "1": menu.setActive( Menu.PORTFOLIO_1 ); break;
						case "2": menu.setActive( Menu.PORTFOLIO_2 ); break;
						case "3": menu.setActive( Menu.PORTFOLIO_3 ); break;
						default:
							menu.setActive( Menu.PORTFOLIO );
							menu.showSubMenu();
					}
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
					sendNotification( RouteMachine.GOTO, null, ApplicationRoutes.PORTFOLIO );
					break;
				case Menu.PORTFOLIO_1:
					sendNotification( RouteMachine.GOTO, { page: 1 }, ApplicationRoutes.PORTFOLIO );
					break;
				case Menu.PORTFOLIO_2:
					sendNotification( RouteMachine.GOTO, { page: 2 }, ApplicationRoutes.PORTFOLIO );
					break;
				case Menu.PORTFOLIO_3:
					sendNotification( RouteMachine.GOTO, { page: 3 }, ApplicationRoutes.PORTFOLIO );
					break;
				case Menu.CONTACT:
					sendNotification( RouteMachine.GOTO, {}, ApplicationRoutes.CONTACT );
					break;
				default:
					sendNotification( RouteMachine.GOTO, {}, ApplicationRoutes.START );
					break;
			}
		}

		protected function get menu() : Menu {
			return viewComponent as Menu;
		}
	}
}
