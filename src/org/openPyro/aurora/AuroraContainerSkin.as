package org.openPyro.aurora{
	import org.openPyro.aurora.AuroraScrollBarSkin;
	import org.openPyro.controls.skins.IScrollBarSkin;
	import org.openPyro.controls.skins.IScrollableContainerSkin;
	import org.openPyro.core.Direction;
	import org.openPyro.core.UIControl;
	import org.openPyro.skins.ISkin;

	public class AuroraContainerSkin implements IScrollableContainerSkin
	{	
		
		private var _horizontalScrollBarSkin:AuroraScrollBarSkin;
		private var _verticalScrollBarSkin:AuroraScrollBarSkin;
		
		public function AuroraContainerSkin() {	
			
		}
		
		public function get verticalScrollBarSkin():IScrollBarSkin
		{
			_verticalScrollBarSkin = new AuroraScrollBarSkin()
			_verticalScrollBarSkin.direction = Direction.VERTICAL;
			return _verticalScrollBarSkin;
		}
		
		public function get horizontalScrollBarSkin():IScrollBarSkin
		{
			_horizontalScrollBarSkin = new AuroraScrollBarSkin();
			_horizontalScrollBarSkin.direction = Direction.HORIZONTAL;
			return _horizontalScrollBarSkin;
		}
		
		public function set skinnedControl(uic:UIControl):void
		{
		}
		
		public function dispose():void
		{
			_verticalScrollBarSkin.dispose();
			_horizontalScrollBarSkin.dispose();
		}
				
	}
}