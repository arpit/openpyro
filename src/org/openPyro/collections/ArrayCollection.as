package org.openPyro.collections
{
	import org.openPyro.collections.events.CollectionEvent;
	import org.openPyro.collections.events.CollectionEventKind;
	import org.openPyro.utils.ArrayUtil;
	
	import flash.events.EventDispatcher;
	
	public class ArrayCollection extends EventDispatcher implements ICollection
	{
		protected var _originalSource:Array;
		
		public function ArrayCollection(source:Array = null)
		{
			if(!source){
				source = new Array();
			}
			_source = source;
			_originalSource = source;
			_iterator = new ArrayIterator(this);
		}
		
		private var _source:Array;
		private var _iterator:ArrayIterator;
		
		public function set source(array:*):void
		{
			_source = array;
			_originalSource = array;
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
			var lastData:Object 
			if(idx==0 || _source.length==0){
				// insert the data at the beginning
				lastData = null;
			}
			else{
				lastData = _source[idx-1];
			}
			
			
			ArrayUtil.insertArrayAtIndex(_source, items, idx);
			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			collectionEvent.delta = items;
			
			collectionEvent.eventNode = lastData;
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
		
		public function removeItems(items:Array):void{
			
		}
		
		public function set filterFunction(f:Function):void{
			
		}
		
		public function refresh():void{
		
		}
		
	}
}