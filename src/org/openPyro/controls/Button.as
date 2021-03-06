package org.openPyro.controls{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openPyro.controls.events.ButtonEvent;
	import org.openPyro.core.IStateFulClient;
	import org.openPyro.core.Padding;
	import org.openPyro.core.UIControl;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.skins.ISkin;
	
	
	[Event(name="up", type="org.openPyro.controls.events.ButtonEvent")]
	[Event(name="over", type="org.openPyro.controls.events.ButtonEvent")]
	[Event(name="down", type="org.openPyro.controls.events.ButtonEvent")]
	
	/**
	 * Dispatched when a toggleable button's state changes from selected to 
	 * deselected or vice versa. 
	 */ 
	[Event(name="change", type="flash.events.Event")]

	public class Button extends UIControl implements IToggleControl{
		
		private var _buttonSkin:ISkin;
		
		/**
		 * Buttons by default return to their 'up' state when 
		 * the mouse moves out, but buttons can be used as elements
		 * in sliders, scrollbars etc where mouseOut should be
		 * handled differently. Having the function referenced like
		 * this lets you override the mouseOut behavior
		 * 
		 * @see	org.openPyro.controls.Slider#thumbButton 
		 */ 
		public var mouseOutHandler:Function = onMouseOut;
		
		public function Button(){
			super();
			_styleName = "Button";
			this.buttonMode = true;
		}
		
		override public function initialize():void{
			super.initialize();
			this.currentState = ButtonEvent.UP
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
			
		}
		
		private var _label:String;
		
		/**
		 * Sets the label property of the Button. How this
		 * property appears visually is upto the skin of
		 * this control
		 */ 
		public function set label(str:String):void
		{
			_label = str;
			dispatchEvent(new PyroEvent(PyroEvent.PROPERTY_CHANGE));
		}
		
		public function get label():String
		{
			return _label;
		}
		
		override public function set skin(skinImpl:ISkin):void{
			super.skin = skinImpl;
			this._buttonSkin = skinImpl;
		}
		
		/////////////// TOGGLE IMPLEMENTATION //////
		
		protected var _toggle:Boolean = false;
		
		/**
		 * Sets whether a button is set as togglable or not.
		 * If true, the button can be set in a selected or deselected
		 * state
		 */ 
		public function set toggle(b:Boolean):void{
			_toggle = b
		}
		
		/**
		 * @private
		 */ 
		public function get toggle():Boolean{
			return _toggle
		}
		
		protected var _selected:Boolean = false;
		/**
		 * Sets a button's state to selected or not. This value is
		 * ONLY set if the toggle property is set to true
		 */ 
		public function set selected(b:Boolean):void{
			if(_toggle){
				if(_selected != b){
					this._selected = b;
					dispatchEvent(new PyroEvent(PyroEvent.PROPERTY_CHANGE));
					dispatchEvent(new Event(Event.CHANGE));
					if(b){
						changeState(ButtonEvent.TOGGLED_OFF, ButtonEvent.TOGGLED_ON);	
					}
					else{
						changeState(ButtonEvent.TOGGLED_ON, ButtonEvent.TOGGLED_OFF);
					}
					
				}
			}
		}
		
		public function get selected():Boolean{
			return _selected
		}
		
		/**
		 * 
		 * IMPORTANT
		 * 
		 * The Button control is different from basic UIControls.
		 * If there is a skin applied to the Button, changing the 
		 * Padding property dispatches an event that the skin can
		 * react to, otherwise the Button does what UIControls do
		 * by default (so for example, that if a background painter 
		 * is on it, it can repaint accordingly)
		 * 
		 * Not sure how I like this, have to rethink Button as a 
		 * pure interaction controller with no UI? 
		 */ 
		override public function set padding(p:Padding):void{
			if(_padding == p) return;
			_padding = p;
			if(!initialized) return;
			if(this._skin){
				dispatchEvent(new PyroEvent(PyroEvent.PROPERTY_CHANGE));	
			}
			else{
				this.invalidateSize();
			}
		}
		
		//////////// States //////////////////////////
		
		public var currentState:String;
		
		public function changeState(fromState:String, toState:String):void{
			if(_buttonSkin && _buttonSkin is IStateFulClient){
				IStateFulClient(this._buttonSkin).changeState(fromState,toState);
			}
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			if(_selected) return;
			changeState(this.currentState,ButtonEvent.OVER);
			this.currentState = ButtonEvent.OVER;
			dispatchEvent(new ButtonEvent(ButtonEvent.OVER));
		}
		
		
		protected var _isPressed:Boolean = false;
		private function onMouseDown(event:MouseEvent):void{
			_isPressed = true;
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpOutside);
			this.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver)
			if(_toggle){
				if(_selected){
					selected = false;
				}
				else{
					selected = true
				}
			}
			if(_buttonSkin  && _buttonSkin is IStateFulClient){
				IStateFulClient(this._buttonSkin).changeState(this.currentState,ButtonEvent.DOWN);
			}
			this.currentState = ButtonEvent.DOWN;
			dispatchEvent(new ButtonEvent(ButtonEvent.DOWN));
		}
		
		private function onMouseUp(event:MouseEvent):void{
			if(_selected) return;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpOutside);
			_isPressed = false;
			if(_buttonSkin  && _buttonSkin is IStateFulClient){
				IStateFulClient(this._buttonSkin).changeState(this.currentState, ButtonEvent.OVER);
			}
			this.currentState = ButtonEvent.OVER;
			dispatchEvent(new ButtonEvent(ButtonEvent.UP));
		}
		
		protected function onMouseUpOutside(event:MouseEvent):void{
			if(!_isPressed) return;
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpOutside);
			_isPressed = false;
			
			if(_buttonSkin  && _buttonSkin is IStateFulClient){
				IStateFulClient(this._buttonSkin).changeState(this.currentState, ButtonEvent.UP);
			}
			this.currentState = ButtonEvent.UP;
			dispatchEvent(new ButtonEvent(ButtonEvent.UP));
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			if(_isPressed) return; 
			if(_buttonSkin  && _buttonSkin is IStateFulClient){
				IStateFulClient(this._buttonSkin).changeState(this.currentState, ButtonEvent.UP);
			}
			this.currentState = ButtonEvent.UP;
			dispatchEvent(new ButtonEvent(ButtonEvent.UP));
		}
		
	}
}