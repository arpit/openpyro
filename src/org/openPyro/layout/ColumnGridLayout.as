package org.openPyro.layout
{
	import flash.display.DisplayObject;
	
	import org.openPyro.core.UIContainer;

	public class ColumnGridLayout extends AbstractLayout implements ILayout, IContainerMeasurementHelper
	{
		
		protected var _initX:Number = 0;
		protected var _initY:Number = 0;
		
		protected var _numRows:uint;
		protected var _columnWidth:Number = NaN;
		protected var _rowGap:Number;
		protected var _columnGap:Number;
		
		public function ColumnGridLayout(numRows:uint, columnWidth:Number = NaN, rowGap:Number=0, columnGap:Number=0)
		{
			this._numRows = numRows;
			_columnWidth = columnWidth;
			_rowGap = rowGap
			_columnGap = columnGap
		}

		public function set initX(n:Number):void
		{
			_initX = n;
		}
		
		public function set initY(n:Number):void
		{
			_initY = n;
		}
		
		private var _container:UIContainer
		public function set container(c:UIContainer):void
		{
			_container = c;	
		}
		
		override public function calculatePositions(children:Array):Array{
			if(children.length == 0 ) return [] ;
			layoutDescriptors = [];
			
			var nowX:Number = _initX;
			var nowY:Number = _initY;
			
			if(isNaN(_columnWidth)){
				_columnWidth = DisplayObject(children[0]).width;
			}
			
			for(var i:uint=0; i<children.length; i++)
			{
				var child:DisplayObject = children[i] as DisplayObject;
				if(i>0 && (i%_numRows)==0){
					nowX+=_columnWidth+_columnGap;
					nowY = _initY;
				}
				
				var descriptor:LayoutDescriptor = new LayoutDescriptor(child, nowX, nowY);				
				layoutDescriptors.push(descriptor);
				nowY+=child.height + _rowGap;
			}
			return layoutDescriptors;
		}
		
		public function getMaxWidth(children:Array):Number
		{
			// TODO: stub ... this needs to cahnge to actually use a calculation
			return 300;
		}
		
		public function getMaxHeight(children:Array):Number
		{
			//TODO: stub ... this needs to cahnge to actually use a calculation
			return 300;
		}
		
		private var _prepare:Function;
		public function set prepare(f:Function):void{
			_prepare = f;
		}
		
		public function calculateSizes(children:Array, container:UIContainer):void
		{
		}
		
	}
}