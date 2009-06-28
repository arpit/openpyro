package org.openPyro.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.openPyro.controls.events.ButtonEvent;
	import org.openPyro.controls.events.SliderEvent;
	import org.openPyro.controls.skins.ISliderSkin;
	import org.openPyro.core.Direction;
	import org.openPyro.core.UIControl;
	import org.openPyro.skins.ISkin;
	
	[Event(name="thumbDrag", type="org.openPyro.controls.events.SliderEvent")]
	[Event(name="change", type="org.openPyro.controls.events.SliderEvent")]
	public class Slider extends UIControl
	{
		
		protected var _direction:String;
		protected var _thumbButton:Button;
		protected var _trackSkin:DisplayObject;
		protected var _isThumbPressed:Boolean = false;
		protected var _thumbButtonHeight:Number= 20;
		protected var _thumbButtonWidth:Number = 20;
		
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
				thumbButton.width = _thumbButtonWidth;
				thumbButton.height = _thumbButtonHeight;
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
			//_thumbButton.mouseOutHandler = function(event:MouseEvent):void{}
			
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
				_thumbButton.width = _thumbButtonWidth;
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
				_thumbButton.skin = skin;
			//if(_thumbButton is MeasurableControl && MeasurableControl(_thumbButton).usesMeasurementStrategy()){
			//		_thumbButton.width = _thumbButtonWidth;
			//	}
			//	if(isNaN(_thumbButton.getExplicitOrMeasuredHeight())){
			//		_thumbButton.height = _thumbButtonHeight;
			//	}
			}
			
		}
		
		private var _value:Number = 0;
		private var _minimum:Number = 0;
		private var _maximum:Number = 100;
		
		/**
		 * Returns the minimum value for
		 * the slider
		 */ 
		public function get minimum():Number{
			return _minimum;
		}
		
		/**
		 * @private
		 */  
		public function set minimum(value:Number):void
		{
			_minimum = value;
		}
		
		/**
		 * Returns the maximum value for
		 * the slider
		 */ 
		public function get maximum():Number{
			return _maximum;
		}
		
		/**
		 * @private
		 */ 
		public function set maximum(value:Number):void
		{
			_maximum = value;
		}
		
		/**
		 * Utility function for setting the range of the Slider
		 * that returns reference to the slider instance itself
		 * for method chaining purposes.
		 */ 
		 public function setRange(min:Number, max:Number):Slider{
		 	_maximum = max;
		 	_minimum = min;
		 	return this;
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
			_thumbButton.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
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
			//this.startDrag(true, new Rectangle(0,0,0,0));
			//this.stopDrag();
			_thumbButton.stopDrag();
			this._isThumbPressed=false;
			//this.forceInvalidateDisplayList = true;
			//this.invalidateDisplayList()
		}
		
		public function set trackSkin(trackSkin:DisplayObject):void{
			if(_trackSkin)
			{
				_trackSkin.removeEventListener(MouseEvent.CLICK, onTrackSkinClick);
				if(_trackSkin is ISkin){
					ISkin(_trackSkin).dispose();
				}
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
			trace("calling slider updatedl "+unscaledHeight);
			super.updateDisplayList(unscaledWidth, unscaledHeight);	
			if(_trackSkin)
			{
				if(_trackSkin is UIControl){
					var track:UIControl = UIControl(_trackSkin);
					if(isNaN(track.explicitWidth) || this.direction==Direction.HORIZONTAL){
						_trackSkin.width = unscaledWidth;
					}
					if(isNaN(track.explicitHeight)|| this.direction == Direction.VERTICAL){
						_trackSkin.height = unscaledHeight;
					}
					track.validateSize();
					track.validateDisplayList()
				}
				
				else{
					if(this.direction == Direction.HORIZONTAL){
						_trackSkin.width = unscaledWidth;
					}
					else{
						_trackSkin.height = unscaledHeight;
					}
				}
				
				
				/*
				Position the thumb button wherever it was supposed to
				be. For some reason updateDisplaylist keeps sending the button 
				to 0,0
				*/ 
				//this._thumbButton.y = this.thumbButtonY; 
				//this._thumbButton.x = this.thumbButtonX;
				//_trackSkin.y = 0
				// center the trackskin
				//_trackSkin.y = (unscaledHeight-_trackSkin.height)/2;
				
			}
		}

		override public function validateSize():void
		{
			super.validateSize();
			// TODO: How often is validateSize called? 
			// Should this be wrapped in
			// if ((_direction == Direction.HORIZONTAL && thumbButtonX < 0) || (_direction == Direction.VERTICAL && thumbButtonY < 0)) 
			positionThumb(_value);
		}

		public function get value():Number{
			return _value;
		}
		
		public function set value(v:Number):void{
			_value = v;
			if(!thumbButton) return;
			positionThumb(v);
			dispatchEvent(new SliderEvent(SliderEvent.CHANGE));
		}
		
		/**
		 * Utility function for setting the value of
		 * the slider and returning reference to the
		 * instance itself for chaining purposes.
		 */ 
		public function setValue(v:Number):Slider{
			value = v;
			return this;
		}
		
		private function positionThumb(v:Number):void
		{
			if(!_thumbButton) return;
			if(_direction == Direction.HORIZONTAL)
			{
				_thumbButton.x = v*(this.width-_thumbButton.width)/(_maximum-_minimum) ;
				thumbButtonX = _thumbButton.x;
				thumbButtonY = (this.height-_thumbButton.height)/2;
			}
			else
			{
				_thumbButton.y = v*(this.height-_thumbButton.height)/(_maximum-_minimum) ;
				thumbButtonY = _thumbButton.y;
				thumbButtonX = (this.width-_thumbButton.width)/2;
			}
		}
		
		public function set thumbButtonHeight(value:Number):void
		{
			_thumbButtonHeight = value;
			if(_thumbButton)
			{
				_thumbButton.height = Math.max(value,_minThumbHeight);
			}
			this.invalidateDisplayList();
		}
		
		public function get thumbButtonHeight():Number{
			return _thumbButton?_thumbButton.height:NaN;
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
		
		public function get thumbButtonWidth():Number{
			return _thumbButtonWidth;
		}
		

	}
}