package org.openPyro.layout
{
	import flare.query.methods.where;
	
	import flash.display.DisplayObject;
	
	import org.openPyro.core.UIContainer;

	public class FlowLayout extends AbstractLayout implements ILayout{
		
		public var horizontalGap:Number = 0;
		public var verticalGap:Number = 0;
		
		public function FlowLayout(horizontalGap:Number=0, verticalGap:Number=0){
			this.horizontalGap = horizontalGap;
			this.verticalGap = verticalGap;
		}
		
		protected var _container:UIContainer;
		public function set container(container:UIContainer):void
		{
			_container = container;
		}
		
		public function getMaxWidth(children:Array):Number{
			return NaN;
		}
		
		public function getMaxHeight(children:Array):Number{
			return NaN
		}
		
		override public function calculatePositions(children:Array):Array{
			super.calculatePositions(children);
			
			var child:DisplayObject;
			
			var nowX:Number = _initX;
			var nowY:Number = _initY;
			
			for(var i:uint=0; i<children.length; i++){
				child = children[i] as DisplayObject;
				
				if(nowX + child.width < _container.width){
					
				}
				else{
					nowX = _initX;
					nowY += child.height + verticalGap;
				}
				var descriptor:LayoutDescriptor = new LayoutDescriptor(child, nowX, nowY);
				nowX = child.x+child.width + horizontalGap;
				layoutDescriptors.push(descriptor);
			}
			return layoutDescriptors;	
		}
	}
}