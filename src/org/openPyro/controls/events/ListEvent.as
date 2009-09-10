package org.openPyro.controls.events
{
	import flash.events.Event;
	
	public class ListEvent extends Event
	{
		public static const CHANGE:String = "change";
		public static const ITEM_CLICK:String = "itemClick";
		public static const RENDERERS_REPOSITIONED:String = "renderersRepositioned";
		
		public function ListEvent(type:String)
		{
			super(type)
		}
		
		override public function clone():Event
		{
			var listEvent:ListEvent =  new ListEvent(this.type)
			return listEvent;
		}
		

	}
}