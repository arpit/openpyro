package org.openPyro.controls.scrollBarClasses
{
	import org.openPyro.controls.ScrollBar;
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.UIContainer;
	import org.openPyro.layout.ILayout;
	
	public class HScrollBarLayout implements ILayout
	{
		protected var _scrollBar:ScrollBar;
		
		public function HScrollBarLayout() {
			
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
			var allocatedWidth:Number = 0;
			if(_scrollBar.decrementButton)
			{
				_scrollBar.decrementButton.x =0;
				allocatedWidth+=_scrollBar.decrementButton.width;
			}
			if(_scrollBar.incrementButton)
			{
				_scrollBar.incrementButton.x =  _scrollBar.width-_scrollBar.decrementButton.width;
				allocatedWidth+=_scrollBar.incrementButton.width;
			}
			if(_scrollBar.slider && _scrollBar.decrementButton)
			{
				_scrollBar.slider.x = _scrollBar.decrementButton.width;
				
				_scrollBar.slider.width = _scrollBar.width-allocatedWidth;
			}
			
			// Immediately validate the size and displaylist of the slider
 			// else we get a lag (flicker) in the drawing.
 			if(_scrollBar.slider && _scrollBar.slider is MeasurableControl)
			{
				_scrollBar.slider.validateSize();
				_scrollBar.slider.validateDisplayList();
			}
			
		}
		
		private var _prepare:Function;
		public function set prepare(f:Function):void{
			_prepare = f;
		}
		
		public function set initX(n:Number):void
		{
			
		}
		
		public function set initY(n:Number):void
		{
			
		}

	}
}