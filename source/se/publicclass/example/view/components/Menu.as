package se.publicclass.example.view.components {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class Menu extends Content {
		
		public static const ABOUT 			: String = "ABOUT";
		public static const PORTFOLIO 		: String = "PORTFOLIO";
		public static const CONTACT 		: String = "CONTACT";
		
		private var _items : Array = new Array( );
		private var _active : String;

		public function Menu() {
			var header : TextField = createTextField( "<h1>SWFAddress Website</h1>" );
			addChild( header );
			
			var item : DisplayObject;
			var items : Sprite = new Sprite();
			items.y = header.height;
			item = createMenuItem( "ABOUT" );
			item.x = items.width;
			items.addChild( item );
			item = createMenuItem( "PORTFOLIO" );
			item.x = items.width;
			items.addChild( item );
			item = createMenuItem( "CONTACT" );
			item.x = items.width;
			items.addChild( item );
			addChild( items );
			
			// TODO Add the submenu of the portfolio
		}
		
		public function setActive( label : String ) : void {
			var item : Sprite = _items[label] as Sprite;
			if( !item ) {
				setInactive( _active );
				return;
			}
			var txt : TextField = item.getChildAt(0) as TextField;
			txt.htmlText = "<body><a class='selected'>" + label + "</a>";
			setInactive( _active );
			_active = label;
		}
		
		public function setInactive( label : String ) : void {
			var item : Sprite = _items[label] as Sprite;
			if( !item ) return;
			var txt : TextField = item.getChildAt(0) as TextField;
			txt.htmlText = "<body><a>" + label + "</a>";
		}
		
		private function createMenuItem( label : String ) : Sprite {
			var item : Sprite = new Sprite();
			item.name = label;
			item.buttonMode = true;
			item.mouseChildren = false;
			item.addChild( createTextField( label ) );
			_items[ label ] = item;
			return item as Sprite;
		}
	}
}
