package se.publicclass.example.view.components {
	import flash.text.TextField;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class Start extends Content {
		public function Start() {
			var txt : TextField = createTextField( "Quisque libero mauris, " +
			"ornare in, faucibus ut, facilisis nec, quam. Mauris quis felis " +
			"ac nisl laoreet adipiscing. Nunc libero. Vivamus nec libero. " +
			"Fusce neque odio, interdum a, pharetra sit amet, mattis non, nisl. " +
			"Donec quis metus et pede gravida pharetra. Class aptent taciti " +
			"sociosqu ad litora torquent per conubia nostra, per inceptos " +
			"hymenaeos. Sed tincidunt ipsum ut mi. Sed tincidunt porta ipsum. " +
			"Curabitur sem risus, egestas et, ultricies sed, sollicitudin a, " +
			"nulla. Praesent eget lectus sed erat commodo ultrices. Donec " +
			"purus enim, nonummy ut, iaculis sit amet, convallis a, est. Mauris " +
			"consequat, elit et scelerisque posuere, dui est convallis quam, " +
			"vitae dignissim tortor odio consectetuer leo. Donec turpis velit, " +
			"varius id, tincidunt sed, sodales id, eros." , 400 );
			txt.selectable = true;
			
			y = 120;
			x = 40;
		}
	}
}
