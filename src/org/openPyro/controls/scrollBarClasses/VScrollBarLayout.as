package org.openPyro.controls.scrollBarClasses
{
	import org.openPyro.controls.ScrollBar;
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.UIContainer;
	import org.openPyro.layout.ILayout;
	
	import flash.display.DisplayObject;
	
	public class VScrollBarLayout implements ILayout
	{
		protected var _scrollBar:ScrollBar;
		
		public function VScrollBarLayout() {
			
		}
		
		public function set container(container:UIContainer):void
		{
			_scrollBar = ScrollBar(container);
		}
		
		
		public function getMaxWidth(children:Array):Number
		{
			return _scrollBar.width;
		}
		
		public function getMaxHeight(children:Array):Number
		{
			return _scrollBar.height;
		}
		
		public function layout(children:Array):void
		{
			var allocatedHeight:Number = 0;
			if(_scrollBar.decrementButton)
			{
				_scrollBar.decrementButton.y =0;
				allocatedHeight+=_scrollBar.decrementButton.height;
			}
			if(_scrollBar.incrementButton)
			{
				_scrollBar.incrementButton.y =  _scrollBar.height-_scrollBar.incrementButton.height;
				allocatedHeight+=_scrollBar.incrementButton.height;
			}
			if(_scrollBar.slider && _scrollBar.decrementButton)
			{
				_scrollBar.slider.y = _scrollBar.decrementButton.height;
				
				_scrollBar.slider.height = _scrollBar.height-allocatedHeight;
			}
			
			// Immediately validate the size and displaylist of the slider
 			// else we get a lag (flicker) in the drawing.
 			if(_scrollBar.slider && _scrollBar.slider is MeasurableControl)
			{
				_scrollBar.slider.validateSize();
				_scrollBar.slider.validateDisplayList();
			}
		}
		
		public function set initX(n:Number):void
		{
			
		}
		
		public function set initY(n:Number):void
		{
			
		}
		
		private var _prepare:Function;
		public function set prepare(f:Function):void{
			_prepare = f;
		}

	}
}