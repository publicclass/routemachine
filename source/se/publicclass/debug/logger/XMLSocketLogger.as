package se.publicclass.debug.logger {	import se.publicclass.debug.ILogger;	import se.publicclass.debug.Log;		import flash.events.ErrorEvent;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.SecurityErrorEvent;	import flash.net.XMLSocket;		/**	 * A logger which connects to a xml socket per session and sends the log info as it comes in.	 * 	 * Sends a log xml formatted like this to the server:	 * <listing version="3.0">	 *		&lt;log level="0" time="5834" classpath="com.saab.framework.components.media::VideoCore/onNetStatus()">  	 *		&lt;stack-trace>Error: log	 *			at com.saab.debug::Debug$/getStackTrace()[/Users/slaskis/Projects/PublicClass/Saab/source/com/saab/debug/Debug.as:75]	 *			at com.saab.debug::Debug$/log()[/Users/slaskis/Projects/PublicClass/Saab/source/com/saab/debug/Debug.as:32]	 *			at com.saab.framework.components.media::VideoCore/onNetStatus()[/Users/slaskis/Projects/PublicClass/Saab/source/com/saab/framework/components/media/VideoCore.as:309]&lt;/stack-trace>	 *		  &lt;message>&lt;![CDATA[[VideoCore src:lib/video/VIDEO_TS.flv] [NetStatusEvent type="netStatus" bubbles=false cancelable=false eventPhase=2 info=[object Object]]]]&rt;&lt;/message>	 *		&lt;/log>	 * </listing>	 *  	 * @author Robert Sköld, robert(at)publicclass.se	 */	public class XMLSocketLogger implements ILogger {		private var _queue : Array = new Array();		private var _level : int;		private var _socket : XMLSocket;		public function XMLSocketLogger( host : String = null , port : uint = 10550 ) {			_socket = new XMLSocket();			_socket.addEventListener( Event.CONNECT , onConnect , false , 0 , true );			_socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR , onError , false , 0 , true );			_socket.addEventListener( IOErrorEvent.IO_ERROR , onError , false , 0 , true );			_socket.connect(host, port );		}				private function onError( event : ErrorEvent ) : void {			trace( "XMLSocketLogger::onError: " + event );		}		private function onConnect( event : Event ) : void {			while( _queue.length > 0 ) sendLog( _queue.shift() as Log );		}		public function log( log : Log ) : void {			if( !_socket.connected ) {				_queue.push( log );			} else {				sendLog( log );			}		}				private function sendLog( log : Log ) : void {			if( !_socket.connected ) return;			var info : XML = <log/>; 			info.@level = log.level;			info.@time = log.time;			info.@classpath = log.stackTrace.fullClassPath;			info["stack-trace"] = log.stackTrace; // Will only work if the player is a debug player.			// TODO Check for arrays and object and format them nicely...			for each( var msg : String in log.messages ) {				info.appendChild( new XML( "<message><![CDATA[" + msg + "]]></message>") );			}			_socket.send( info );		}		public function setLevel( level : int ) : void {			_level = level;		}	}}