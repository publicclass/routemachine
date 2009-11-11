package se.publicclass.example.view.components {
	import flash.text.TextField;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class About extends Content {
		public function About() {
			var txt : TextField = createTextField( "Suspendisse vitae nibh. Curabitur laoreet auctor velit. " +
			"Class aptent taciti sociosqu ad litora torquent per conubia nostra, per " +
			"inceptos hymenaeos. Etiam tortor. Sed porta diam vel augue. Praesent sollicitudin " +
			"blandit lectus. Duis interdum, arcu vel convallis porttitor, magna tellus auctor " +
			"odio, ac lobortis nulla orci vel lacus. Morbi tortor justo, sagittis et, interdum " +
			"eget, placerat et, metus. Ut quis massa. Phasellus leo nulla, tempus sed, mattis " +
			"mattis, sodales in, urna. Fusce in purus. Curabitur a lorem quis dolor ultrices " +
			"egestas. Maecenas dolor elit, tincidunt vel, tempor ac, imperdiet a, quam. Nullam " +
			"justo. Morbi sagittis. Ut suscipit pulvinar ante. Cras eu tortor. In nonummy, erat " +
			"eget aliquet molestie, sapien eros pretium lorem, eu pretium urna neque eu purus. " +
			"Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos " +
			"hymenaeos. Pellentesque scelerisque lorem ut ligula." , 400 );
			txt.selectable = true;
			
			y = 120;
			x = 40;
		}
	}
}
