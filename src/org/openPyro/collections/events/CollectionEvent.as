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
		 * The data node around near which this event happened.
		 * For example, in case of elements added to a tree the property is used 
		 * to find what the parentNode of the newly added 
		 * branch is.
		 * 
		 * Note: This is not the DisplayObject associated with the data
		 */ 
		 public var eventNode:Object;
		
		public function CollectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
	}
}