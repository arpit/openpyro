package org.openPyro.controls
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.openPyro.events.PyroEvent;
	
	[Event(name="enter", type="org.openPyro.events.PyroEvent")]
	[Event(name="change", type="flash.events.Event")]
	
	public class TextInput extends Text
	{
		public function TextInput()
		{
			super();
		}
		
		override protected function setTextFieldProperties():void{
			//_textField.border = true;
			_textField.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			_textField.type = TextFieldType.INPUT;
			_textField.addEventListener(FocusEvent.FOCUS_IN, onTextFieldFocusIn);
			_textField.addEventListener(Event.CHANGE, onTextInputChange);
			_textField.addEventListener(FocusEvent.FOCUS_OUT, onTextFieldFocusOut);
			_textField.wordWrap = true;
			_textField.multiline = false;
			
			this.addEventListener(PyroEvent.CREATION_COMPLETE, function(event:Event):void{
				removeEventListener(PyroEvent.CREATION_COMPLETE, arguments.callee);
				if(!_text || _text=="" && _promptText){
					_textField.text = _promptText;
					_textField.setTextFormat(_promptFormat);
				}	
			});
			
			
		}
		
		protected function onTextFieldFocusIn(event:FocusEvent):void{
			if(_textField.text == _promptText){
				_textField.text = "";
				_textField.displayAsPassword = _displayAsPassword;
			}
		}
		
		protected function onTextFieldFocusOut(event:FocusEvent):void{
			if(_textField.text == "" && _promptText){
				_textField.displayAsPassword = false;
				_hasUserEnteredContent = false;
				_textField.text = _promptText;
				_textField.setTextFormat(_promptFormat);
			}
		}
		
		protected var _cornerRadius:Number=0;
		public function set cornerRadius(r:Number):void{
			_cornerRadius= r;
			invalidateDisplayList()
		}
		
		public function get cornerRadius():Number{
			return _cornerRadius;
		}
		
		
		private var _displayAsPassword:Boolean = false;
		public function set password(b:Boolean):void{
			_displayAsPassword = b;
		}
		
		protected function onTextInputChange(event:Event):void{
			_text = _textField.text;
			_hasUserEnteredContent = true;
			dispatchEvent(event);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ENTER){
				dispatchEvent(new PyroEvent(PyroEvent.ENTER));
			}
		}
		/**
		 * @private
		 */ 
		protected var _hasUserEnteredContent:Boolean = false;
		
		/**
		 * A flag that determines if there is content in the 
		 * TextField that the user has entered.
		 */ 
		public function hasUserEnteredContent():Boolean{
			return _hasUserEnteredContent;
		}
		
		protected var _promptFormat:TextFormat;
		public function set promptFormat(txtFormat:TextFormat):void{
			_promptFormat = txtFormat;
		}
		public function get promptFormat():TextFormat{
			return _promptFormat;
		}
		
		protected var _promptText:String;
		public function set promptText(txt:String):void{
			if(!_promptFormat){
				_promptFormat = new TextFormat("Arial", 12,0xcccccc);				
			}
			_promptText = txt;
			if(_textField && !_hasUserEnteredContent){
				_textField.text = _promptText;
				_textField.setTextFormat(_promptFormat);
			}
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			_textField.width = width - _cornerRadius;
			_textField.height = height;
			_textField.x = _cornerRadius/2;
		}
		
	}
}