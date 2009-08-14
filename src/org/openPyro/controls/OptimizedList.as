package org.openPyro.controls
{
	import flash.events.Event;
	
	import org.openPyro.collections.IIterator;
	import org.openPyro.controls.events.ScrollEvent;
	import org.openPyro.controls.listClasses.ListBase;
	import org.openPyro.layout.IVirtualizedLayout;
	import org.openPyro.layout.VListLayout;

	public class OptimizedList extends ListBase
	{
		/**
		*	IN DEVELOPMENT, PLEASE DO NOT USE YET	
		*	
		*	The optimizedList class is a List implementation that recycles itemRenderers
		*	as it scrolls.
		*/	
		
		public function OptimizedList()
		{
			this.layout = new VListLayout();
			IVirtualizedLayout(this.layout).listBase = this;
		}
		
		override protected function onVerticalScroll(event:ScrollEvent):void
		{
			var newRenderersData:Array = IVirtualizedLayout(layout).visibleRenderersData;
			createNewRenderersAndMap(newRenderersData);
			IVirtualizedLayout(layout).positionRendererMap(this.visibleRenderersMap);
			dispatchEvent(event);
			
		}
		
		private var _topRendererIndex:Number = 0;
		
		
		/**
		 * Renders the data into itemRenderers.
		 * This should probably be called only once
		 * 
		 */ 
		override protected function renderInitialData():void{
			var newRenderersData:Array = [];
			var iterator:IIterator = dataProviderCollection.iterator;
			iterator.cursorIndex = _topRendererIndex;
			
			for(var i:int=0; i<IVirtualizedLayout(_layout).numberOfVerticalRenderersNeededForDisplay; i++){
				newRenderersData.push(iterator.getCurrent());
				iterator.cursorIndex++;
			}
			createNewRenderersAndMap(newRenderersData);
			IVirtualizedLayout(layout).positionRendererMap(this.visibleRenderersMap);
			invalidateSize();
			displayListInvalidated = true;
			invalidateDisplayList();
			this.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onResize(event:Event):void{
			createNewRenderersAndMap(IVirtualizedLayout(layout).visibleRenderersData);
			IVirtualizedLayout(layout).positionRendererMap(this.visibleRenderersMap);
		}
		
		public function indexToItemRenderer(index:int):Number{
			return -1;
		}
		
	}
}