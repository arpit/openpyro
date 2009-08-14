package org.openPyro.collections
{
	import org.openPyro.collections.events.CollectionEvent;
	import org.openPyro.collections.events.IteratorEvent;
	
	import flash.events.EventDispatcher;
	
	public class ArrayIterator extends EventDispatcher implements IIterator
	{
		protected var _array:Array;
		protected var _collection:ICollection;
		
		public function ArrayIterator(collection:ICollection){
			_collection = collection;
			collection.addEventListener(CollectionEvent.COLLECTION_CHANGED, onCollectionChanged);
			setSource()
		}
		
		private function onCollectionChanged(event:CollectionEvent):void{
			setSource()
		}
		
		protected function setSource():void{
			_array = _collection.normalizedArray as Array;
		}
		
		private var _cursorIndex:int = -1
		
		public function getCurrent():Object{
			return _array[_cursorIndex];
		}
		
		
		public function hasNext():Boolean{
			return _cursorIndex < (_array.length - 1);
		}
		public function getNext():*{
			_cursorIndex++;
			return _array[_cursorIndex];
		}	
		public function hasPrevious():Boolean{
			return _cursorIndex > 0;
		}
		public function getPrevious():*{
			_cursorIndex--;
			return _array[_cursorIndex];
		}
		
		
		public function set cursorIndex(idx:int):void{
			if(_cursorIndex != idx){
				_cursorIndex = idx;
				dispatchEvent(new IteratorEvent(IteratorEvent.ITERATOR_MOVED));
			}
		}
		
		public function get cursorIndex():int{
			return _cursorIndex;
		}
		
		public function get normalizedArray():Array{
			return _array;
		}
		
		public function reset():void{
			_cursorIndex = -1;
			dispatchEvent(new IteratorEvent(IteratorEvent.ITERATOR_RESET));
		}
	}
}