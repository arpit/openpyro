package org.openPyro.controls
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import org.openPyro.controls.events.ScrollEvent;
	import org.openPyro.controls.listClasses.ListBase;
	import org.openPyro.core.IDataRenderer;
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
		}
		
		override protected function onVerticalScroll(event:ScrollEvent):void
		{
			var newRendererIndexes:Array = IVirtualizedLayout(layout).visibleRenderers;
			createNewRenderersAndMap(newRendererIndexes);
			IVirtualizedLayout(layout).positionRendererMap(this.visibleRenderersMap);
			dispatchEvent(event);
		}
		
		/**
		 * Renders the data into itemRenderers.
		 * This should probably be called only once
		 * 
		 */ 
		override protected function renderData():void{
			var nowY:Number = 0;
			
			for (var i:int=0; i<IVirtualizedLayout(this.layout).numberOfVerticalRenderersNeededForDisplay; i++){
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
		
		public function indexToItemRenderer(index:int):Number{
			return -1;
		}
		
	}
}