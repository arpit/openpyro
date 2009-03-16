package org.openPyro.managers.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class DragEvent extends Event
	{
		public static const DRAG_COMPLETE:String = "dragComplete";
		
		public var stageX:Number;
		public var stageY:Number;
		public var dragInitiator:DisplayObject;
		public var mouseYDelta:Number;
		public var mouseXDelta:Number;
		
		public function DragEvent(type:String)
		{
			super(type);
		}

	}
}