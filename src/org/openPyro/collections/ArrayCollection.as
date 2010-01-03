package org.openPyro.collections
{
	import org.openPyro.collections.events.CollectionEvent;
	import org.openPyro.collections.events.CollectionEventKind;
	import org.openPyro.utils.ArrayUtil;
	
	public class ArrayCollection extends CollectionBase implements ICollection
	{
		protected var _source:Array;
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
				_uids.push({uid:createUID(), sourceItem:_source[i]});
			}
			_iterator = new ArrayIterator(this);
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGED));
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
				newUIDs.push({uid:createUID(), sourceItem:item});
			}
			
			ArrayUtil.insertArrayAtIndex(_uids, newUIDs , idx);
			
			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			collectionEvent.delta = items;
			
			collectionEvent.location = location;
			collectionEvent.kind = CollectionEventKind.ADD;
			dispatchEvent(collectionEvent);	
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
		
		public function removeItemAt(index:int):void{
			var item:* = _source[index];
			ArrayUtil.removeItemAt(_source, index);
			var evt:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			evt.kind = CollectionEventKind.REMOVE;
			evt.delta = [item];
			evt.location = index;
			dispatchEvent(evt);
		}
		
		public function removeItem(item:*):void{
			removeItems([item]);
		}
		
		public function removeAll():void{
			removeItems(_source.slice());
		}
		
		public function removeItems(items:Array):void{
			var changed:Boolean = false;
			var delta:Array = [];
			var location:int = NaN;
			for each(var item:* in items){
				var itemIndex:Number = getItemIndex(item);
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