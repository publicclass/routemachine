package se.publicclass.example.view {
	import org.puremvc.as3.utilities.routes.RoutedMediator;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class AboutMediator extends RoutedMediator {
		
		public static const NAME : String = "AboutMediator";
		
		public function AboutMediator( viewComponent : Object = null ) {
			super( NAME, viewComponent );
		}
	}
}
