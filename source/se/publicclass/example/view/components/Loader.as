package se.publicclass.example.view.components {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
	 * @author Robert Sköld
	 */
	public class Loader extends Content {
		private var _loading : TextField;
		private var _timer : Timer;
		private var _counter : int = 0;

		public function Loader() {
			_loading = createTextField( "<h3>Loading</h3>" );
			
			_timer = new Timer( 250 , 6 );
			_timer.addEventListener( TimerEvent.TIMER , updateLoaderText );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE , doneLoading );
			_timer.start();
			
			y = 120;
			x = 40;
		}

		private function updateLoaderText(event : TimerEvent) : void {
			var dots : String = "";
			for( var d : int = ++_counter % 3; d > -1 ; --d )
				dots += ".";
			_loading.htmlText = "<body><h3>Loading" + dots + "</h3>";
		}

		private function doneLoading(event : TimerEvent) : void {
			_timer.removeEventListener( TimerEvent.TIMER , updateLoaderText );
			_timer.removeEventListener( TimerEvent.TIMER_COMPLETE , doneLoading );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
	}
}
