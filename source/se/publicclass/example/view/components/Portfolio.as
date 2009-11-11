package se.publicclass.example.view.components {
	import flash.text.TextField;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class Portfolio extends Content {
		
		[Embed(source="/../assets/portfolio/1.png")]
		private var Photo1 : Class;
		
		[Embed(source="/../assets/portfolio/2.png")]
		private var Photo2 : Class;
		
		[Embed(source="/../assets/portfolio/3.png")]
		private var Photo3 : Class;
		
		public function Portfolio( page : String ) {
			var txt : TextField;
			switch( page ) {
				case "1":
					addChild( new Photo1() );
					txt = createTextField( "<a href='http://www.lyubomirsergeev.com/' target='_blank'>Photos by: Lyubomir Sergeev</a>" );
					txt.y = 300;
					break;
				case "2":
					addChild( new Photo2() );
					txt = createTextField( "<a href='http://www.lyubomirsergeev.com/' target='_blank'>Photos by: Lyubomir Sergeev</a>" );
					txt.y = 300;
					break;
				case "3":
					addChild( new Photo3() );
					txt = createTextField( "<a href='http://www.lyubomirsergeev.com/' target='_blank'>Photos by: Lyubomir Sergeev</a>" );
					txt.y = 300;
					break;
				case "info": // Default
				default:
					txt = createTextField( "Fusce at ipsum vel diam ullamcorper " +
					"convallis. Morbi aliquet cursus lacus. Nunc nisi ligula, accumsan sit amet, " +
					"condimentum nec, ullamcorper a, lectus. Vestibulum ut lectus. Ut rutrum mi nec " +
					"lectus. Morbi quis nibh. Pellentesque congue, lorem quis porta tincidunt, " +
					"tellus tortor venenatis leo, vel porttitor massa massa nec dui. In interdum " +
					"euismod magna. In hac habitasse platea dictumst. Donec erat. Donec nunc ipsum, " +
					"lobortis ac, feugiat sit amet, vehicula et, tellus. Donec in lacus ac metus " +
					"condimentum gravida. Duis vehicula. In a neque in purus hendrerit molestie. " +
					"Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac " +
					"turpis egestas." , 400 );
					txt.selectable = true;
			}
			
			y = 120;
			x = 40;
		}
	}
}
