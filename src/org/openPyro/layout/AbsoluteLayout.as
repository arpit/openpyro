package org.openPyro.layout
{
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.UIContainer;
	
	import flash.display.DisplayObject;

	public class AbsoluteLayout implements ILayout, IContainerMeasurementHelper
	{
		
		private var _container:UIContainer
		
		public function AbsoluteLayout() {
			
		}
		
		public function set initX(n:Number):void
		{
		}
		
		public function set initY(n:Number):void
		{
		}
		
		public function set container(c:UIContainer):void
		{
			_container = c;
		}
		
		public function layout(children:Array):void
		{

		}
		
		public function getMaxWidth(children:Array):Number
		{
			var maxW:Number=0;
			for(var i:uint=0; i<children.length; i++)
			{
				if(DisplayObject(children[i]).width > maxW)
				{
					maxW = DisplayObject(children[i]).width
				}
			}
			return maxW;
		}
		
		public function getMaxHeight(children:Array):Number
		{
			var maxH:Number=0;
			for(var i:uint=0; i<children.length; i++)
			{
				if(DisplayObject(children[i]).height > maxH)
				{
					maxH = DisplayObject(children[i]).height
				}
			}
			return maxH;
		}
		
		private var _prepare:Function;
		public function set prepare(f:Function):void{
			_prepare = f;
		}
		
		/**		
		*Find all the children with explicitWidth/ explicit Height set
		*This part depends on the layout since HLayout will start trimming
		*the objects available h space, and v layout will do the same 
		*for vertically available space
		**/
		
		public function calculateSizes(children:Array,container:UIContainer):void
		{
			for(var i:int = 0; i<children.length; i++)
			{
				if(children[i] is MeasurableControl)				
				{
					var sizeableChild:MeasurableControl = MeasurableControl(children[i]);
					if(!isNaN(sizeableChild.explicitWidth))
					{
						container.explicitlyAllocatedWidth+=sizeableChild.explicitWidth;
					}
					if(!isNaN(sizeableChild.explicitHeight))
					{
						container.explicitlyAllocatedHeight+=sizeableChild.explicitHeight;	
					}
				}
			}
		}
		
	}
}