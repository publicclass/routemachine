package se.publicclass.example.view.components {
	import flash.events.Event;
	import flash.display.Sprite;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class Background extends Sprite {
		public function Background() {
			addEventListener( Event.ADDED_TO_STAGE , onAddedToStage );
		}
		
		private function onAddedToStage(event : Event) : void {
			stage.addEventListener( Event.RESIZE , onStageResized );
			onStageResized();
		}
		
		private function onStageResized(event : Event = null ) : void {
			x = stage.stageWidth * .5 - 240;
			draw();
		}
		
		public function draw() : void {
			graphics.beginFill( 0xFFFFFF , 1 );
			graphics.drawRect(0, 0, 480, stage.stageHeight );
		}
	}
}
