package se.publicclass.example.view {
	import se.publicclass.example.ApplicationRoutes;
	import se.publicclass.example.Example;
	import se.publicclass.example.view.components.*;

	import com.flashdynamix.motion.TweensyZero;

	import org.puremvc.as3.utilities.routes.RouteMachine;
	import org.puremvc.as3.utilities.routes.RouteNotification;
	import org.puremvc.as3.utilities.routes.RoutedMediator;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class ApplicationMediator extends RoutedMediator {
		
		public static var NAME : String = "ApplicationMediator";
		
		private var _bg : DisplayObjectContainer;
		private var _content : DisplayObject;

		public function ApplicationMediator( viewComponent : Example = null ) {
			super( NAME, viewComponent );
		}

		override public function onExitingRoute(notification : RouteNotification) : void {
			if( _content )
				TweensyZero.to( _content , { alpha: 0 } , .3 , null , 0 , null , _bg.removeChild , [ _content ] );
		}

		override public function onEnteringRoute(notification : RouteNotification) : void {
			// Pretending to load something to show off the INTERRUPT/CONTINUE feature.
			var loader : Loader = _bg.addChild( new Loader() ) as Loader;
			loader.addEventListener( Event.COMPLETE , onLoadingComplete );
			sendNotification( RouteMachine.INTERRUPT );
		}

		private function onLoadingComplete(event : Event) : void {
			var loader : Loader = event.currentTarget as Loader;
			loader.removeEventListener( Event.COMPLETE , onLoadingComplete );
			if( loader && _bg.contains( loader ) )
				_bg.removeChild( loader );
			sendNotification( RouteMachine.CONTINUE );
		}

		override public function onChangedRoute( notification : RouteNotification ) : void {
			switch( notification.toRoute ) {
				case ApplicationRoutes.ABOUT:
					_content = _bg.addChild( new About() );
					break;
				case ApplicationRoutes.CONTACT:
					_content = _bg.addChild( new Contact() );
					break;
				case ApplicationRoutes.START:
					_content = _bg.addChild( new Start() );
					break;
				case ApplicationRoutes.PORTFOLIO:
					_content = _bg.addChild( new Portfolio( notification.toData.page ) );
					break;
			}
			TweensyZero.from( _content , { alpha: 0 } , .2 );
		}

		override public function onRegister() : void {
			_bg = example.addChild( new Background() ) as DisplayObjectContainer;
			facade.registerMediator( new MenuMediator( _bg.addChild( new Menu() ) ) );
		}

		protected function get example() : Example {
			return viewComponent as Example;
		}
	}
}
