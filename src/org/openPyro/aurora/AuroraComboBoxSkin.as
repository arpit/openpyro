package org.openPyro.aurora
{
	import org.openPyro.controls.skins.IComboBoxSkin;
	import org.openPyro.core.UIControl;
	import org.openPyro.skins.ISkin;
	
	import flash.filters.DropShadowFilter;
	
	public class AuroraComboBoxSkin implements IComboBoxSkin
	{
		protected var _buttonSkin:AuroraButtonSkin;
		protected var _listSkin:AuroraContainerSkin;
		
		public function AuroraComboBoxSkin() {
			
		}
		
		public function get buttonSkin():ISkin
		{
			_buttonSkin = new AuroraButtonSkin();
			_buttonSkin.labelAlign = "left";
			_buttonSkin.cornerRadius = 10;
			_buttonSkin.filters = [new DropShadowFilter(.5,90,0,1,0,0)]
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