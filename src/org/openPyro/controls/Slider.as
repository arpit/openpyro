package org.openPyro.controls
{
	import org.openPyro.controls.events.ButtonEvent;
	import org.openPyro.controls.events.SliderEvent;
	import org.openPyro.controls.skins.ISliderSkin;
	import org.openPyro.core.Direction;
	import org.openPyro.core.UIControl;
	import org.openPyro.skins.ISkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Event(name="thumbDrag", type="org.openPyro.controls.events.SliderEvent")]
	
	public class Slider extends UIControl
	{
		
		protected var _direction:String;
		protected var _thumbButton:Button;
		protected var _trackSkin:DisplayObject;
		protected var _isThumbPressed:Boolean = false;
		protected var _thumbButtonHeight:Number=NaN;
		protected var _thumbButtonWidth:Number = NaN;
		
		public function Slider(direction:String)
		{
			super();
			this._direction = direction;
			this._styleName = "Slider";
		}
		
		public function get direction():String
		{
			return _direction;
		}
		
		override public function initialize():void
		{
			super.initialize()
			if(!_thumbButton)
			{
				thumbButton = new Button();
			}
		}
		
		override public function set skin(skinImpl:ISkin):void{
			super.skin = skinImpl;
			if(skinImpl is ISliderSkin)
			{
				var sliderSkin:ISliderSkin = ISliderSkin(skinImpl);
				if(sliderSkin.trackSkin && sliderSkin.trackSkin is DisplayObject) 
						this.trackSkin = DisplayObject(sliderSkin.trackSkin);
				if(sliderSkin.thumbSkin)
				{
					if(!this._thumbButton)
					{
						thumbButton = new Button();
					}
					this.thumbSkin = sliderSkin.thumbSkin;
				}
						
			}
			this.invalidateSize()
		}

		override public function validateSize():void
		{
			super.validateSize();
			value = _value;
		}

		public function set thumbButton(button:Button):void
		{
			if(_thumbButton){
				_thumbButton.removeEventListener(ButtonEvent.DOWN, onThumbDown);
				removeChild(_thumbButton)
				_thumbButton =null;
			}
			_thumbButton = button;
			_thumbButton.x = 0;
			_thumbButton.addEventListener(ButtonEvent.DOWN, onThumbDown);
			
			/*
			Buttons by default return to their 'up' state when
			the mouse moves out, but slider buttons do not.
			*/
			_thumbButton.mouseOutHandler = function(event:MouseEvent):void{}
			
			if(_direction == Direction.VERTICAL)
			{
				if(isNaN(_thumbButton.explicitWidth) && isNaN(_thumbButton.percentUnusedWidth))
				{
					_thumbButton.percentUnusedWidth = 100;
				}
				_thumbButton.height = _thumbButtonHeight;	
			}
			else if(_direction == Direction.HORIZONTAL)
			{
				if(isNaN(_thumbButton.explicitHeight) && isNaN(_thumbButton.percentUnusedHeight))
				{
					_thumbButton.percentUnusedHeight = 100;
				}	
				_thumbButton.width = 100;
			}
			
			addChild(_thumbButton);
			
			if(this._thumbSkin)
			{
				_thumbButton.skin = _thumbSkin;
			}
			
			
			/*
			set the state 
			*/
			if(_isThumbPressed){
				// _thumbButton.setState
			}	
		}
		
		public function get thumbButton():Button
		{
			return _thumbButton;
		}
		
		protected var _thumbSkin:ISkin
		public function set thumbSkin(skin:ISkin):void
		{
			_thumbSkin = skin;
			if(this._thumbButton)
			{
				_thumbButton.skin = skin
			}
			_thumbButton.width = _thumbButtonWidth;
		}
		
		private var _value:Number = 0;
		private var _minimum:Number = 0;
		private var _maximum:Number = 100;
		
		
		public function get minimum():Number{
			return _minimum;
		}
		
		public function set minimum(value:Number):void
		{
			_minimum = value;
		}
		
		public function get maximum():Number{
			return _maximum;
		}
		
		public function set maximum(value:Number):void
		{
			_maximum = value;
		}
		
		protected var boundsRect:Rectangle;
		
		private function onThumbDown(event:ButtonEvent):void{
			this._isThumbPressed = true;
			if(_direction == Direction.HORIZONTAL)
			{
				boundsRect = new Rectangle(0,0,width-_thumbButton.width, 0);
			}
			else
			{
				boundsRect = new Rectangle(0,0,0, height-_thumbButton.height);
			}
			_thumbButton.startDrag(false,boundsRect)
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_thumbButton.addEventListener(ButtonEvent.UP, onThumbUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			
		}
		
		private function onEnterFrame(event:Event):void{
			if(_isThumbPressed){
				//compute slider value
				dispatchScrollEvent()
			}
		}
		
		public function dispatchScrollEvent():void
		{
			var computedValue:Number
			if(_direction == Direction.HORIZONTAL)
			{
				computedValue = (_thumbButton.x/(this.width-_thumbButton.width))*(_maximum-_minimum);
				thumbButtonX = _thumbButton.x;
			}
			else
			{
				computedValue = (_thumbButton.y/(this.height-_thumbButton.height))*(_maximum-_minimum);
				thumbButtonY = _thumbButton.y;
			}
			if(computedValue != _value)
			{
				_value = computedValue;
				dispatchEvent(new SliderEvent(SliderEvent.THUMB_DRAG));
				dispatchEvent(new SliderEvent(SliderEvent.CHANGE));
			}
		}
		
		private function onThumbUp(event:Event):void{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			_thumbButton.stopDrag();
			this._isThumbPressed=false;
		}
		
		public function set trackSkin(trackSkin:DisplayObject):void{
			if(_trackSkin)
			{
				_trackSkin.removeEventListener(MouseEvent.CLICK, onTrackSkinClick);
			}
			_trackSkin = trackSkin;
			_trackSkin.addEventListener(MouseEvent.CLICK, onTrackSkinClick);
			_trackSkin.x = 0;
			addChildAt(_trackSkin,0);
			this.invalidateDisplayList();
		}
		
		protected var thumbButtonX:Number = 0
		protected var thumbButtonY:Number = 0
		
		
		public function onTrackSkinClick(event:MouseEvent):void
		{
			if(_direction == Direction.HORIZONTAL)
			{
				thumbButtonX = Math.min(event.localX, (this.width-_thumbButton.width))
				_thumbButton.x = thumbButtonX
			}
			else if(_direction == Direction.VERTICAL)
			{
				thumbButtonY =  Math.min(event.localY, (this.height - _thumbButton.height))
				_thumbButton.y = thumbButtonY
			}
			dispatchScrollEvent()
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);	
			if(_trackSkin)
			{
				_trackSkin.width = unscaledWidth;
				_trackSkin.height = unscaledHeight;	
				if(_trackSkin is UIControl)
				{
					UIControl(_trackSkin).validateSize();
					UIControl(_trackSkin).validateDisplayList()
				}
				
				/*
				Position the thumb button wherever it was supposed to
				be. For some reason updateDisplaylist keeps sending the button 
				to 0,0
				*/ 
				this._thumbButton.y = this.thumbButtonY; 
				this._thumbButton.x = this.thumbButtonX;
			}
        
		
		}
		
		public function get value():Number{
			return _value;
		}
		
		public function set value(v:Number):void{
			_value = v;
			if(!thumbButton) return;
			if(_direction == Direction.HORIZONTAL)
			{
				_thumbButton.x = v*(this.width-_thumbButton.width)/(_maximum-_minimum) ;
				thumbButtonX = _thumbButton.x;
			}
			else
			{
				_thumbButton.y = v*(this.height-_thumbButton.height)/(_maximum-_minimum) ;
				thumbButtonY = _thumbButton.y;
			}
			dispatchEvent(new SliderEvent(SliderEvent.CHANGE));
		}
		
		public function set thumbButtonHeight(value:Number):void
		{
			_thumbButtonHeight = value;
			if(_thumbButton)
			{
				_thumbButton.height = Math.max(value,_minThumbHeight);
			}
		}
		
		protected var _minThumbHeight:Number = 50;
		public function set minThumbHeight(value:Number):void
		{
			this._minThumbHeight = value;	
		}
		
		
		public function set thumbButtonWidth(value:Number):void
		{
			_thumbButtonWidth = value;
			if(_thumbButton)
			{
				_thumbButton.width = value;
			}
		}
		

	}
}