package org.openPyro.aurora{
	
	import org.openPyro.aurora.skinClasses.GradientRectSkin;
	import org.openPyro.controls.skins.ISliderSkin;
	import org.openPyro.core.UIControl;
	import org.openPyro.painters.Stroke;
	import org.openPyro.skins.ISkin;
	
	public class AuroraSliderSkin implements ISliderSkin
	{
		
		public var trackGradientRotation:Number=0;
		
		private var track:GradientRectSkin;
		private var _thumbSkin:AuroraButtonSkin;
		
		public function AuroraSliderSkin()
		{
		}
	
		public function get thumbSkin():ISkin
		{
			_thumbSkin = new AuroraButtonSkin();
			return _thumbSkin;
		}
		
		public function set skinnedControl(uic:UIControl):void{}
		
		public function get trackSkin():ISkin
		{
			track =  new GradientRectSkin();
			track.stroke = new Stroke(1,0xcccccc)
			track.gradientRotation = trackGradientRotation;
			return track;
		}
		public function dispose():void
		{
			if(_thumbSkin.parent)
			{
				_thumbSkin.parent.removeChild(_thumbSkin);
			}
			_thumbSkin = null;
			if(track.parent){
				track.parent.removeChild(track);
			}
			track = null;
		}
	}
}