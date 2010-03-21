package org.openPyro.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class MouseUtil
	{
		public function MouseUtil()
		{
		}
	
		public static function isMouseOver(obj:DisplayObject):Boolean{
			if(!obj.stage) return false;
			var pt:Point = new Point(obj.stage.mouseX, obj.stage.mouseY);
			obj.globalToLocal(pt);
			return obj.hitTestPoint(pt.x, pt.y);
		}

	}
}