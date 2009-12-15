package org.openPyro.layout
{
	import flash.display.DisplayObject;
	
	
	
	public class LayoutDescriptor
	{
		public var target:DisplayObject;
		public var x:Number;
		public var y:Number;
		
		public function LayoutDescriptor(target:DisplayObject, x:Number, y:Number)
		{
			this.target = target;
			this.x = x;
			this.y = y;
		}

	}
}