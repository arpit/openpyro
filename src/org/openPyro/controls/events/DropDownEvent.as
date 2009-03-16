package org.openPyro.controls.events
{
	import flash.events.Event;
	
	public class DropDownEvent extends Event
	{
		public static const OPEN:String = "open";
		public static const CLOSE:String = "close";
		
		public function DropDownEvent(type:String)
		{
			super(type);
		}
	}
}