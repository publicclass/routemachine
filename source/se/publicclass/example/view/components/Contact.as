package se.publicclass.example.view.components {
	import flash.text.TextField;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class Contact extends Content {
		public function Contact() {
			var txt : TextField = createTextField( "Nulla nec nunc id urna mollis " +
			"molestie. Suspendisse potenti. Aliquam vitae dui. In semper ante eu " +
			"massa. Praesent quis nunc. Vestibulum tristique tortor. Duis feugiat. " +
			"Nam pharetra vulputate augue. Sed laoreet. Mauris id orci ac nisl " +
			"consectetuer sollicitudin. Donec eu ante at velit cursus gravida. " +
			"Suspendisse arcu." , 400 );
			txt.selectable = true;
			
			y = 120;
			x = 40;
		}
	}
}
