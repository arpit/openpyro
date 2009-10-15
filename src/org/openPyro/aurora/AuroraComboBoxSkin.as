package org.openPyro.aurora
{
	import flash.filters.DropShadowFilter;
	
	import org.openPyro.controls.skins.IComboBoxSkin;
	import org.openPyro.core.UIControl;
	import org.openPyro.skins.ISkin;
	
	public class AuroraComboBoxSkin implements IComboBoxSkin
	{
		protected var _buttonSkin:AuroraButtonSkin;
		protected var _listSkin:AuroraContainerSkin;
		
		public var cornerRadius:Number = 10;
		public var dropShadowEnabled:Boolean = true;
		
		public function AuroraComboBoxSkin() {
			
		}
		
		public function get buttonSkin():ISkin
		{
			_buttonSkin = new AuroraButtonSkin();
			_buttonSkin.labelAlign = "left";
			_buttonSkin.cornerRadius = this.cornerRadius;
			if(dropShadowEnabled){
				_buttonSkin.filters = [new DropShadowFilter(.5,90,0,1,0,0)];
			}
			return _buttonSkin;
		}
		
		public function get listSkin():ISkin
		{
			_listSkin =  new AuroraContainerSkin();
			return _listSkin;
		}
		
		public function dispose():void
		{
			
		}
		
		public function set skinnedControl(control:UIControl):void
		{
			if(_buttonSkin)
			{
				_buttonSkin.skinnedControl = control;
			}
		}

	}
}