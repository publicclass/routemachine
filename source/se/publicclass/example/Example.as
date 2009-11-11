package se.publicclass.example {
	import se.publicclass.debug.Debug;
	import se.publicclass.debug.logger.TrazzleLogger;

	import org.puremvc.as3.utilities.routes.RouteMachine;

	import flash.display.Sprite;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	[SWF( backgroundColor="#CCCCCC" )]
	public class Example extends Sprite {
		public function Example() {
			
			Debug.addLogger(new TrazzleLogger());
			
			RouteMachine.VERBOSE = true;
			RouteMachine.TRACE_LOG = Debug.trace;
			RouteMachine.TRACE_ERROR = Debug.error;
			
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			ApplicationFacade.getInstance().startup( this );
		}
	}
}
