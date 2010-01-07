package org.openPyro.layout
{
	import flash.display.DisplayObject;
	
	import org.openPyro.core.UIContainer;

	public class RowGridLayout extends AbstractLayout implements ILayout, IContainerMeasurementHelper
	{
		
		private var _initX:Number = 0;
		private var _initY:Number = 0;
		
		protected var _numColumns:uint;
		protected var _rowHeight:Number = NaN;
		protected var _rowGap:Number;
		protected var _columnGap:Number;
		
		public function RowGridLayout(numColumns:uint, rowHeight:Number = NaN, rowGap:Number=0, columnGap:Number=0)
		{
			this._numColumns = numColumns;
			_rowHeight = rowHeight;
			_rowGap = rowGap
			_columnGap = columnGap
		}
		
		private var _prepare:Function;
		public function set prepare(f:Function):void{
			_prepare = f;
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
			
			layoutDescriptors = [];
			
			if(children.length == 0 ) return [] ;
			var nowX:Number = _initX;
			var nowY:Number = _initY;
			
			if(isNaN(_rowHeight)){
				_rowHeight = DisplayObject(children[0]).height;
			}
			
			for(var i:uint=0; i<children.length; i++)
			{
				var child:DisplayObject = children[i] as DisplayObject;
				if(i>0 && (i%_numColumns)==0){
					nowY+= _rowHeight+_rowGap;
					nowX= _initX;
				}
				var descriptor:LayoutDescriptor = new LayoutDescriptor(child, nowX, nowY);
				layoutDescriptors.push(descriptor);
				nowX+=child.width + _columnGap;
			}
			return layoutDescriptors;
		}
		
		public function getMaxWidth(children:Array):Number
		{
			if(children.length == 0){
				return 0
			}
			var childW:Number = children[0].width;
			var w:Number = childW * this._numColumns
			return w;
		}
		
		public function getMaxHeight(children:Array):Number
		{
			if(children.length == 0){
				return 0
			}
			
			var childH:Number = isNaN(_rowHeight)?children[0].height:_rowHeight;
			var numRows:int = children.length%_numColumns != 0 ? children.length/_numColumns+1 : children.length/_numColumns
			return (numRows*childH+(numRows-1)*_rowGap) ;
		}
		
		public function calculateSizes(children:Array, container:UIContainer):void
		{
			trace("--> calculate new sizes")
		}
		
	}
}