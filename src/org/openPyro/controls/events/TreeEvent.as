package org.openPyro.controls.events
{
	import org.openPyro.collections.XMLNodeDescriptor;

	public class TreeEvent extends ListEvent
	{
		public static const ROTATOR_CLICK:String = "rotatorClick";
		public static const ITEM_OPEN:String = "itemOpen";
		public static const ITEM_CLOSE:String = "itemClose";
		
		
		public var nodeDescriptor:XMLNodeDescriptor;
		
		public function TreeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type);
		}
		
	}
}