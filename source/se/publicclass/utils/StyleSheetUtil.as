package se.publicclass.utils {	import flash.text.StyleSheet;			/**	 * Helper for stylesheets.	 * @author Robert Sköld, robert(at)publicclass.se	 */	public class StyleSheetUtil {		private static var _lastFound : Array;				/**		 * @return A list of the last found styles by hasStyle(); 		 * @see hasStyle();		 */		public static function getLastFoundStyles() : Array {			return _lastFound;		}				/**		 * Find style objects containing a certain style and stores them in an array (reachable using getLastFoundStyles).		 * 		 *  		 * 	StyleSheet:		 * 		h1 {		 * 			paragraph-leading: 14		 * 		}		 * 		p {		 * 			paragraph-leading: 10		 * 		} 		 * 			 * 	Actionscript:		 * 		StyleSheetUtil.hasStyle( css , paragraphLeading ); // returns true, and stores an array of the found objects. 		 * 			 * 	@param css 			The stylesheet to search through.		 * 	@param styleName 	The style to search for. Needs to be flash-formatted, i.e. not "font-family", but "fontFamily".		 * 			 * 	TODO This should probably be cached somehow, since it's used every time a textfield is used		 * 			 * 	@return <code>true</code> if any styles were found, otherwise <code>false</code>		 */		public static function hasStyle( css : StyleSheet , styleName : String ) : Boolean {			_lastFound = new Array();			for each( var style : String in css.styleNames ) {				if( css.getStyle( style ).hasOwnProperty( styleName ) ) {					_lastFound.push( style );				}			}			return _lastFound.length > 0;		}				/**		 * Merges two stylesheets.		 * If the two stylesheets have the same style, it's css2's style that overrides css1's.		 * 		 * @param css1 			An object which properties will be merged with css1. (lower priority).		 * @param css2 			An object which properties will be merged with css2. (higher priority).		 * 		 * @return A new object with the properties of css1 and css2.		 */		public static function merge( css1 : StyleSheet , css2 : StyleSheet ) : StyleSheet {			var css : StyleSheet = new StyleSheet();			var style: String;			for each( style in css1.styleNames ) css.setStyle( style , ObjectUtil.merge( css1.getStyle( style ) , css2.getStyle( style ) ) );			for each( style in css2.styleNames ) css.setStyle( style , ObjectUtil.merge( css1.getStyle( style ) , css2.getStyle( style ) ) );			return css;		}				/**		 * Merges all of the styles in a stylesheet.		 * Priority of the styles is alphabetical.		 * 		 * @param css			The stylesheet to get all styles from.		 * @return				All styles of the stylesheet in one object.		 */		public static function getAllStyles( css : StyleSheet ) : Object {			var styles : Object = new Object();			for each( var style : String in css.styleNames ) {				styles = ObjectUtil.merge( styles , css.getStyle( style ) );			}			return styles;		}				/**		 * Creates a clone of a StyleSheet with the same styles.		 * 		 * @param css			The stylesheet to clone.		 * @return				A new copy of the stylesheet.		 */		public static function clone( css : StyleSheet ) : StyleSheet {			var clone : StyleSheet = new StyleSheet();			for each( var style : String in css.styleNames ) {				clone.setStyle( style , css.getStyle( style ) );			}			return clone;		}				public static function toString( css : StyleSheet ) : String {			var str : String = css.toString();			for each( var style : String in css.styleNames ) {				str += "\n - " + style + ": " + css.getStyle( style ); 			}			return str;		}	}}