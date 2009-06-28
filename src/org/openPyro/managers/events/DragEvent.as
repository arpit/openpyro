package org.openPyro.managers.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class DragEvent extends Event
	{
		public static const DRAG_START:String = "dragStart";
		public static const DRAG_INIT:String = "dragInit";
		public static const DRAG_ENTER:String = "dragEnter";
		public static const DRAG_OVER:String = "dragOver";
		public static const DRAG_EXIT:String = "dragExit";
		public static const DRAG_DROP:String = "dragDrop";
		
		
		public var stageX:Number;
		public var stageY:Number;
		public var dragInitiator:DisplayObject;
		public var mouseYDelta:Number;
		public var mouseXDelta:Number;
		public var data:Object;
		
		public function DragEvent(type:String)
		{
			super(type);
		}

	}
}