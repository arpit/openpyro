package org.openPyro.collections
{
	import org.openPyro.collections.events.CollectionEvent;
	import org.openPyro.collections.events.CollectionEventKind;
	import org.openPyro.utils.ArrayUtil;
	
	/**
	 * The TreeCollection class is a ICollection that can be used by controls
	 * like Tree etc that represent Heirarchial collections. Under the hood,
	 * the TreeCollection maintains an XMLCollection of the data XML that it
	 * was initialized with and a mappedArrayCollection that is actually reflected
	 * to the UI.
	*/
	public class TreeCollection extends CollectionBase implements ICollection
	{
		private var _xml:XML;
		private var _iterator:ArrayIterator;
		
		private var _mappedArrayCollection:ArrayCollection;
		private var originalDataSource:XMLCollection;
		private var allXMLNodeDescriptors:Array = []
		
		public function TreeCollection(xml:XML=null)
		{
			source = xml;
		}
		
		
		protected function parseNode(node:XML, depth:int, parentNodeDescriptor:XMLNodeDescriptor):void{
			var desc:XMLNodeDescriptor = new XMLNodeDescriptor()
			desc.node = node
			desc.depth = depth
			desc.parent = parentNodeDescriptor;
			_mappedArrayCollection.addItem(node);
			allXMLNodeDescriptors.push(desc);
			depth++;
			_uids.push({uid:createUID(), sourceItem:desc});
			for(var i:int=0; i<node.elements("*").length(); i++){
				parseNode(node.elements("*")[i], depth, desc);
			}
		}
		
		public function get source():*{
			return _xml;
		}
		
		public function set source(x:*):void{
			_xml = x;
			_uids = new Array();
			_mappedArrayCollection = new ArrayCollection();
			allXMLNodeDescriptors = new Array();
			originalDataSource = new XMLCollection(x);
			_iterator = new ArrayIterator(_mappedArrayCollection)
			parseNode(_xml, 0, null);
			
			dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGED));
			
		}
		
		/**
		 * Returns the length of the collection as its seen.
		 */ 
		public function get length():int
		{
			return _mappedArrayCollection.length;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get iterator():IIterator
		{
			return _iterator;
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function getItemIndex(item:Object):int{
			return _mappedArrayCollection.getItemIndex(item);
		}
		
		public function getNodeDescriptorFor(node:XML):XMLNodeDescriptor{
			for(var i:int=0; i<allXMLNodeDescriptors.length; i++){
				var src:XMLNodeDescriptor = allXMLNodeDescriptors[i];
				if(src.node == node){
					return src
				}
			}
			return null;
		}
		
		public function getItemAt(idx:int):*{
			return _mappedArrayCollection.getItemAt(idx);
		}
		
		
		public function closeNode(nodeDescriptor:XMLNodeDescriptor):void{
			var items:Array = [];
			nodeDescriptor.open = false;
			items = getChildNodesArray(nodeDescriptor.node, items);
			removeItems(items);
		}
		
		protected function getChildNodesArray(node:XML, arr:Array):Array{
			for(var i:int=0; i<node.elements("*").length(); i++){
				arr.push(node.elements("*")[i]);
				if(node.hasComplexContent()){
					getChildNodesArray(node.elements("*")[i], arr);
				}
			}
			return arr;
		}
		
		
		/*
		TODO: This is very close to a copy paste
		from ArrayCollection
		*/
		public function removeItems(items:Array):void{
			var changed:Boolean = false;
			var delta:Array = [];
			var location:int = NaN;
			for each(var item:* in items){
				
				var itemIndex:Number = getItemIndex(item);
				if(itemIndex != -1){
					var nodeDes:XMLNodeDescriptor = getNodeDescriptorFor(item);
					delta.push(nodeDes);
					if(itemIndex < location || isNaN(location)){
						location = itemIndex;
					}
					_mappedArrayCollection.removeItem(item);
					for each(var ob:Object in _uids){
						if(ob.sourceItem == nodeDes){
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
		
		public function openNode(xmlNodeDescriptor:XMLNodeDescriptor):void{
			xmlNodeDescriptor.open = true;
			
			var addedEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGED);
			addedEvent.kind = CollectionEventKind.ADD;
			addedEvent.location = getItemIndex(xmlNodeDescriptor.node)+1;
			
			var newNodes:Array = [];
			var newUIDObs:Array = [];
			
			getSubtree(xmlNodeDescriptor.node, newUIDObs, newNodes);
			
			_mappedArrayCollection.addItemsAt(newNodes,  addedEvent.location);
			ArrayUtil.insertArrayAtIndex(_uids, newUIDObs, addedEvent.location);
			addedEvent.delta = newNodes;
			dispatchEvent(addedEvent);
		}
		
		private function getSubtree(parentNode:XML, newUIDObs:Array, newNodes:Array):void{
			for(var j:int=0; j<parentNode.elements("*").length(); j++){
				var newNode:XML = XML(parentNode.elements("*")[j]);
				var nodeDescriptor:XMLNodeDescriptor = getNodeDescriptorFor(newNode);
				newUIDObs.push({uid:createUID(), sourceItem:nodeDescriptor});
				newNodes.push(newNode);
				if(nodeDescriptor.open && !nodeDescriptor.isLeaf()){
					getSubtree(newNode, newUIDObs, newNodes);
				}
			}
		}
		
		public function addItemsUnderNode(items:Array, parentNode:XMLNodeDescriptor):void{
			
		}
		
		protected var _filterFunction:Function;
		
		public function set filterFunction(f:Function):void{
			this._filterFunction = f;
		}
		
		public function refresh():void{
		}
		
		public function removeItem(item:*):void{
			removeItems([item]);
		}
		
		public function addItem(obj:*):void{
			addItems[obj];
		}
		public function addItems(items:Array):void{
			addItemsAt(items,this.length)
		}
		
		public function addItemsAt(items:Array, idx:Number):void{
			
		}
		
	}
}