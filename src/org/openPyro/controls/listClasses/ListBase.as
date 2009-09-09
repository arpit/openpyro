package org.openPyro.controls.listClasses
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.openPyro.collections.CollectionHelpers;
	import org.openPyro.collections.ICollection;
	import org.openPyro.collections.events.CollectionEvent;
	import org.openPyro.collections.events.CollectionEventKind;
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.IDataRenderer;
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.ObjectPool;
	import org.openPyro.core.UIContainer;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.layout.ILayout;
	import org.openPyro.layout.IVirtualizedLayout;
	import org.openPyro.painters.IPainter;
	import org.openPyro.painters.Stroke;
	import org.openPyro.painters.StrokePainter;
	import org.openPyro.utils.StringUtil;

	/**
	 * The event dispatched when an item is clicked. This event is always broadcast
	 * whether the selectedIndex has changed or not, unlike the change event.
	 */ 
	[Event (name="itemClick", type="org.openPyro.controls.events.ListEvent")]
	
	/**
	 * The event dispatched when the selectedIndex property changes.
	 */ 
	[Event (name="change", type="org.openPyro.controls.events.ListEvent")]

	/**
	 * The ListBase class is the base class for all classes that can use
	 * renderer recycling algorithm for displaying a lot of data. ListBase 
	 * classes can have the IVirualizedLayout layouts applied to them.
	 */ 
	public class ListBase extends UIContainer
	{
		
		public function ListBase()
		{
			super();
			if(_labelFunction == null){
				this._labelFunction = StringUtil.toStringLabel
			}
			
		}
		
		/**
		 * Overrides the <code>UIContainer</code>'s default layout
		 * setter to use IVirtualizedLayouts. 
		 * 
		 * Note: This will throw an Error if the layout being passed
		 * in is not a <code>IVirtualizedLayout</code>
		 * 
		 * @see org.openpyro.layouts.IVirtualizedLayout
		 */ 
		override public function set layout(l:ILayout):void{
			super.layout = l;
			IVirtualizedLayout(l).listBase = this;
		}
		
		protected var _dataProvider:Object;
		protected var _rendererPool:ObjectPool;
		
		/**
		 * A dictionary of renderers mapped with the data they represent
		 * as keys.
		 */
		public var visibleRenderersMap:Dictionary = new Dictionary();
		
		public function set dataProvider(src:Object):void{
			if(_dataProvider == src) return;
			_dataProvider = src;
			
			/*
			 * Reset the scroll positions 
			 */
			verticalScrollPosition = 0;
			horizontalScrollPosition = 0;
			_selectedIndex = -1;
			_selectedItem = null;
			
			if(_dataProviderCollection){
				_dataProviderCollection.removeEventListener(CollectionEvent.COLLECTION_CHANGED, onSourceCollectionChanged);
			}
			convertDataToCollection(src);
			_dataProviderCollection.addEventListener(CollectionEvent.COLLECTION_CHANGED, onSourceCollectionChanged);
			
			removeAllRenderers();
			
			displayListInvalidated =true;
			needsReRendering = true;
			forceInvalidateDisplayList = true;
			invalidateSize();
			invalidateDisplayList();
		}
		public function get dataProvider():Object{
			return _dataProvider;
		}
		
		protected function removeAllRenderers():void{
			for (var uid:String in this.visibleRenderersMap){
				var renderer:DisplayObject = this.visibleRenderersMap[uid];
				delete(this.visibleRenderersMap[uid]);
				renderer.parent.removeChild(renderer);
				this.rendererPool.returnToPool(renderer);
			}
		}
		
		protected var animateRenderers:Boolean = false;
				
		/**
		 * Function invoked when the source dataCollection changes by either having items added
		 * or removed.
		 */ 
		protected function onSourceCollectionChanged(event:CollectionEvent):void{
			if(event.kind == CollectionEventKind.REMOVE){
				animateRenderers = true;
				handleItemsRemoved(event)
			}
			else if(event.kind == CollectionEventKind.ADD){
				animateRenderers = true;
				handleItemsAdded(event);
			}
		}
		
		protected var _labelFunction:Function
		
		public function set labelFunction(func:Function):void{
			_labelFunction = func;
		}
		
		public function get labelFunction():Function{
			return _labelFunction;
		}
		
		protected function handleItemsRemoved(event:CollectionEvent):void{
			var items:Array = event.delta;
			var needsEventDispatch:Boolean = false;
			if(event.location < _selectedIndex){
				_selectedIndex-=items.length;
				needsEventDispatch = true;
			}
			for each(var item:* in items){
				if(item == this._selectedItem){
					this.selectedIndex = -1;
					needsEventDispatch = false;
				}
				for (var uid:String in this.visibleRenderersMap){
					if(IListDataRenderer(this.visibleRenderersMap[uid]).data == item){
						
						var renderer:DisplayObject = this.visibleRenderersMap[uid];
						delete(this.visibleRenderersMap[uid]);
						renderer.parent.removeChild(renderer);
						
						this.rendererPool.returnToPool(renderer);
					}
				}
			}
			
			needsReRendering = true;
			forceInvalidateDisplayList = true;
			invalidateSize();
			invalidateDisplayList();
			
			if(needsEventDispatch){
				var listEvent:ListEvent = new ListEvent(ListEvent.CHANGE);
				dispatchEvent(listEvent);
			}
			
			viewportInvalidated = true;
			
		}
		
		protected var viewportInvalidated:Boolean = false;
		
		protected function handleItemsAdded(event:CollectionEvent):void{
			if(event.location < _selectedIndex){
				selectedIndex = _selectedIndex+event.delta.length;
			}
			forceInvalidateDisplayList = true;
			displayListInvalidated = true;
			needsReRendering = true;
			viewportInvalidated = true;
			invalidateSize();
			invalidateDisplayList();	
		}
		
		protected var _dataProviderCollection:ICollection;
		
		/**
		 * Converts an Array to ArrayCollection or xml to 
		 * XMLCollection. Written as a separate function so 
		 * that overriding classes may massage the data as 
		 * needed
		 */ 
		protected function convertDataToCollection(dp:Object):void{
			this._dataProviderCollection = CollectionHelpers.sourceToCollection(dp);
		}
		
		public function get dataProviderCollection():ICollection{
			return _dataProviderCollection;
		}
		
		private var borderRect:Sprite;
		override protected function createChildren() : void{
			super.createChildren();
			borderRect = new Sprite();
			$addChild(borderRect);
		}
		
		
		protected var _itemRendererFactory:ClassFactory;
		public function set itemRenderer(factory:ClassFactory):void{
			// clear old stuff
			if(_rendererPool){
				_rendererPool.clear();
			}
			for each(var renderer:DisplayObject in visibleRenderersMap){
				renderer.parent.removeChild(renderer);
				renderer = null;
			}
			//add new stuff
			_rendererPool = new ObjectPool(factory);
			_itemRendererFactory = factory;
			needsReRendering = true
		}
		
		/**
		 * Returns the ObjectPool being used to manage the 
		 * itemRenderers
		 */ 
		public function get rendererPool():ObjectPool{
			return _rendererPool;
		}
		
		protected var _needsReRendering:Boolean = false;
		
		public function get needsReRendering():Boolean{
			return _needsReRendering;
		}
		
		public function set needsReRendering(b:Boolean):void{
			_needsReRendering = b;
			if(_needsReRendering){
				this.invalidateSize();
			}
		}
		
		override public function initialize() : void{
			super.initialize();
			if(_needsReRendering){
				needsReRendering=true;
			}
		}
		
		override public function queueValidateDisplayList(event:PyroEvent=null):void{
			super.queueValidateDisplayList(event);
			if(!_dataProvider || !_itemRendererFactory || !_needsReRendering || isNaN(height) || isNaN(width)){
				return;
			}
			_needsReRendering = false;
			renderListItems();
			
			
		}
		
		/**
		 * Array that maintains a list of the newlyCreatedRenderers.
		 */
		protected var newlyCreatedRenderers:Array = [];
		
		protected function createNewRenderersAndMap(newRenderersUIDs:Array):void{
			var newRendererMap:Dictionary = new Dictionary();
			for(var uid:String in this.visibleRenderersMap){
				if(newRenderersUIDs.indexOf(uid) == -1){
					var unusedRenderer:DisplayObject = DisplayObject(visibleRenderersMap[uid]);
					unusedRenderer.parent.removeChild(unusedRenderer);
					rendererPool.returnToPool(unusedRenderer);
				}
				else{
					newRendererMap[uid] = visibleRenderersMap[uid];
				}
			}
			
			newlyCreatedRenderers = [];
			
			for(var i:int=0; i<newRenderersUIDs.length; i++){
				var newRendererUID:String = newRenderersUIDs[i];
					
				if(!newRendererMap[newRendererUID]){
					var newRenderer:DisplayObject = createNewRenderer(newRendererUID, i)
					newRendererMap[newRendererUID] = newRenderer;
				}
			}
			this.visibleRenderersMap = newRendererMap;
		}
		
		/**
		 * Creates a new renderer for a given UID and rowIndex
		 * 
		 * Todo: this could use a cleaner signiture for easier extensions
		 */ 
		protected function createNewRenderer(newRendererUID:String,rowIndex:Number):DisplayObject{
			var newRenderer:DisplayObject = rendererPool.getObject() as DisplayObject;
			newlyCreatedRenderers.push(newRenderer);
			newRenderer.addEventListener(MouseEvent.CLICK, handleRendererMouseClick);
			contentPane.addChildAt(newRenderer,0);
			if(newRenderer is MeasurableControl){
				MeasurableControl(newRenderer).doOnAdded();
			}
			if(newRenderer is IListDataRenderer){
				var listRenderer:IListDataRenderer = newRenderer as IListDataRenderer;
				var baseListData:BaseListData = new BaseListData()
				baseListData.list = this;
				baseListData.rowIndex = rowIndex;
				listRenderer.baseListData = baseListData;
				if(_dataProviderCollection.getUIDForItemAtIndex(_selectedIndex) == newRendererUID){
					listRenderer.selected = true;	
				}
				else{
					listRenderer.selected = false;
				}
			}
			if(newRenderer is IDataRenderer){
				IDataRenderer(newRenderer).data = _dataProviderCollection.getItemForUID(newRendererUID);
			}
			return newRenderer;
		}
		
		protected function renderListItems():void{
			var visibleRendererData:Array = IVirtualizedLayout(this.layout).visibleRenderersData;
			createNewRenderersAndMap(visibleRendererData);
			IVirtualizedLayout(layout).positionRendererMap(this.visibleRenderersMap, newlyCreatedRenderers, animateRenderers);
			animateRenderers = false;
			displayListInvalidated = true;
			invalidateDisplayList();
		}	
		
		protected var _rowHeight:Number = NaN;
		
		public function set rowHeight(value:Number):void{
			_rowHeight = value
		}
		
		/**
		 * The height of each row. If the value is not explicitly set,
		 * it is calculated a new itemRenderer is created and measured
		 */ 
		public function get rowHeight():Number{
			if(isNaN(_rowHeight)){
				if(_rendererPool){
					var testWithRenderer:DisplayObject = DisplayObject(_rendererPool.getObject());
					_rowHeight = testWithRenderer.height;
					_rendererPool.returnToPool(testWithRenderer);
				}
			}
			return _rowHeight;
		}
		
		protected var _columnWidth:Number = NaN;
		public function get columnWidth():Number{
			if(isNaN(_columnWidth)){
				if(_columnWidth){
					var testWithRenderer:DisplayObject = DisplayObject(_rendererPool.getObject());
					_columnWidth = testWithRenderer.width;
					_rendererPool.returnToPool(testWithRenderer);
				}
			}
			return _columnWidth;
		}

		public function set columnWidth(v:Number):void{
			_columnWidth = v;
		}
		
		protected var _borderStrokePainter:IPainter = new StrokePainter(new Stroke(1,0xaaaaaa))
		
		public function set borderStrokePainter(painter:IPainter):void{
			_borderStrokePainter = painter;
			invalidateDisplayList();
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_borderStrokePainter){
				borderRect.graphics.clear();
				_borderStrokePainter.draw(borderRect.graphics, unscaledWidth, unscaledHeight);
			}
		}
		
		/**
		 * Function invoked when an itemRenderer is clicked
		 */ 
		protected function handleRendererMouseClick(event:MouseEvent):void{
			for (var uid:String in visibleRenderersMap){
				if(visibleRenderersMap[uid] == event.currentTarget){
					//_selectedItem = rendererData;
					var selectedRenderer:DisplayObject = visibleRenderersMap[uid];
					selectedIndex = _dataProviderCollection.getUIDIndex(uid);
					if(selectedRenderer is IListDataRenderer){
						IListDataRenderer(selectedRenderer).selected = true;
					}
					break;
				}
			}
			var listEvent:ListEvent = new ListEvent(ListEvent.ITEM_CLICK);
			dispatchEvent(listEvent); 
		}
		
		protected var _selectedIndex:int=-1;
		
		public function get selectedIndex():int{
			return _selectedIndex;
		}
		
		public function set selectedIndex(val:int):void{
			if(_selectedIndex == val) return;
			for(var uid:String in visibleRenderersMap){
				if(_selectedIndex == _dataProviderCollection.getUIDIndex(uid)){
					
					if(visibleRenderersMap[uid] is IListDataRenderer){
						IListDataRenderer(visibleRenderersMap[uid]).selected = false;
						break;
					}
				}
			}
			
			_selectedIndex = val;
			_selectedItem = _dataProviderCollection.getItemAt(_selectedIndex);
			
			var event:ListEvent = new ListEvent(ListEvent.CHANGE);
			dispatchEvent(event);
		}
		
		/**
		 * Returns the itemRenderer for the associated with a particular
		 * item in the dataProvider if one is created. Will return null
		 * if the item is not being represented by a renderer at this particular
		 * moment.
		 */ 
		public function itemToItemRenderer(item:*):DisplayObject{
			for (var uid:String in this.visibleRenderersMap){
				if(this._dataProviderCollection.getItemForUID(uid) == item){
					return visibleRenderersMap[uid];
				}
			}
			return null;
		}
		
		
		protected var _selectedItem:*;
		public function get selectedItem():*{
			return _selectedItem;
		}
		
		public function set selectedItem(item:*):void{
			selectedIndex = _dataProviderCollection.getItemIndex(item)
		}
		
		/**
		 * Unlike UIContainers, the contentHeight of List controls is
		 * not measured using the number of children in the contentPane
		 * but rather based on the _dataProviderCollection length.
		 */ 
		override public function get contentHeight():Number{
			if(_dataProviderCollection){
				return _rowHeight*_dataProviderCollection.length
			}
			else{
				return 0;
			}
		}
		
	}
}