package org.openPyro.aurora{
	import org.openPyro.controls.skins.IScrollBarSkin;
	import org.openPyro.controls.skins.ISliderSkin;
	import org.openPyro.core.Direction;
	import org.openPyro.core.UIControl;
	import org.openPyro.shapes.Triangle;
	import org.openPyro.skins.ISkin;

	public class AuroraScrollBarSkin implements IScrollBarSkin
	{
		
		public var direction:String = Direction.VERTICAL ;
		
		
		public var incrementButtonWidth:Number = 15;
		public var incrementButtonHeight:Number = 15;
		
		public var decrementButtonWidth:Number = 15;
		public var decrementButtonHeight:Number = 15;
		
		private var _incrementButtonSkin:AuroraButtonSkin;
		private var _decrementButtonSkin:AuroraButtonSkin;
		private var _sliderSkin:AuroraSliderSkin;
		
		public function AuroraScrollBarSkin()
		{
		}

		public function get incrementButtonSkin():ISkin
		{
			_incrementButtonSkin = new AuroraButtonSkin();
			if(direction == Direction.VERTICAL){
				_incrementButtonSkin.icon = new Triangle(Direction.DOWN, 6,6);
			}
			else if(direction == Direction.HORIZONTAL){
				_incrementButtonSkin.icon = new Triangle(Direction.RIGHT, 6,6);
			}
			_incrementButtonSkin.width = incrementButtonWidth;
			_incrementButtonSkin.height= incrementButtonHeight;
			return _incrementButtonSkin
		}
		
		public function get decrementButtonSkin():ISkin
		{
			_decrementButtonSkin = new AuroraButtonSkin();
			if(direction == Direction.VERTICAL){
				_decrementButtonSkin.icon = new Triangle(Direction.UP, 6,6);
			}
			else if(direction == Direction.HORIZONTAL){
				_decrementButtonSkin.icon = new Triangle(Direction.LEFT, 6,6);
			}
			_decrementButtonSkin.width = decrementButtonWidth;
			_decrementButtonSkin.height= decrementButtonHeight;
			return _decrementButtonSkin
			
		}
		
		public function set skinnedControl(uic:UIControl):void
		{
		}
		
		public function get sliderSkin():ISliderSkin
		{
			_sliderSkin = new AuroraSliderSkin();
			if(direction == Direction.HORIZONTAL)
			{
				_sliderSkin.trackGradientRotation = Math.PI/2
			}
			return _sliderSkin;
		}
		
		public function dispose():void
		{
			if(_incrementButtonSkin && _incrementButtonSkin.parent)
			{
				_incrementButtonSkin.parent.removeChild(_incrementButtonSkin);
			}
			_incrementButtonSkin = null;
			
			if(_decrementButtonSkin && _decrementButtonSkin.parent)
			{
				_decrementButtonSkin.parent.removeChild(_decrementButtonSkin);
			}
			_decrementButtonSkin = null;
			if(_sliderSkin){
				_sliderSkin.dispose();	
			}
		}
		
	}
}