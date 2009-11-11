package se.publicclass.debug {
	import se.publicclass.debug.logger.NullLogger;
	import se.publicclass.debug.logger.TraceLogger;
	
	import flash.net.LocalConnection;
	import flash.system.System;	

	/**	 * Debug class	 * @author Robert Sköld, robert(at)publicclass.se	 */	public class Debug {		private static var _loggers : Array = new Array();		private static var _log : Log;
		
		public static function addLogger( logger : ILogger ) : void {			_loggers.push( logger );		}		public static function log( ...rest ) : void {
			if( _loggers.length == 1 && _loggers[0] is NullLogger ) return;			sendToLoggers( new StackTrace() , rest, ErrorLevel.DEBUG );		}		public static function trace( ...rest ) : void {
			if( _loggers.length == 1 && _loggers[0] is NullLogger ) return;			sendToLoggers( new StackTrace() , rest , ErrorLevel.DEBUG );		}
		
		public static function info( ...rest ) : void {
			if( _loggers.length == 1 && _loggers[0] is NullLogger ) return;
			sendToLoggers( new StackTrace() , rest , ErrorLevel.INFO );
		}				public static function warn( ...rest ) : void {
			if( _loggers.length == 1 && _loggers[0] is NullLogger ) return;			sendToLoggers( new StackTrace() , rest , ErrorLevel.WARN );		}				public static function error( ...rest ) : void {
			if( _loggers.length == 1 && _loggers[0] is NullLogger ) return;			sendToLoggers( new StackTrace() , rest , ErrorLevel.ERROR );		}				public static function fatal( ...rest ) : void {
			if( _loggers.length == 1 && _loggers[0] is NullLogger ) return;			sendToLoggers( new StackTrace() , rest , ErrorLevel.FATAL );		}		private static function sendToLoggers( stackTrace : StackTrace , messages : Array , level : int = 0 ) : void {			_log = new Log( level , messages , stackTrace );
			if( _loggers.length == 0 ) {
				addLogger( new TraceLogger() );
			}
			for each( var logger : ILogger in _loggers ) {				logger.log( _log );
			}		}
		
		public static function gc() : void {
			// Fallback to the LocalConnection force gc hack if fp is older than 9.0.115
			if( System["gc"] is Function ) {
				System["gc"](); // Force a GC mark
				System["gc"](); // Force a GC sweep
			} else {
				try {
					new LocalConnection().connect('foo');
					new LocalConnection().connect('foo');
				} catch (e:*) {}
			}
		}
	}}

import flash.utils.describeType;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;

class LogError extends Error {	public function LogError( message : String ) {		super( message );	}}class DebugHelper {	public static function getFullClassPath(obj : Object) : String {		var xmlDoc : XML = describeType( obj );		var ary : Array = [];		// add the className of the actual object		var className : String = getQualifiedClassName( obj );		className = className.indexOf( "::" ) > -1 ? className.split( "::" ).join( "." ) : className;				ary.push( className );				// loop the extendsClass nodes		for each(var item:XML in xmlDoc.extendsClass ) {			var extClass : String = item.@type.toString( ).indexOf( "::" ) > -1 ? item.@type.toString( ).split( "::" )[1] : item.@type.toString( );			ary.push( extClass );		}		return ary.join( "." );	}	public static function getImmediateClassPath(obj : Object) : String {		var className : String = getQualifiedClassName( obj );		var superClassName : String = getQualifiedSuperclassName( obj );		className = className.indexOf( "::" ) > -1 ? className.split( "::" ).join( "." ) : className;		if(superClassName == null) return className; 				superClassName = superClassName.indexOf( "::" ) > -1 ? superClassName.split( "::" ).join( "." ) : superClassName;		return superClassName + "." + className;	}	public static function getProperties(obj : Object) : Array {		var ary : Array = [];		try {				var xmlDoc : XML = describeType( obj );			for each(var item:XML in xmlDoc.variable) {				var name : String = item.@name.toString( );				var type : String = item.@type.toString( );				var value : Object = obj[name] != null ? obj[name] : "";				ary.push( {name:name , type:type , value:value} );			}		}catch(e : Error) {}		return ary;	}}