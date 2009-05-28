package se.publicclass.example.view.components {
	import flash.display.Sprite;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class Content extends Sprite {
		
		protected var css : StyleSheet = new StyleSheet();
		
		public function Content() {
			setupStyleSheet();
		}
		
		protected function setupStyleSheet() : void {
			css.setStyle( "body" , { 
				fontFamily: "Arial", 
				fontSize: 12
			} );
			css.setStyle( "h1" , {
				fontSize: 24
			} );
			css.setStyle( "a", {
				color: "#000000"
			} );
			css.setStyle( "a:hover", {
				color: "#FFFFFF"
			} );
			css.setStyle( ".selected" , {
				color: "#FF0000" 
			} );
		}
		
		protected function createTextField( htmlText : String ) : TextField {
			var txt : TextField = new TextField();
			txt.autoSize = "left";
			txt.styleSheet = css;
			txt.selectable = false;
			txt.htmlText = "<body>" + htmlText;
			return addChild( txt ) as TextField;
		}
	}
}
