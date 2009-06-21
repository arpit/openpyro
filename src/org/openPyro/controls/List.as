package org.openPyro.controls
{
	import org.openPyro.collections.CollectionHelpers;
	import org.openPyro.collections.ICollection;
	import org.openPyro.collections.IIterator;
	import org.openPyro.collections.events.CollectionEvent;
	import org.openPyro.collections.events.CollectionEventKind;
	import org.openPyro.collections.events.IteratorEvent;
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.controls.listClasses.BaseListData;
	import org.openPyro.controls.listClasses.DefaultListRenderer;
	import org.openPyro.controls.listClasses.IListDataRenderer;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.IDataRenderer;
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.ObjectPool;
	import org.openPyro.core.UIContainer;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.layout.VLayout;
	import org.openPyro.utils.ArrayUtil;
	import org.openPyro.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	[Event(name="change", type="org.openPyro.controls.events.ListEvent")]
	[Event(name="itemClick", type="org.openPyro.controls.events.ListEvent")]
	
	public class List extends UIContainer
	{
		
		/**
		 * Resets scrolls when the dataProvider changes
		 */ 
		public var autoResetScrollOnDataProviderChange:Boolean = true
		
		
		public function List()
		{
			super();
			this._labelFunction = StringUtil.toStringLabel
			_layout = new VLayout();
		}
		
		protected var _labelFunction:Function  = StringUtil.toStringLabel
		public function set labelFunction(func:Function):void{
			_labelFunction = func;
			/*
			 * TODO: Change label functions on all itemRenderers
			 */	
		}
		
		public function get labelFunction():Function{
			return _labelFunction;
		}
		
		
		override protected function createChildren():void
		{
			if(!this._rendererPool){
				var cf:ClassFactory = new ClassFactory(DefaultListRenderer);
				cf.properties = {percentWidth:100, height:25};
				_rendererPool = new ObjectPool(cf)
			}
		}
		
		protected var renderers:Array = new Array();
		protected var _rendererPool:ObjectPool;
		protected var selectedRenderer:DisplayObject;
		
		protected var _dataProvider:ICollection;
		protected var _originalRawDataProvider:Object;
		
		public function set dataProvider(dp:Object):void{
			if(dp == _originalRawDataProvider){
				return;
			}
			_originalRawDataProvider =dp
			if(autoResetScrollOnDataProviderChange){
				verticalScrollPosition = 0
				horizontalScrollPosition=0
			}
			if(_dataProvider){
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGED, onSourceCollectionChanged);
			}
			convertDataToCollection(dp)
			_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGED, onSourceCollectionChanged);
			createRenderers();
		}
		
		public function get originalRawDataProvider():Object{
			return _originalRawDataProvider;
		}
		
		protected function createRenderers():void{
			if(!_rendererPool) return;
			returnRenderersToPool()
			var renderer:DisplayObject;
			
			var iterator:IIterator = _dataProvider.iterator;
			iterator.reset();
			
			while(iterator.hasNext())
			{
				var listData:Object = iterator.getNext();
				renderer = DisplayObject(_rendererPool.getObject());
				setRendererData(renderer, listData, iterator.cursorIndex);
				renderers.push(renderer);
				contentPane.addChildAt(renderer,0);
				
			}
			// reset the iterator to -1
			iterator.reset()
			
			displayListInvalidated = true;
			this.forceInvalidateDisplayList = true;
			this.invalidateSize();
			this.invalidateDisplayList();
			_selectedIndex = -1;
		}
		
		public function get dataProvider():Object{
			return _dataProvider;
		}
		
		/**
		 * Converts an Array to ArrayCollection or xml to 
		 * XMLCollection. Written as a separate function so 
		 * that overriding classes may massage the data as 
		 * needed
		 */ 
		protected function convertDataToCollection(dp:Object):void{
			this._dataProvider = CollectionHelpers.sourceToCollection(dp);
		}
		
		private function onSourceCollectionChanged(event:CollectionEvent):void{
		
			if(event.kind == CollectionEventKind.REMOVE){
				handleDataProviderItemsRemoved(event)
			}
			
			else if(event.kind == CollectionEventKind.ADD){
				handDataProviderItemsAdded(event)
			}
			else if(event.kind == CollectionEventKind.RESET){
				createRenderers();	
			}
			
			this.displayListInvalidated = true
			this.layoutInvalidated = true;
			this.invalidateSize()
		}
		
		protected function handleDataProviderItemsRemoved(event:CollectionEvent):void
		{
			var childNodesData:Array = event.delta;
			
			var renderer:DisplayObject
			for(var i:int=0; i<childNodesData.length; i++){
					renderer = dataToItemRenderer(childNodesData[i]);
					if(renderer && renderer.parent){
						renderer.parent.removeChild(renderer);
						ArrayUtil.remove(renderers, renderer);
					}
				}
		}
		
		protected function handDataProviderItemsAdded(event:CollectionEvent):void
		{
			var childNodesData:Array = event.delta;
			var renderer:DisplayObject
			var newRenderer:DisplayObject
			var eventSourceData:Object = event.eventNode;
			var listData:Object
			var parentNode:DisplayObject
			
			var tgtY:Number;
			
			if(!eventSourceData){
				tgtY = 0;
				for(var l:int=childNodesData.length-1; l>=0; l--){
					//(this.renderers.length == 0)?0:this.renderers[this.renderers.length-1].y
					newRenderer = _rendererPool.getObject() as DisplayObject;
					listData = childNodesData[l]
					setRendererData(newRenderer, listData, l);
					this.contentPane.addChild(newRenderer);	
					
					newRenderer.y = tgtY; 
					
					renderers.unshift(newRenderer);	
					
				}
				
			}
			
			else{
			//trace(XMLNodeDescriptor(eventSourceData).nodeString);	
			for(var j:int=0; j<renderers.length; j++){
				var r:DisplayObject = renderers[j];
			
				if(IDataRenderer(r).data == eventSourceData){
					parentNode = r;
					var positionRefNode:DisplayObject = parentNode;
					for(var k:int=childNodesData.length-1; k>=0; k--){
						newRenderer = _rendererPool.getObject() as DisplayObject;
						listData = childNodesData[k]
						setRendererData(newRenderer, listData, k);
						this.contentPane.addChildAt(newRenderer,0);
						newRenderer.y = positionRefNode.y - newRenderer.height;
						positionRefNode = newRenderer;
						ArrayUtil.insertAt(renderers, (j+1), newRenderer);	
					}
					break;
				}
			}
			}
			this.forceInvalidateDisplayList=true;
			invalidateSize();
			invalidateDisplayList();			
		}
		
		protected function returnRenderersToPool():void{
			var renderer:DisplayObject
			while(renderers.length > 0)
			{
				renderer = renderers.shift();
				if(renderer.parent)
				{
					renderer.parent.removeChild(renderer);
				}
				_rendererPool.returnToPool(renderer);
			}
		}
		
		protected function setRendererData(renderer:DisplayObject, data:Object, index:int):void
		{
			if(renderer is IListDataRenderer){
				var listRenderer:IListDataRenderer = renderer as IListDataRenderer;
				var baseListData:BaseListData = new BaseListData()
				baseListData.list = this;
				baseListData.rowIndex = index;
				
				listRenderer.baseListData = baseListData;
				
				/*
				 If the list Renderer is a measurable control,
				 make sure the renderer is initialized before you
				 set the data property. That way all children have
				 been created and can be populated w/ data.
				 */ 
				if(listRenderer is MeasurableControl){
					if(MeasurableControl(listRenderer).initialized){
						listRenderer.data = data;
					}
					else{
						MeasurableControl(listRenderer).addEventListener(PyroEvent.INITIALIZE, 
							function(event:PyroEvent):void{
								listRenderer.data = data;
								MeasurableControl(listRenderer).removeEventListener(PyroEvent.INITIALIZE, arguments.callee);
							})
					}
				}
				else{
					listRenderer.data = data;
				}
			}
			renderer.addEventListener(MouseEvent.CLICK, handleRendererClick);
		}
		
		
		protected function handleRendererClick(event:MouseEvent):void
		{
            /*
            // dont react if the click is coming from a currently 
            // selected child.
            if(!(event.currentTarget is IListDataRenderer) || IListDataRenderer(event.currentTarget).selected) return;
             */
            if(!(event.currentTarget is IListDataRenderer)) return;

            if(selectedRenderer && selectedRenderer is IListDataRenderer){
                IListDataRenderer(selectedRenderer).selected = false;
            }

            var newIndex:int = itemRendererToIndex(event.currentTarget as DisplayObject);
            if(newIndex != selectedIndex){
                selectedIndex = newIndex;
                selectedRenderer = event.currentTarget as DisplayObject;
                if(selectedRenderer is IListDataRenderer){
                    IListDataRenderer(selectedRenderer).selected = true;
                }
            }

            dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK));
		}
		
		
		public function dataToItemRendererIndex(data:*):int
		{
			for(var i:uint=0; i<renderers.length; i++){
				if(IDataRenderer(renderers[i]).data == data){
					return i
				}
			}
			return -1;
		}
		
		public function dataToItemRenderer(data:*):DisplayObject{
			for(var i:uint=0; i<renderers.length; i++){
				if(IDataRenderer(renderers[i]).data == data){
					return renderers[i]
				}
			}
			return null;
		}
		
		public function itemRendererToIndex(renderer:DisplayObject):int
		{
            return renderers.indexOf(renderer);
		}
		
		
		protected var _selectedItem:Object;
		
		public function get selectedItem():Object
		{
			if(_selectedIndex == -1){
				return null;
			}
			return IDataRenderer(renderers[_selectedIndex]).data;
		}
		
		public function set selectedItem(item:Object):void
		{
			// TODO: 
			// right now i am assuming all data is rendererd 
			// This will change when object pool is connected
			// to the renderers.
			
			
			if(!renderers || renderers.length == 0)
			{
				throw new Error("LIST does not have renderers")
				return;
			}
			for(var i:uint=0; i<renderers.length; i++)
			{
				if (item == IDataRenderer(renderers[i]).data)
				{
					if(renderers[i] is IListDataRenderer)
					{
						IListDataRenderer(renderers[i]).selected = true;
					}
					return;
				}
			}
			
			throw new Error("Selected item not found in List data");
		}
		
		protected var _selectedIndex:int = -1;
		
		public function set selectedIndex(index:int):void
		{
			if(_selectedIndex == index) return;
			if(this.selectedRenderer && this.selectedRenderer is IListDataRenderer){
				IListDataRenderer(selectedRenderer).selected = false;
			}
			
			_selectedIndex = index;

			dispatchEvent(new ListEvent(ListEvent.CHANGE));
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set itemRenderer(itemRenderer:ClassFactory):void{
			destroyOldRenderers();
			
			_rendererPool = new ObjectPool(itemRenderer);
			
			renderers = new Array();
			var renderer:DisplayObject
			if(_dataProvider)
			{
                var it:IIterator =_dataProvider.iterator;
                it.reset();
				for(var j:uint=0; j<_dataProvider.length; j++)
				{
					renderer = DisplayObject(_rendererPool.getObject());
					renderers.push(renderer);
					contentPane.addChildAt(renderer,0);
					setRendererData(renderer, it.getNext(), j)
				}		
			}
			this.displayListInvalidated = true;
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		protected function destroyOldRenderers():void{
			var renderer:DisplayObject
			if(renderers){
				while(renderers.length > 0){
					renderer = renderers.shift();
					if(renderer.parent){
						renderer.parent.removeChild(renderer);
						renderer = null;
					}
				}
			}
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
			
		override public function get layoutChildren():Array{
			return this.renderers;
		}
		
		
		
	}
}
