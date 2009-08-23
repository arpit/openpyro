package org.openPyro.collections
{
	import flash.events.IEventDispatcher;
	
	public interface ICollection extends IEventDispatcher
	{
		function get length():int;
		function get normalizedArray():Array;
		function get iterator():IIterator;
		function set filterFunction(f:Function):void
		function refresh():void;
		function getItemAt(index:int):*
		function getUIDForItemAtIndex(idx:int):String;
		function getUIDIndex(uid:String):int;
		function getItemForUID(uid:String):*;
		
		/**
		 * The dataToIndex function returns the index
		 * of the data as it appears witin the ICollection's
		 * source after all filters have been applied
		 */ 
		function getItemIndex(data:Object):int;
		//function removeItem(data:Object):void;
	}
}