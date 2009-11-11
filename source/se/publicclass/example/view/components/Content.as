package se.publicclass.example.view.components {
	import flash.text.AntiAliasType;
	import flash.display.Sprite;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class Content extends Sprite {
		
		[Embed(
			systemFont='Arial', 
			fontName='EmbeddedArial',
			mimeType='application/x-font', 
			unicodeRange='U+0041-U+005A,U+0061-U+007A,U+0030-U+0039,U+002E-U+002F')]  
		public static const EmbeddedArial : Class;
		
		[Embed(
			systemFont='Arial', 
			fontName='EmbeddedArial',
			fontWeight='bold',
			mimeType='application/x-font', 
			unicodeRange='U+0041-U+005A,U+0061-U+007A,U+0030-U+0039,U+002E-U+002F')] 
		public static const EmbeddedArialBold : Class;
		
		protected var css : StyleSheet = new StyleSheet();
		
		public function Content() {
			setupStyleSheet();
		}
		
		protected function setupStyleSheet() : void {
			css.setStyle( "body" , { 
				fontFamily: "EmbeddedArial", 
				fontSize: 12,
				leading: 2
			} );
			css.setStyle( "h1" , {
				fontSize: 32,
				fontWeight: "bold",
				letterSpacing: -2,
				color: "#666666"
			} );
			css.setStyle( "h3" , {
				fontSize: 18,
				letterSpacing: -1,
				leading: -2,
				fontWeight: "bold"
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
		
		protected function createTextField( htmlText : String , width : int = -1 ) : TextField {
			var txt : TextField = new TextField();
			txt.autoSize = "left";
			txt.styleSheet = css;
			txt.embedFonts = true;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.selectable = false;
			if( width > -1 ) {
				txt.width = width;
				txt.multiline = true;
				txt.wordWrap = true;
			}
			txt.htmlText = "<body>" + htmlText;
			return addChild( txt ) as TextField;
		}
	}
}
