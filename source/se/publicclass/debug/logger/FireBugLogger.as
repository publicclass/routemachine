package se.publicclass.debug.logger {	import se.publicclass.debug.ErrorLevel;	import se.publicclass.debug.ILogger;	import se.publicclass.debug.Log;	import se.publicclass.utils.StringUtil;		import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.events.TimerEvent;	import flash.external.ExternalInterface;	import flash.utils.Timer;	import flash.utils.describeType;			/**	 * A logger which sends all the traces to the excellent FireBug firefox plugin.	 * Uses a timer and a log queue to avoid javascript overflows.	 * 	 * Lets FireBug probe the flash, to get:	 * 		1. A list of objects (similar to the list from MarkObject)	 * 		2. The properties of an object	 * 	 * TODO Make the results more readable, FireBug cuts off arrays and some line breaks would be nice.	 * TODO Since safari support console.log but won't read objects we could do some JSON parsing on the data. It might also give some nice output to FireBug.	 * TODO Use the console.group and console.groupEnd methods of firebug. See this: http://www.getfirebug.com/console.html	 * 	 * @author Robert Sköld	 */	public class FireBugLogger implements ILogger {				public static var LOG_TIME : int = 15;				private var _queue : Array;		private var _timer : Timer;		private var _level : int = 0;		private var _parent : DisplayObjectContainer;		public function FireBugLogger( parent : DisplayObjectContainer , errorLevel : int = 0 ) {			_queue = new Array();			_timer = new Timer( LOG_TIME );			_timer.addEventListener( TimerEvent.TIMER , onTimer );			_parent = parent;			setLevel( errorLevel );			ExternalInterface.addCallback( "getObject" , onGetObject );			ExternalInterface.addCallback( "getObjectList" , onGetObjectList );		}				private function onGetObjectList() : void {				output( listObjects( _parent ) );		}		private function onGetObject( name : String ) : void {			var obj : * = findObject( name , _parent );			var msgs : Object = new Object();			if( !obj ) {				msgs = "Could not find object: " + name;			} else {				msgs = getProperties( obj );			}			output( msgs );				}		private function onTimer( event : TimerEvent ) : void {			if( _queue.length > 0 ) {				sendToFirebug( _queue.shift() as Log );			} else {				_timer.stop();			}		}		public function setLevel( level : int ) : void {			_level = level;		}		public function log( log : Log ) : void {			if( log.level < _level ) return;			_queue.push( log );			_timer.start();		}				private function output( msgs : * ) : void {			log( new Log( ErrorLevel.INFO , msgs ) );				}				private function sendToFirebug( log : Log ) : void {			var lvl : String = "log";			switch( log.level ) {				case ErrorLevel.DEBUG: lvl = "debug"; break;				case ErrorLevel.INFO: lvl = "info"; break;				case ErrorLevel.WARN: lvl = "warn"; break;				case ErrorLevel.ERROR: lvl = "error"; break;				case ErrorLevel.FATAL: lvl = "error"; break;				case ErrorLevel.NONE: return;			}			try {				ExternalInterface.call( "console." + lvl , "(" + log.time + ") " + log.stackTrace.classPath + "\n" + StringUtil.format( log.messages ) );			} catch( e1 : Error ) {				try {					ExternalInterface.call( "console.error" , "(" + log.time + ") " + log.stackTrace.classPath + "\n" + e1.message );				} catch( e2 : Error ) {					trace( "Could not send to FireBug" , e1.message );				}			}		}						/**		 * Recursively goes through the children of an object.		 * 		 * @param parent 	The parent of the previous object (starting with the "parent", set in the constructor)		 * 		 * @return 			The tree of objects available right now as children of "parent"		 */		private function listObjects( parent : DisplayObjectContainer ) : Array {			var list : Array = new Array();			for( var i : int = 0; i < parent.numChildren ; i++ ) {				var child : DisplayObject = parent.getChildAt( i );				list.push( { child: child.toString() , properties:getProperties( child ) } );				if( child is DisplayObjectContainer ) {					list.push( listObjects( child as DisplayObjectContainer ) );				}			}			return list;		}				/**		 * Recursively goes through the children of an object (root is "parent", set in the contructor)		 * looking for an object with a certain "name".		 * 		 * @param name 		The name of the object to find.		 * @param parent 	The parent of the previous object (starting with the "parent", set in the constructor)		 * 		 * @return 			The DisplayObject which has the right "name". Or null if no object is found.		 */		private function findObject( name : String , parent : DisplayObjectContainer ) : * {			var found : *;			for( var i : int = 0; i < parent.numChildren ; i++ ) {				var child : DisplayObject = parent.getChildAt( i );				if( child.name == name ) {					found = child;				}				if( !found && child is DisplayObjectContainer ) {					found = findObject( name , child as DisplayObjectContainer );				}			}			return found;		}				/**		 * Uses flash.utils.describeType to output all the properties of an object.		 * @private		 * @see flash.utils.describeType;		 */		private function getProperties( obj : Object ) : Object {			var ret : Object = new Object();			try {					var xmlDoc : XML = describeType( obj );				for each( var item : XML in xmlDoc..accessor ) {					var name : String = item.@name.toString( );					var value : Object;					if( item.@access == "writeonly" ) {						value = "write only";					} else {						value = obj[ name ] != null ? obj[ name ] : "";					}					ret[ name ] = String( value );				}			} catch( e : Error ) {}			return ret;		}	}}