package org.openPyro.layout
{
	import flash.display.DisplayObject;
	
	public class AbstractLayout
	{
		public function AbstractLayout()
		{
		}
		
		protected var layoutDescriptors:Array
		
		public function calculatePositions(children:Array):Array{
			return [];
		}
		
		public function layout(children:Array):void
		{
			calculatePositions(children);
			for each(var descriptor:LayoutDescriptor in layoutDescriptors){
				var child:DisplayObject = descriptor.target;
				child.x = descriptor.x;
				child.y = descriptor.y;
			}
			
			
		}

	}
}