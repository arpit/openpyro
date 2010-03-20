package org.openPyro.controls.listClasses
{
	import org.openPyro.core.IDataRenderer;
	
	public interface IListDataRenderer extends IDataRenderer
	{
		function set baseListData(data:BaseListData):void;
		function set selected(b:Boolean):void;
		function get selected():Boolean;
		
	}
}