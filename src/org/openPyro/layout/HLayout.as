package org.openPyro.layout{
	import flash.display.DisplayObject;
	
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.UIContainer;
	
	public class HLayout extends AbstractLayout implements ILayout, IContainerMeasurementHelper{
		
		
		private var _hGap:Number;
		public function HLayout(hGap:Number=0):void{
			_hGap = hGap;
		}
		
		/**
		 * The horizontal gap between the displayObjects that
		 * are being layed out.
		 */ 
		public function get hGap():Number{
			return _hGap;
		}
		
		protected var _container:UIContainer;
		public function set container(container:UIContainer):void
		{
			_container = container;
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
				if(i>0){
					container.explicitlyAllocatedWidth+=_hGap;
				}
				if(children[i] is MeasurableControl)	
				{
					var sizeableChild:MeasurableControl = MeasurableControl(children[i]);
					
					if(isNaN(sizeableChild.percentUnusedWidth) && isNaN(sizeableChild.percentWidth))
					{
						container.explicitlyAllocatedWidth+=sizeableChild.width;
					}
					
				}
			}
		}
		
		public function getMaxWidth(children:Array):Number
		{
			var nowX:Number=_initX;
			for(var i:uint=0; i<children.length; i++){
				var c:DisplayObject = children[i] as DisplayObject;
				nowX+=c.width+_hGap;
			}
			return nowX-_hGap;	
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
		
		override public function calculatePositions(children:Array):Array{
			super.calculatePositions(children);
			var nowX:Number=_initX;
			var child:DisplayObject
			for(var i:uint=0; i<children.length; i++){
				child = children[i] as DisplayObject;
				var descriptor:LayoutDescriptor = new LayoutDescriptor(child, nowX, _initY);				
				layoutDescriptors.push(descriptor);
				nowX+=child.width+_hGap;
			}
			return layoutDescriptors;	
		}
		
	}
}