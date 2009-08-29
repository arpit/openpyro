package org.openPyro.collections{
	import flash.events.EventDispatcher;
	
	public class CollectionBase extends EventDispatcher{
		
		public function CollectionBase(){
		}
		
		protected var _uids:Array;
		protected var currUIDIndex:int = 0;
		
		/**
		 * Creates a unique identifier for a data element.
		 * This is important since a Collection view (like
		 * List) may be representing an array with multiple
		 * elements with the same value. So matching itemClicked
		 * to the correct itemRenderer cannot be done without
		 * a UID unique to each data item
		 */ 
		protected function createUID():String{
			var uid:String = "item_"+currUIDIndex;
			currUIDIndex++;
			return uid;
		}
		
		/**
		 * Returns the unique id generated for each item in the 
		 * source array
		 */
		public function getUIDForItemAtIndex(idx:int):String{
			if(_uids[idx]){
				return _uids[idx].uid;
			}
			return null;
		}
		
		public function getUIDIndex(uid:String):int{
			for(var i:int=0; i<_uids.length;i++){
				if(_uids[i].uid == uid){
					return i;
				}
			}
			return -1;
		}
		
		public function getItemForUID(uid:String):*{
			for(var i:int=0; i<_uids.length;i++){
				if(_uids[i].uid == uid){
					return _uids[i].sourceItem;
				}
			}
			return null;
		}
		
		
		
	}
}