package org.openPyro.containers.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class DividerEvent extends Event
	{
		
		public static const DIVIDER_DOUBLE_CLICK:String = "dividerDoubleClick";
		public static const DIVIDER_CLICK:String = "dividerClick";
		public static const DIVIDER_DROP:String = "dividerDrop";
		
		public var divider:DisplayObject;
		public var dividerIndex:Number;
		
		public function DividerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}