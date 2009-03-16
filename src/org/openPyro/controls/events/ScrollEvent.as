package org.openPyro.controls.events
{
	import flash.events.Event;

	public class ScrollEvent extends Event
	{
		
		public static const SCROLL:String = "scroll";
		public static const CHANGE:String = "change";
		
		public var direction:String;
		public var delta:Number;
		public var value:Number;
		
		public function ScrollEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}