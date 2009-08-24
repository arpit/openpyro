package org.openPyro.collections
{
	import flash.events.EventDispatcher;
	
	import org.openPyro.collections.events.CollectionEvent;
	import org.openPyro.collections.events.CollectionEventKind;
	import org.openPyro.utils.ArrayUtil;
	
	public class ArrayCollection extends EventDispatcher implements ICollection
	{
		protected var _source:Array;
		protected var _uids:Array;
		protected var _iterator:ArrayIterator;
		protected var _originalSource:Array;
		
		public function ArrayCollection(source:Array = null)
		{
			if(!source){
				source = [];
			}
			this.source = source;
		}
		
		public function set source(array:*):void
		{
			_source = array;
			_originalSource = array;
			_uids = new Array();
			for(var i:int = 0; i<_source.length; i++){
				_uids.push({uid:getUID(), sourceItem:_source[i]});
			}
			_iterator = new ArrayIterator(this);
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGED));
		}
		
		protected var currUIDIndex:int = 0;
		protected function getUID():String{
			var uid:String = "item_"+currUIDIndex;
			currUIDIndex++;
			return uid;
		}
		
		public function get source():*
		{
			return _source;	
		}
		
		public function get normalizedArray():Array{
			return _source;
		}
		
		public function get length():int
		{
			if(_source){
				return _source.length;
			}
			return 0;
		}
		
		public function addItems(items:Array):void{
			addItemsAt(items, _source.length);
		}
		
		public function addItem(obj:*):void{
			addItems([obj])
		}
		
		public function addItemsAt(items:Array, idx:Number):void{
			var location:int; 
			if(idx==0 || _source.length==0){
				// insert the data at the beginning
				location = -1;
			}
			else{
				location = idx-1;
			}
			
			
			ArrayUtil.insertArrayAtIndex(_source, items, idx);
			
			var newUIDs:Array = []
			for each(var item:* in items){
				newUIDs.push({uid:getUID(), sourceItem:item});
			}
			
			ArrayUtil.insertArrayAtIndex(_uids, newUIDs , idx);
			
			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			collectionEvent.delta = items;
			
			collectionEvent.location = location;
			collectionEvent.kind = CollectionEventKind.ADD;
			dispatchEvent(collectionEvent);	
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
		
		public function get iterator():IIterator
		{
			return _iterator;
		}
		
		public function getItemIndex(ob:Object):int
		{
			return _source.indexOf(ob);
		}
		
		public function getItemAt(index:int):*{
			return _source[index];
		}
		
		public function removeItem(item:*):void{
			removeItems([item]);
		}
		
		public function removeItems(items:Array):void{
			var changed:Boolean = false;
			var delta:Array = [];
			var location:int = NaN;
			for each(var item:* in items){
				var itemIndex:Number = _source.indexOf(item);
				if(itemIndex != -1){
					delta.push(item);
					if(itemIndex < location || isNaN(location)){
						location = itemIndex;
					}
					ArrayUtil.remove(_source, item);
					for each(var ob:Object in _uids){
						if(ob.sourceItem == item){
							ArrayUtil.remove(_uids, ob);
							break;
						}
					}
					
					changed = true;
				}
			}
			if(! changed) return;
			
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			event.kind = CollectionEventKind.REMOVE;
			event.delta = delta;
			event.location = location;
			dispatchEvent(event);
		}
		
		public function set filterFunction(f:Function):void{
			
		}
		
		public function refresh():void{
		
		}
		
		override public function toString():String{
			return this._source.join(",");
		}
		
	}
}