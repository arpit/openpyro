package org.openPyro.core.events{
	import flash.events.Event;
	
	/**
	 * The StorageEvent is dispatched by any IStorage
	 * object when storage succeeds or fails.
	 */ 
	public class StorageEvent extends Event{
		
		public function StorageEvent(type:String){
			super(type);
		}
	}
}