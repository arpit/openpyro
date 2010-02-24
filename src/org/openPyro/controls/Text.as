package org.openPyro.controls
{
	import flash.events.FullScreenEvent;
	
	public class Text extends Label
	{
		public function Text()
		{
			super();
			//_textField.border = true
		}
		
		public function setFocus():void{
			stage.focus = _textField;
		}
		
		override protected function setTextFieldProperties():void{
			_textField.autoSize = "left"
			_textField.wordWrap = true;
		}
	}
}