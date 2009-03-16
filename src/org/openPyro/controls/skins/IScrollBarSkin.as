package org.openPyro.controls.skins
{
	import org.openPyro.skins.ISkin;
	
	public interface IScrollBarSkin extends ISkin
	{
		function get incrementButtonSkin():ISkin;
		function get decrementButtonSkin():ISkin;
		function get sliderSkin():ISliderSkin;
			
	}
}