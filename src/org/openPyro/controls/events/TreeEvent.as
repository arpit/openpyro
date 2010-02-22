package org.openPyro.controls.events
{
	import org.openPyro.collections.XMLNodeDescriptor;

	public class TreeEvent extends ListEvent
	{
		public static const ROTATOR_CLICK:String = "rotatorClick";
		public static const ITEM_OPENING:String = "itemOpening";
		public static const ITEM_CLOSING:String = "itemClosing";
		
		
		public var nodeDescriptor:XMLNodeDescriptor;
		
		public function TreeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type);
		}
		
	}
}