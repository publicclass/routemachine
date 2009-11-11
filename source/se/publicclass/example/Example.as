package se.publicclass.example {
	import flash.display.Sprite;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	[SWF( backgroundColor="#CCCCCC" )]
	public class Example extends Sprite {
		public function Example() {
			stage.scaleMode = "noScale";
			stage.align = "TL";
			ApplicationFacade.getInstance().startup( this );
		}
	}
}
