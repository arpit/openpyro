package org.openPyro.collections.events
{
	import flash.events.Event;

	public class IteratorEvent extends Event
	{
		public static const ITERATOR_MOVED:String = "iteratorMoved";
		public static const ITERATOR_RESET:String = "iteratorReset";
		
		public function IteratorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}