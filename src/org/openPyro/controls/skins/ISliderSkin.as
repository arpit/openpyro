package org.openPyro.controls.skins
{
	import org.openPyro.skins.ISkin;
	
	public interface ISliderSkin extends ISkin
	{
		function get trackSkin():ISkin;
		function get thumbSkin():ISkin;
	}
}