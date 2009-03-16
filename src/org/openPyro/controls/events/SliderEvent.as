package org.openPyro.controls.events
{
	import flash.events.Event;

	public class SliderEvent extends Event
	{
		public static const CHANGE:String = "change";
		public static const THUMB_PRESS:String = "thumbPress";
		public static const THUMB_DRAG:String = "thumbDrag";
		public static const THUMB_RELEASE:String = "thumbRelease";
		
		public function SliderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}