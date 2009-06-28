package org.openPyro.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openPyro.controls.events.ScrollEvent;
	import org.openPyro.controls.events.SliderEvent;
	import org.openPyro.controls.scrollBarClasses.HScrollBarLayout;
	import org.openPyro.controls.scrollBarClasses.VScrollBarLayout;
	import org.openPyro.controls.skins.IScrollBarSkin;
	import org.openPyro.core.Direction;
	import org.openPyro.core.UIContainer;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.skins.ISkin;

	[Event(name="scroll",type="org.openPyro.controls.events.ScrollEvent")]
	
	public class ScrollBar extends UIContainer
	{
		
		protected var _direction:String;
		protected var _slider:Slider;
		
		public function ScrollBar(direction:String)
		{
			this._direction = direction;
			super();
			_styleName = "ScrollBar"
		}
		
		/**
		 * At the very least, a scrollBar needs a slider
		 * or some subclass of it.
		 * Increment and Decrement Buttons are created
		 * automatically when a skin is applied.
		 */ 
		override public function initialize():void
		{
			if(!_slider)
			{
				slider = new Slider(_direction);
				slider.addEventListener(PyroEvent.UPDATE_COMPLETE, onSliderUpdateComplete)
				slider.minimum = _minimum
				slider.maximum = _maximum;
			}
			//if(!_layout)
			//{
				if(this._direction == Direction.HORIZONTAL)
				{
					_layout = new HScrollBarLayout()
				}
				else if(this._direction == Direction.VERTICAL)
				{
					_layout = new VScrollBarLayout();
				}
			//}
			this._layout.container = this;
			super.initialize();
			
		}
		
		public function get direction():String
		{
			return _direction;
		}
		
		override public function set skin(skinImpl:ISkin):void
		{
			super.skin = skinImpl;
			if(_skin is IScrollBarSkin)
			{
				var scrollBarSkin:IScrollBarSkin = IScrollBarSkin(skinImpl);
				if(scrollBarSkin.sliderSkin)
				{
					if(!_slider)
					{
						slider = new Slider(this._direction);
						slider.minimum = _minimum
						slider.maximum = _maximum
						slider.addEventListener(PyroEvent.UPDATE_COMPLETE, onSliderUpdateComplete)
					}
					_slider.skin = scrollBarSkin.sliderSkin;
				}
				if(scrollBarSkin.incrementButtonSkin)
				{
					this.incrementButtonSkin = scrollBarSkin.incrementButtonSkin;
				}
				if(scrollBarSkin.decrementButtonSkin)
				{
					this.decrementButtonSkin = scrollBarSkin.decrementButtonSkin;
				}
			}
		}
		
		protected function onSliderUpdateComplete(event:PyroEvent):void
		{
			updateScrollUI()
		}
		
		protected var _incrementButton:Button;
		public function set incrementButton(b:Button):void
		{
			_incrementButton = b;
			/*if(_direction == Direction.VERTICAL)
			{
				b.percentUnusedWidth=100
			}
			if(_direction == Direction.HORIZONTAL)
			{
				b.percentUnusedHeight = 100;
			}*/
			_incrementButton.addEventListener(MouseEvent.CLICK, onIncrementButtonClick);
			$addChild(b);
			invalidateSize();
			//invalidateDisplayList();
		}
		
		public function get incrementButton():Button
		{
			return _incrementButton;	
		}
		
		protected var _incrementButtonSkin:ISkin;
		public function set incrementButtonSkin(skin:ISkin):void
		{
			_incrementButtonSkin = skin;
			if(!_incrementButton)
			{
				incrementButton = new Button();
				// trigger invalidateDL to retrigger the layout
				//this.invalidateDisplayList();
			}
			_incrementButton.skin = skin;
			invalidateSize();
			//invalidateDisplayList();	
		}
		
		protected var _decrementButton:Button;
		public function set decrementButton(b:Button):void
		{
			_decrementButton = b;
			/*if(_direction == Direction.VERTICAL)
			{
				b.percentUnusedWidth=100;
			}
			if(_direction == Direction.HORIZONTAL)
			{
				b.percentUnusedHeight = 100;
			}*/
			_decrementButton.addEventListener(MouseEvent.CLICK, onDecrementButtonClick)
			$addChild(b);
			invalidateSize()
			//invalidateDisplayList();
		}
		
		/**
		 * The height/width the scrollbar must scroll
		 * when one of the scroll buttons is clicked on.
		 */ 
		public var incrementalScrollDelta:Number=25;
		private function onDecrementButtonClick(event:Event):void{
			if(_slider.direction == Direction.HORIZONTAL){
				_slider.thumbButton.x = Math.max(0, _slider.thumbButton.x - incrementalScrollDelta)	
			}
			else if(slider.direction == Direction.VERTICAL){
				_slider.thumbButton.y = Math.max(0, _slider.thumbButton.y - incrementalScrollDelta)
			}
			_slider.dispatchScrollEvent()
			
		}
		private function onIncrementButtonClick(event:Event):void{
			//_slider.value = Math.min(1, _slider.value + incrementalScrollDelta/_slider.height)
			if(_slider.direction == Direction.HORIZONTAL){
				 _slider.thumbButton.x = Math.min(_slider.width-_slider.thumbButton.width,_slider.thumbButton.x + incrementalScrollDelta);
			}
			else if(slider.direction == Direction.VERTICAL){
				_slider.thumbButton.y = Math.min(_slider.height-_slider.thumbButton.height, _slider.thumbButton.y + incrementalScrollDelta);
			}
			_slider.dispatchScrollEvent();
		}
		
		public function get decrementButton():Button
		{
			return _decrementButton;
		}
		
		protected var _decrementButtonSkin:ISkin;
		public function set decrementButtonSkin(skin:ISkin):void
		{
			_decrementButtonSkin = skin;
			if(!_decrementButton)
			{
				decrementButton = new Button();
			}
			_decrementButton.skin = skin;
			invalidateSize();
			//invalidateDisplayList();
		}
		
		public function set slider(sl:Slider):void{
			
			if(_slider)
			{
				_slider.removeEventListener(SliderEvent.CHANGE, onSliderThumbDrag);
				removeChild(_slider);
				_slider = null;
			}
			
			_slider = sl;
			_slider.addEventListener(SliderEvent.CHANGE, onSliderThumbDrag);
			this.$addChild(_slider);
			if(_direction == Direction.HORIZONTAL){
				_slider.explicitWidth = NaN;
				_slider.percentUnusedWidth = 100;
				_slider.percentUnusedHeight = 100;
			}
			else if(_direction==Direction.VERTICAL){
				_slider.explicitHeight = NaN;
				_slider.percentUnusedWidth = 100;
				_slider.percentUnusedHeight = 100;
			}
			_slider.minimum = 0;
			_slider.maximum = 1;
			this.invalidateSize();
			//this.invalidateDisplayList()	
		}
		
		public function get slider():Slider
		{
			return _slider;
		}
		
		private var _sliderThumbPosition:Number = 0;
		protected function onSliderThumbDrag(event:SliderEvent):void
		{
			var scrollEvent:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
			scrollEvent.direction = this._direction;
			scrollEvent.delta = _slider.value - _sliderThumbPosition;
			scrollEvent.value = this._value = this._slider.value;
			dispatchEvent(scrollEvent);
			_sliderThumbPosition = _slider.value;
		}
		
		/**
		 * For scrollBars, unless the dimension properites of the 
		 * buttons are set, the button's width and heights are 
		 * set to the same as the each other to create square 
		 * buttons
		 */ 
		override public function validateSize():void
		{
			super.validateSize();
			
		}
		
		
		private var _value:Number = 0;
		private var _minimum:Number = 0;
		private var _maximum:Number = 100;
		
		public function set minimum(value:Number):void
		{
			_minimum = value;
			if(_slider)
			{
				_slider.minimum = value;
			}
		}
		
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function set maximum(value:Number):void
		{
			_maximum = value;
			if(_slider)
			{
				_slider.maximum = value
			}
		}
		
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set value(v:Number):void{
			_value = v;
			if(_slider){
				_slider.value = v;
			}
		}
		
		public function get value():Number
		{
			return _slider.value
		}
		
		
		protected var _visibleScroll:Number = NaN;
		protected var _maxScroll:Number=NaN;
		protected var _scrollButtonSize:Number = NaN;
		
		/**
		 * For example: setScrollProperty(scrollHeight, contentHeight);
		 * 
		 * @param visibleScroll	The height of the viewport being scrolled
		 * @param maxScroll		The height of the content to be scrolled
		 */ 
		public function setScrollProperty(visibleScroll:Number, maxScroll:Number):void
		{
			if(visibleScroll == _visibleScroll && maxScroll == _maxScroll) return;
			_visibleScroll = visibleScroll;
			_maxScroll = maxScroll;
			updateScrollUI();
			
		}
		
		protected function updateScrollUI():void
		{
			if(!_slider) return;
			if(this._direction == Direction.VERTICAL)
			{
				_scrollButtonSize = Math.floor(_visibleScroll*_slider.height/_maxScroll);
				_slider.thumbButtonHeight = _scrollButtonSize;
			}
			else if(this._direction == Direction.HORIZONTAL)
			{
				_scrollButtonSize =  Math.floor(_visibleScroll*_slider.width/_maxScroll);
				_slider.thumbButtonWidth = _scrollButtonSize;
			}
			_slider.value = _value;
		}
		
	}
}