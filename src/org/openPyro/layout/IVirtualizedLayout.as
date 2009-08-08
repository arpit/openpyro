package org.openPyro.layout
{
	import flash.utils.Dictionary;
	
	import org.openPyro.controls.events.ScrollEvent;

	public interface IVirtualizedLayout
	{
		function get numberOfVerticalRenderersNeededForDisplay():int;
		function get visibleRenderers():Array;
		function positionRendererMap(map:Dictionary):void;
	}
}