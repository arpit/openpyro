package org.openPyro.controls.skins
{
	import org.openPyro.skins.ISkin;
	
	public interface IScrollableContainerSkin extends ISkin
	{
		function get verticalScrollBarSkin():IScrollBarSkin;
		function get horizontalScrollBarSkin():IScrollBarSkin;
	}
}