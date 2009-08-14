package org.openPyro.collections
{
	import flash.events.IEventDispatcher;
	
	public interface IIterator extends IEventDispatcher
	{
		function getCurrent():Object;
		function hasNext():Boolean;
		function getNext():*;
		function hasPrevious():Boolean;
		function getPrevious():*;
		function set cursorIndex(idx:int):void;
		function get cursorIndex():int;
		function reset():void;
	}
}