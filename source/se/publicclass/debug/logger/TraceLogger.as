package se.publicclass.debug.logger {	import se.publicclass.debug.ILogger;	import se.publicclass.debug.Log;	import se.publicclass.utils.StringUtil;		/**	 * A very simple trace logger, passes the logs to a trace window.	 * 	 * @author Robert Sköld, robert(at)publicclass.se	 */	public class TraceLogger implements ILogger {		public static const MAX_RECURSION : uint = 255;		private var _level : int = 0;
		
		public function TraceLogger( level : int = -1 ) {			if( level > -1 ) setLevel( level );		}		
		
		public function log( log : Log ) : void {			if( log.level < _level ) return;			trace.apply( this , [ "(" + log.time + ") " + log.stackTrace.classPath ].concat( getMessages( log.messages ) ) );		}		public function setLevel( level : int ) : void {			_level = level;		}		private function getMessages( rest : Array ) : Array {			for( var i : int = 0; i < rest.length; i++ ) {				if( rest[i] is String ) continue;				rest[i] = "\n" + StringUtil.INDENT_STYLE + StringUtil.format( rest[i] );			}			return rest;		}	}}