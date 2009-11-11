package se.publicclass.example {
	import se.publicclass.example.command.StartupCommand;

	import org.puremvc.as3.patterns.facade.Facade;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class ApplicationFacade extends Facade {

		public static const STARTUP : String = "startup";

		public static function getInstance() : ApplicationFacade {
			if ( instance == null ) instance = new ApplicationFacade( );
			return instance as ApplicationFacade;
		}
		
		override protected function initializeController() : void {
			super.initializeController( );
			registerCommand( ApplicationConstants.STARTUP, StartupCommand );
		}

		public function startup( app : Example ) : void {
			sendNotification( ApplicationConstants.STARTUP , app );
		}
	}
}