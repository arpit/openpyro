package org.openPyro.controls.listClasses
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.openPyro.collections.CollectionHelpers;
	import org.openPyro.collections.ICollection;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.IDataRenderer;
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.ObjectPool;
	import org.openPyro.core.UIContainer;
	import org.openPyro.painters.Stroke;
	import org.openPyro.painters.StrokePainter;

	public class ListBase extends UIContainer
	{
		public function ListBase()
		{
			super();
		}
		
		protected var _dataProvider:Object;
		protected var _rendererPool:ObjectPool;
		
		public var visibleRenderersMap:Dictionary = new Dictionary();
		
		public function set dataProvider(src:Object):void{
			if(_dataProvider == src) return;
			_dataProvider = src;
			
			/*
			 * Reset the scroll positions 
			 */
			verticalScrollPosition = 0
			horizontalScrollPosition = 0
			convertDataToCollection(src);
			
			needsReRendering = true;
		}
		
		public function get dataProvider():Object{
			return _dataProvider;
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
			_needsReRendering = true;
			if(!initialized) return;
			this.stage.addEventListener(Event.RENDER, stageRenderEventHandler);
			this.stage.invalidate();
		}
		
		override public function initialize() : void{
			super.initialize();
			if(_needsReRendering){
				needsReRendering=true;
			}
		}
		
		override public function validateSize() : void{
			super.validateSize();
			
			
			
		}
		
		protected function stageRenderEventHandler(event:Event):void{
			if(!_dataProvider || !_itemRendererFactory || !_needsReRendering){
				return;
			}
			this.stage.removeEventListener(Event.RENDER, stageRenderEventHandler);
			_needsReRendering = false;
			renderInitialData();
		}
		
		protected function createNewRenderersAndMap(newRendererIndexes:Array):void{
			var newRendererMap:Dictionary = new Dictionary();
			for(var a:String in this.visibleRenderersMap){
				if(newRendererIndexes.indexOf(Number(a)) == -1){
					var unusedRenderer:DisplayObject = DisplayObject(visibleRenderersMap[a]);
					unusedRenderer.parent.removeChild(unusedRenderer);
					rendererPool.returnToPool(unusedRenderer);
				}
				else{
					newRendererMap[a] = visibleRenderersMap[a];
				}
			}
			for(var i:int=0; i<newRendererIndexes.length; i++){
				var newRendererIndex:int = newRendererIndexes[i];
					
				if(!newRendererMap[newRendererIndex]){
					var newRenderer:DisplayObject = rendererPool.getObject() as DisplayObject;
					contentPane.addChild(newRenderer);
					if(newRenderer is MeasurableControl){
						MeasurableControl(newRenderer).doOnAdded();
					}
					if(newRenderer is IListDataRenderer){
						var listRenderer:IListDataRenderer = newRenderer as IListDataRenderer;
						var baseListData:BaseListData = new BaseListData()
						//baseListData.list = this;
						baseListData.rowIndex = i;
						listRenderer.baseListData = baseListData;
					}
					if(newRenderer is IDataRenderer){
						IDataRenderer(newRenderer).data = _dataProviderCollection.getItemAt(newRendererIndex);
					}
					newRendererMap[newRendererIndex] = newRenderer;
				}
			}
			this.visibleRenderersMap = newRendererMap;
		}
		
		protected function renderInitialData():void{}	
		
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
		
		protected var borderStrokePainter:StrokePainter = new StrokePainter(new Stroke(1,0xaaaaaa))
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			borderRect.graphics.clear();
			borderStrokePainter.draw(borderRect.graphics, unscaledWidth, unscaledHeight);
		}
		
	}
}