package org.openPyro.layout
{
	import flash.utils.Dictionary;
	
	import org.openPyro.controls.listClasses.ListBase;

	public interface IVirtualizedLayout
	{
		function set listBase(object:ListBase):void;
		function get numberOfVerticalRenderersNeededForDisplay():int;
		function get visibleRenderersData():Array;
		function positionRendererMap(map:Dictionary, newlyCreatedRenderers:Array, animate:Boolean):void;
	}
}