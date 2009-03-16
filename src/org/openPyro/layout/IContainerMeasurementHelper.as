package org.openPyro.layout
{
	import org.openPyro.core.UIContainer;
	
	import flash.display.DisplayObject;
	
	public interface IContainerMeasurementHelper
	{
		function calculateSizes(children:Array, container:UIContainer):void;
	}
}