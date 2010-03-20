package org.openPyro.layout
{
	import flash.display.DisplayObject;
	
	public class AbstractLayout
	{
		public function AbstractLayout()
		{
		}
		
		protected var _initY:Number = 0;
		protected var _initX:Number = 0;
		
		/**
		 * Sets the initial x position of the layout.All further 
		 * calculations of x positions are based on that 
		 * initial position
		 */ 
		public function set initX(n:Number):void{
			_initX = n;	
		}
		
		/**
		 * @private
		 */ 
		public function get initX():Number{
			return _initX;
		}
		
		/**
		 * Sets the initial y position of the layout.All further 
		 * calculations of y positions are based on that 
		 * initial position
		 */
		public function set initY(n:Number):void{
			_initY = n;
		}
		
		/**
		 * @private
		 */ 
		public function get initY():Number{
			return _initY;
		}
		
		
		protected var layoutDescriptors:Array
		
		public function calculatePositions(children:Array):Array{
			if(children.length == 0 ) return [] ;
			layoutDescriptors = [];
			return layoutDescriptors;
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