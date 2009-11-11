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
		public static const PORTFOLIO_1		: String = "/ 1";
		public static const PORTFOLIO_2		: String = "/ 2";
		public static const PORTFOLIO_3		: String = "/ 3";
		public static const CONTACT 		: String = "CONTACT";
		
		private var _items : Array = new Array( );
		private var _active : String;
		private var _subitems : Sprite;

		public function Menu() {
			var header : Sprite = new Sprite();
			header.addChild( createTextField( "<h1>SWFAddress Website</h1>" ) );
			header.buttonMode = true;
			header.mouseChildren = false;
			addChild( header );
			
			var item : DisplayObject;
			var items : Sprite = new Sprite();
			items.y = header.height;
			item = createMenuItem( ABOUT );
			item.x = items.width;
			items.addChild( item );
			item = createMenuItem( PORTFOLIO );
			item.x = items.width;
			items.addChild( item );
			item = createMenuItem( CONTACT );
			item.x = items.width;
			items.addChild( item );
			addChild( items );
			
			_subitems = new Sprite();
			_subitems.y = items.y + items.height;
			_subitems.x = 70;
			item = createMenuItem( PORTFOLIO_1 );
			item.x = _subitems.width + 5;
			_subitems.addChild( item );
			item = createMenuItem( PORTFOLIO_2 );
			item.x = _subitems.width + 5;
			_subitems.addChild( item );
			item = createMenuItem( PORTFOLIO_3 );
			item.x = _subitems.width + 5;
			_subitems.addChild( item );
			addChild( _subitems );
			hideSubMenu();
			
			x = 40;
			y = 20;
		}
		
		public function showSubMenu() : void {
			_subitems.visible = true;
		}
		
		public function hideSubMenu() : void {
			_subitems.visible = false;
		}
		
		public function setActive( label : String ) : void {
			var item : Sprite = _items[label] as Sprite;
			if( !item ) {
				setInactive( _active );
				return;
			}
			var txt : TextField = item.getChildAt(0) as TextField;
			txt.htmlText = "<body><h3><a class='selected'>" + label + "</a></h3>";
			setInactive( _active );
			_active = label;
		}
		
		public function setInactive( label : String ) : void {
			var item : Sprite = _items[label] as Sprite;
			if( !item ) return;
			var txt : TextField = item.getChildAt(0) as TextField;
			txt.htmlText = "<body><h3><a>" + label + "</a></h3>";
		}
		
		private function createMenuItem( label : String ) : Sprite {
			var item : Sprite = new Sprite();
			item.name = label;
			item.buttonMode = true;
			item.mouseChildren = false;
			item.addChild( createTextField( "<h3><a>" + label + "</a></h3>" ) );
			return _items[ label ] = item;
		}
	}
}
