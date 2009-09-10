package org.openPyro.controls
{
	import flash.events.Event;
	
	import org.openPyro.controls.events.ScrollEvent;
	import org.openPyro.controls.listClasses.ListBase;
	import org.openPyro.events.PyroEvent;
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
			//this.addEventListener(PyroEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:PyroEvent):void{
			this.autoPositionViewport = false;
			this.addEventListener(PyroEvent.SCROLLBARS_CHANGED, updateScrollRect);
			this.addEventListener(PyroEvent.SIZE_CHANGED, updateScrollRect);
		}
		
		override protected function onVerticalScroll(event:ScrollEvent):void
		{
			var newRenderersData:Array = IVirtualizedLayout(layout).visibleRenderersData;
			createNewRenderersAndMap(newRenderersData);
			IVirtualizedLayout(layout).positionRendererMap(this.visibleRenderersMap, newlyCreatedRenderers, false);
			dispatchEvent(event);
			updateScrollRect();
		}
		
		protected function updateScrollRect(event:Event=null):void{
			//var scrollAbleHeight:Number = contentHeight - height;
			//scrollContentPaneY(verticalScrollPosition*scrollAbleHeight);
			setContentMask();
		}
		
		private var _topRendererIndex:Number = 0;
		
		
		public function indexToItemRenderer(index:int):Number{
			return -1;
		}
		
	}
}