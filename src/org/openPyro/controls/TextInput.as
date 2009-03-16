package org.openPyro.controls
{
	import org.openPyro.events.PyroEvent;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
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
			_textField.addEventListener(KeyboardEvent.KEY_UP, onKeyUp)
			_textField.type = TextFieldType.INPUT;
			_textField.addEventListener(Event.CHANGE, onTextInputChange);
			_textField.displayAsPassword = _displayAsPassword;
			_textField.wordWrap = true;
			_textField.multiline = false;
		}
		
		private var _displayAsPassword:Boolean = false;
		public function set password(b:Boolean):void{
			_displayAsPassword = b;
		}
		
		protected function onTextInputChange(event:Event):void{
			_text = _textField.text;
			dispatchEvent(event);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ENTER){
				dispatchEvent(new PyroEvent(PyroEvent.ENTER));
			}
		}
		
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			_textField.width = width;
			_textField.height = height;
		}
		
	}
}