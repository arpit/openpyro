package org.openPyro.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.openPyro.controls.ScrollBar;
	import org.openPyro.controls.events.ScrollEvent;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.IDataRenderer;
	import org.openPyro.core.ObjectPool;
	import org.openPyro.core.UIContainer;

	public class OptimizedList extends UIContainer
	{
		/**
		*	IN DEVELOPMENT, PLEASE DO NOT USE YET	
		*	
		*	The optimizedList class is a List implementation that recycles itemRenderers
		*	as it scrolls.
		*/	
		
		public function OptimizedList()
		{
		}
		
		private var _dataProvider:Array;
		private var _rendererPool:ObjectPool;
		
		public function set dataProvider(src:Array):void{
			_dataProvider = src;
			needsReRendering = true;
		}
		
		private var _itemRendererFactory:ClassFactory;
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
		
		private var visibleRenderersMap:Dictionary = new Dictionary();
		
		private var _needsReRendering:Boolean = false;
		public function get needsReRendering():Boolean{
			return _needsReRendering;
		}
		
		public function set needsReRendering(b:Boolean):void{
			_needsReRendering = true;
			if(!initialized) return;
			this.stage.addEventListener(Event.RENDER, onStageRender);
			this.stage.invalidate();
		}
		
		private function onStageRender(event:Event):void{
			if(!_dataProvider || !_itemRendererFactory || !_needsReRendering){
				return
			}
			this.stage.removeEventListener(Event.RENDER, onStageRender);
			_needsReRendering = false;
			renderData();
			
		}
		
		private var _verticalScrollbar:ScrollBar;
		private var _topRenderer:Number = 0;
		
		override protected function onVerticalScroll(event:ScrollEvent):void
		{
			var scrollAbleHeight:Number = this._contentHeight - getExplicitOrMeasuredHeight();
			var scrollPos:Number = event.value*scrollAbleHeight;
			var newTopRenderer:Number = Math.floor(scrollPos/rowHeight)
			
			var newVisibleRendererMap:Dictionary = new Dictionary();
			
			if(_topRenderer != newTopRenderer){
				// recycle
				for(var a:String in visibleRenderersMap){
					if(int(a) < newTopRenderer || int(a) > newTopRenderer+numberOfRenderersNeededForDisplay){
						var unusedRenderer:DisplayObject = contentPane.removeChild(visibleRenderersMap[a]);
						_rendererPool.returnToPool(unusedRenderer);
					}
					else{
						newVisibleRendererMap[a] = visibleRenderersMap[a];
					}
				}
				
				for(var i:int=newTopRenderer; i<newTopRenderer+numberOfRenderersNeededForDisplay; i++){
					if(!newVisibleRendererMap[i]){
						var newRenderer:DisplayObject = DisplayObject(_rendererPool.getObject());
						if(newRenderer is IDataRenderer){
							IDataRenderer(newRenderer).data = _dataProvider[i];
						}
						newVisibleRendererMap[i] = newRenderer;
						contentPane.addChild(newRenderer);
						newRenderer.y = _rowHeight*i;
					}
				} 
				visibleRenderersMap = newVisibleRendererMap;
				_topRenderer = newTopRenderer;
			}
			
			scrollY = event.value*scrollAbleHeight
			setContentMask()
		}
			
		/**
		 * Renders the data into itemRenderers.
		 * This should probably be called only once
		 * 
		 */ 
		protected function renderData():void{
			var nowY:Number = 0;
			
			for (var i:int=0; i<numberOfRenderersNeededForDisplay; i++){
				var renderer:DisplayObject = DisplayObject(_rendererPool.getObject());
				visibleRenderersMap[i] = (renderer);
				this.contentPane.addChild(renderer);
				if(renderer is IDataRenderer){
					IDataRenderer(renderer).data = _dataProvider[i];
				}
				renderer.y = nowY;
				nowY+=rowHeight;
			}
			super.invalidateSize();
		}
		
		//private var _scrollContentHeight:Number;
		override public function calculateContentDimensions():void{
			// check needs scrollbar:
			super.calculateContentDimensions();
			if(!_dataProvider || !rowHeight){
				return;
			}
			_contentHeight = _dataProvider.length*rowHeight;
		}
		
		private var _rowHeight:Number = NaN;
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
		
		public function indexToItemRenderer(index:int):Number{
			return -1;
		}
		
		public function get numberOfRenderersNeededForDisplay():int{
			return Math.ceil(getExplicitOrMeasuredHeight()/rowHeight)+1;
		}
	}
}