package org.openPyro.collections
{
	import flash.events.EventDispatcher;
	
	import org.openPyro.collections.events.CollectionEvent;
	import org.openPyro.collections.events.CollectionEventKind;
	import org.openPyro.utils.ArrayUtil;
	import org.openPyro.utils.XMLUtil;
	
	public class XMLCollection extends EventDispatcher implements ICollection
	{
		private var _xml:XML;
		private var _normalizedArray:Array;
		private var _unfilteredNormalizedArray:Array;
		private var _originalNormalizedArray:Array;
		private var _iterator:ArrayIterator;
		
		public function XMLCollection(xml:XML=null)
		{
			_xml = xml;
			_normalizedArray = new Array();
			parseNode(_xml, 0, null);
			_originalNormalizedArray = _normalizedArray.concat();
			_unfilteredNormalizedArray = _normalizedArray.concat();
			_iterator = new ArrayIterator(this);
		}
		
		
		protected function parseNode(node:XML, depth:int, parentNodeDescriptor:XMLNodeDescriptor):void{
			
			var desc:XMLNodeDescriptor = new XMLNodeDescriptor()
			desc.node = node
			desc.depth = depth
			desc.parent = parentNodeDescriptor;
			_normalizedArray.push(desc);
			depth++;
			for(var i:int=0; i<node.children().length(); i++){
				parseNode(node.children()[i], depth, desc);
			}
		}
		
		public function get source():*{
			return _xml;
		}
		
		public function set source(x:*):void{
			_xml = x;
			_normalizedArray = new Array();
			parseNode(_xml, 0, null);
			_unfilteredNormalizedArray = _normalizedArray.concat();
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGED));
		}
		
		public function get normalizedArray():Array{
			return _normalizedArray;
		}
		
		public function get length():int
		{
			return _xml.length();
		}
		
		public function get iterator():IIterator
		{
			return _iterator;
		}
		
		public function getItemIndex(item:Object):int{
			return _normalizedArray.indexOf(item);
		}
		
		public function getOpenChildNodes(item:XMLNodeDescriptor):Array{
			var allChildNodes:Array = getChildNodes(item);
			var visibleChildNodes:Array = new Array()
			while(allChildNodes.length > 0){
				var newNode:XMLNodeDescriptor = allChildNodes.shift();
				visibleChildNodes.push(newNode);
				if(!newNode.isLeaf() && !newNode.open){
					var closedNodeChildren:Array = getChildNodes(newNode);
					for(var i:int=0; i<closedNodeChildren.length; i++){
						if(allChildNodes.indexOf(closedNodeChildren[i]) != -1){
							ArrayUtil.remove(allChildNodes, closedNodeChildren[i]);
						}
					}
				}
			}
			return visibleChildNodes;
		}
		
		/**
		 * Returns all children under a given node in the original
		 * XML.
		 */ 	
		public function getChildNodes(item:XMLNodeDescriptor):Array{
			
			var idx:Number = _unfilteredNormalizedArray.indexOf(item);
			var foundAllChildren:Boolean = false;
			var childNodesArray:Array = new Array();
			while(!foundAllChildren){
				idx++;
				if(idx == this._unfilteredNormalizedArray.length){
					foundAllChildren = true;
					break;
				}
				else{
					var newNode:XMLNodeDescriptor = getItemInUnfilteredAt(idx) as XMLNodeDescriptor;
					if(XMLUtil.isItemParentOf(item.node, newNode.node)){
						childNodesArray.push(newNode);
					}
					else{
						foundAllChildren=true;
					}
				}
			}
			return childNodesArray;
		}
		
		
		public function getItemInUnfilteredAt(idx:int):Object{
			return _unfilteredNormalizedArray[idx];
		}
		public function getItemAt(idx:int):*{
			return _normalizedArray[idx];
		}
		
		public function removeItems(items:Array):void{
			for(var i:int=0; i<items.length; i++){
				ArrayUtil.remove(_normalizedArray,items[i])	
			}
			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			collectionEvent.delta = items;
			collectionEvent.kind = CollectionEventKind.REMOVE;
			dispatchEvent(collectionEvent);
		}
		
		public function addItems(items:Array, parentNode:XMLNodeDescriptor):void{
			var nodeIndex:int = _normalizedArray.indexOf(parentNode);
			ArrayUtil.insertArrayAtIndex(_normalizedArray,items, (nodeIndex+1));
			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			collectionEvent.delta = items;
			collectionEvent.eventNode = parentNode; 
			collectionEvent.kind = CollectionEventKind.ADD;
			dispatchEvent(collectionEvent);	
		}
		
		protected var _filterFunction:Function;
		
		public function set filterFunction(f:Function):void{
			this._filterFunction = f;
		}
		
		public function refresh():void{
			_normalizedArray = _originalNormalizedArray.filter(_filterFunction);
			_unfilteredNormalizedArray = _normalizedArray.concat();
			
			var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			collectionEvent.kind = CollectionEventKind.RESET;
			dispatchEvent(collectionEvent);
			
			/*for(var i:int=0; i<_normalizedArray.length; i++){
				if(newNormalizedArray.indexOf(_normalizedArray[i])==-1){
					items.push(_normalizedArray[i]);
				}
			}
			collectionEvent.delta = items;
			_normalizedArray = newNormalizedArray;
			_unfilteredNormalizedArray = _normalizedArray.concat();
			collectionEvent.kind = CollectionEventKind.REMOVE;
			dispatchEvent(collectionEvent);
			*/
		}
		
		public function getUIDForItemAtIndex(idx:int):String{
			return null;
		}
		
		public function getUIDIndex(uid:String):int{
			return -1;
		}
		
		public function getItemForUID(uid:String):*{
			return null;
		}
		
	}
}