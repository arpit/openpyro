package org.openPyro.layout{
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.UIContainer;
	import org.openPyro.effects.EffectDescriptor;
	import org.openPyro.effects.PyroEffect;
	
	import flash.display.DisplayObject;
	
	public class VLayout implements ILayout, IContainerMeasurementHelper{
		
		private var _vGap:Number = 0;
		
		public function VLayout(vGap:Number=0){
			_vGap = vGap;
		}
		
		protected var _container:UIContainer;
		public function set container(container:UIContainer):void
		{
			_container = container;
		}
		
		private var _initY:Number = 0;
		private var _initX:Number = 0;
		
		public function set initX(n:Number):void
		{
			_initX = n;	
		}
		
		public function set initY(n:Number):void
		{
			_initY = n;
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
			var nowY:Number=_initY;
			for(var i:uint=0; i<children.length; i++){
				var c:DisplayObject = children[i] as DisplayObject;
				nowY+=c.height;
				nowY+=this._vGap
			}
			return nowY-_vGap;
		}
		
		private var _prepare:Function;
		public function set prepare(f:Function):void{
			_prepare = f;
		}
		
		public var animationDuration:Number = 0;
		
		public function layout(children:Array):void{
			
			if(_prepare != null){
				_prepare(children)
			}	
			
			var nowY:Number=_initY;
			var effectDescriptors:Array  = new Array();
			for(var i:uint=0; i<children.length; i++){
				var c:DisplayObject = children[i] as DisplayObject;
				//c.y = nowY;
				var eff:EffectDescriptor = new EffectDescriptor(c, animationDuration, {y:nowY})
				effectDescriptors.push(eff);
				c.x = _initX;
				nowY+=c.height;
				nowY+=this._vGap
			}
			var move:PyroEffect = new PyroEffect()
			move.effectDescriptors = effectDescriptors;
			move.start()		
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
				initY = container.padding.top;
			
				if(i>0){
					container.explicitlyAllocatedHeight+=_vGap;
				}
				
				if(children[i] is MeasurableControl)				
				{
					var sizeableChild:MeasurableControl = MeasurableControl(children[i]);
					if(isNaN(sizeableChild.percentUnusedHeight) && isNaN(sizeableChild.percentHeight))
					{
					container.explicitlyAllocatedHeight+=sizeableChild.height;	
					}
				}

			}
		}
	}
}