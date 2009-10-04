package org.openPyro.controls.skins
{
	import org.openPyro.skins.ISkin;
	
	public interface IScrollBarSkin extends ISkin
	{
		function get incrementButtonSkin():ISkin;
		function get decrementButtonSkin():ISkin;
		function get sliderSkin():ISliderSkin;
		
		/**
		 * The width of the Scrollbar. Return NaN if
		 * you want the container to calculate the values.
		 */ 
		function get scrollbarWidth():Number;
		
		/**
		 * The height of the Scrollbar. Return NaN if
		 * you want the container to calculate the values.
		 */ 
		function get scrollbarHeight():Number;	
	}
}