package org.openPyro.aurora.skinClasses
{
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	
	import org.openPyro.controls.Button;
	import org.openPyro.controls.Label;
	import org.openPyro.core.IStateFulClient;
	import org.openPyro.core.UIControl;
	import org.openPyro.events.PyroEvent;
	
	public class AbstractButtonSkin extends UIControl implements IStateFulClient{
		public function AbstractButtonSkin()
		{
		}
		
		override public function set skinnedControl(uic:UIControl):void
		{
			if(skinnedControl)
			{
				skinnedControl.removeEventListener(PyroEvent.PROPERTY_CHANGE, onSkinnedControlPropertyChange)
			}
			super.skinnedControl = uic;
			skinnedControl.addEventListener(PyroEvent.PROPERTY_CHANGE, onSkinnedControlPropertyChange)
			if(uic is Button)
			{
				this.changeState(null, Button(uic).currentState);
				updateLabel();
			}
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		protected function onSkinnedControlPropertyChange(event:PyroEvent):void{
			
		}
		
		public function changeState(fromState:String, toState:String):void{
			
		}
		
		/////////////////// ICON /////////////////
		
		protected var _icon:DisplayObject;
		public function set icon(icn:DisplayObject):void
		{
			_icon = icn;
			addChild(_icon);
			if(skinnedControl){
				invalidateDisplayList();
			}
		}
		
		////////////////// LABEL /////////////////
		
		protected var _labelFormat:TextFormat = new TextFormat("Arial",11, 0x111111,true);
		
		public function set labelFormat(fmt:TextFormat):void
		{
			_labelFormat = fmt;
			if(label)
			{
				label.textFormat = fmt;
			}
			if(skinnedControl)
			{
				invalidateDisplayList();
			}
		}
		
		public function get labelFormat():TextFormat
		{
			return _labelFormat;
		}
		
		protected var label:Label;
		
		public function updateLabel():void
		{
			if(this.skinnedControl is Button)
			{
				var bttn:Button = Button(this.skinnedControl);
				if(!bttn.label) return;
				if(!label){
					label = new Label();
					label.textFormat = _labelFormat;
					addChild(label);
					
				}
				label.text = bttn.label;
			}
		}
		
		protected var _labelAlign:String = "center";
		public function set labelAlign(direction:String):void
		{
			_labelAlign = direction;
			if(skinnedControl){
				invalidateDisplayList();
			}
		}

	}
}