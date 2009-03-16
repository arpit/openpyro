package org.openPyro.layout
{
	import org.openPyro.core.UIContainer;
	
	public interface ILayout
	{
		function set initX(n:Number):void
		function set initY(n:Number):void;
		function set container(c:UIContainer):void
		function layout(children:Array):void;
		function getMaxWidth(children:Array):Number;
		function getMaxHeight(children:Array):Number;
		function set prepare(f:Function):void;
	}
}