package se.publicclass.example {
	import flash.display.Sprite;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class Example extends Sprite {
		public function Example() {
			stage.scaleMode = "noScale";
			stage.align = "TL";
			var facade : ApplicationFacade = ApplicationFacade.getInstance();
			facade.startup( this );
		}
	}
}
