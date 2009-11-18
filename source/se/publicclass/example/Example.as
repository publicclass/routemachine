package se.publicclass.example {
	import org.puremvc.as3.utilities.routes.RouteMachine;
	import flash.display.Sprite;

	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	[SWF( backgroundColor="#CCCCCC" )]
	public class Example extends Sprite {
		public function Example() {
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			RouteMachine.VERBOSE = true;
			RouteMachine.TRACE_LOG = output;
			
			trace( "######################################################");
			trace( "INITIATING EXAMPLE - " + new Date() );
			
			ApplicationFacade.getInstance().startup( this );
		}
		
		private function output( ...args ) : void {
			trace( formatInline( args ) );
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
		}
	}
}
