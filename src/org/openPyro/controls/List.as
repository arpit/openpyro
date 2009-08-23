package org.openPyro.controls
{
	import flash.events.Event;
	
	import org.openPyro.controls.events.ScrollEvent;
	import org.openPyro.controls.listClasses.ListBase;
	import org.openPyro.layout.IVirtualizedLayout;
	import org.openPyro.layout.VListLayout;

	public class List extends ListBase
	{
		/**
		*	IN DEVELOPMENT, PLEASE DO NOT USE YET	
		*	
		*	The optimizedList class is a List implementation that recycles itemRenderers
		*	as it scrolls.
		*/	
		
		public function List()
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
		
		
		public function indexToItemRenderer(index:int):Number{
			return -1;
		}
		
	}
}