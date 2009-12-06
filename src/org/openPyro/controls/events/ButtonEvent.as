package org.openPyro.controls.events
{
	import flash.events.Event;
	
	public class ButtonEvent extends Event
	{
		public static const UP:String = "up";
		public static const OVER:String = "over";
		public static const DOWN:String = "down";
		public static const TOGGLED_ON:String = "toggledOn";
		public static const TOGGLED_OFF:String = "toggledOff";
		
		
		public function ButtonEvent(type:String)
		{
			super(type)
		}
	}
}