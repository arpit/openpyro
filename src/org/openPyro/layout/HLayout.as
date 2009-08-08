package org.openPyro.layout{
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.UIContainer;
	
	import flash.display.DisplayObject;
	
	public class HLayout implements ILayout, IContainerMeasurementHelper{
		
		
		private var _hGap:Number;
		public function HLayout(hGap:Number=0):void{
			_hGap = hGap;
		}
		
		protected var _container:UIContainer;
		public function set container(container:UIContainer):void
		{
			_container = container;
		}
		
		private var _initY:Number = 0;
		private var _initX:Number = 0;
		
		public function set initX(n:Number):void{
			_initX = n;	
		}
		
		public function get initX():Number{
			return _initX;
		}
		
		public function set initY(n:Number):void{
			_initY = n;
		}
		
		public function get initY():Number{
			return _initY;
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
		
		public function layout(children:Array):void{
			var nowX:Number=_initX;
			for(var i:uint=0; i<children.length; i++){
				var c:DisplayObject = children[i] as DisplayObject;
				c.x = nowX;
				c.y = _initY;
				nowX+=c.width+_hGap;
			}		
		}
	}
}