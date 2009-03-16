package org.openPyro.controls.events
{
	import flash.events.Event;
	
	public class ButtonEvent extends Event
	{
		public static const UP:String = "up";
		public static const OVER:String = "over";
		public static const DOWN:String = "down";
		
		public function ButtonEvent(type:String)
		{
			super(type)
		}
	}
}