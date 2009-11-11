package se.publicclass.utils {
	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.geom.Point;	
	/**
	 * @author Robert Sköld, robert(at)publicclass.se
	 */
	public class CoordinateTools {
		
		public static const TO_DEGREES : Number = 180 / Math.PI;
		public static const TO_RADIANS : Number = Math.PI / 180;

		public static function localToLocal( containerFrom : DisplayObject, containerTo : DisplayObject, origin : Point = null ) : Point {
			var point : Point = origin ? origin : new Point( );
			point = containerFrom.localToGlobal( point );
			point = containerTo.globalToLocal( point );
			return point;
		}

		public static function overlaps( containerUnder : DisplayObject, containerOver : DisplayObject) : Boolean {
			var overParent : DisplayObject = containerOver;
			while (overParent != null) {
				var underParent : DisplayObject = containerUnder;
				while (underParent != null) {
					if (underParent.parent === overParent.parent) {
						if (underParent.parent.getChildIndex( underParent ) < overParent.parent.getChildIndex( overParent )) {
							return true;
						} else {
							return false;
						}
					} else {
						underParent = underParent.parent;
					}
				}
				overParent = overParent.parent;
			}

			return false;
		}
		
		
		public static function getAngleBetweenPoints( pt1 : Point , pt2 : Point ) : Number {
			return Math.atan2 ( pt1.y - pt2.y , pt1.x - pt2.x ) * TO_DEGREES;
		}
		
		public static function getAngleInRadiansBetweenPoints( pt1 : Point , pt2 : Point ) : Number {
			return Math.atan2 ( pt1.y - pt2.y , pt1.x - pt2.x );
		}
	}
}
