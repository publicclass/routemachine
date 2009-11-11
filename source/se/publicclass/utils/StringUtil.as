package se.publicclass.utils {
	import flash.utils.ByteArray;
	/**	 * @author Robert Sköld, robert(at)publicclass.se	 */	public class StringUtil {				public static var INDENT_STYLE : String = "  ";				public static function format(value : *, indent : String = null ) : String {
			if( !value ) return value;			if( !indent ) indent = INDENT_STYLE;			if( value is Array ) return formatArray( value , indent + INDENT_STYLE );
			if( value is ByteArray ) return formatByteArray( value as ByteArray , indent + INDENT_STYLE );			if( value.toString() == "[object Object]" ) return formatObject( value , indent + INDENT_STYLE );			if( value.toString() == "[object Dictionary]" ) return formatObject( value , indent + INDENT_STYLE );			return value.toString( );		}
		
		private static function formatByteArray( value : ByteArray, indent : String = ""  ) : String {
			return "ByteArray("+value.length+")";
		}

		public static function formatInline( value : Object ) : String {
			if( !value ) return "null";
			if( value is String ) 
				return "'" + String( value ) + "'";
			if( value is Number || value is int || value is uint ) 
				return value.toString();
			var valueString : String = ( value is Array ) ? "[" : "{";
			var noComma : Boolean = true;
			for( var a : String in value ) {
				if( !noComma ) valueString += ", ";
				noComma = false;
				valueString += a + ":" + formatInline( value[a] );
			}
			return valueString + ( ( value is Array ) ? "]" : "}" ); 
		}				private static function formatObject(obj : Object, indent : String = "" ) : String {			var prop : String , cnt : Number = 0;			for (prop in obj) cnt++;			var s : String = "Object(" + cnt + "):";			for (prop in obj) {				s += "\n" + indent;				s += prop + " = " + format( obj[prop] , indent );			}			return s;		}		private static function formatArray(arr : Array, indent : String = "" ) : String {			var s : String = "Array(" + arr.length + "):";			var len : Number = arr.length;			for( var i : Number = 0; i < len ; i++ ) {				s += "\n" + indent;				s += "[" + i + "] = " + format( arr[i] , indent );			}			return s;		}				public static function trim( str : String ) : String {			return str.replace( /^[ \t]+|[ \t]+$/ , "" );		}	}}