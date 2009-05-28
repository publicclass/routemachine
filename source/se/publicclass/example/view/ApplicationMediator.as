package se.publicclass.example.view {
	import se.publicclass.example.Example;
	import se.publicclass.example.view.components.Background;
	import se.publicclass.example.view.components.Menu;

	import org.puremvc.as3.utilities.routes.RoutedMediator;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class ApplicationMediator extends RoutedMediator {
		
		public static var NAME : String = "ApplicationMediator";
		
		public function ApplicationMediator( viewComponent : Example = null ) {
			super( NAME, viewComponent );
		}

		override public function onRegister() : void {
			var bg : DisplayObjectContainer = example.addChild( new Background() ) as DisplayObjectContainer;
			facade.registerMediator( new MenuMediator( bg.addChild( new Menu() ) ) );
			
		}

		protected function get example() : Example {
			return viewComponent as Example;
		}
	}
}
