package org.openPyro.collections.events
{
	import flash.events.Event;

	public class CollectionEvent extends Event
	{
		public static const COLLECTION_CHANGED:String = "collectionChanged";
		
		/**
		 * The difference between the old state and the new state
		 */ 
		public var delta:Array;
		
		/**
		 * 
		 */
		 public var kind:String; 
		 
		 /**
		 * The zero-base index in the collection of the item(s) specified in the items property.
		 */ 
		 public var location:int;
		
		public function CollectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
	}
}