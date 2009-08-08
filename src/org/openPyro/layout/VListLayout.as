package org.openPyro.layout
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import org.openPyro.controls.events.ScrollEvent;
	import org.openPyro.controls.listClasses.ListBase;
	import org.openPyro.core.IDataRenderer;
	import org.openPyro.core.UIContainer;

	public class VListLayout extends VLayout implements IVirtualizedLayout
	{
		public function VListLayout()
		{
			
		}
		
		override public function set container(c:UIContainer):void{
			super.container = c;
			c.addEventListener(ScrollEvent.SCROLL, onContainerScroll);
			
		}
		
		private function onContainerScroll(event:ScrollEvent):void{
			
		}
		
		override public function getMaxWidth(children:Array):Number
		{
			var listBase:ListBase = ListBase(_container);
			if(!listBase.dataProvider){
				 return 0;	
			}
			else{
				return listBase.columnWidth + this._initX;
			}
		}
		
		override public function getMaxHeight(children:Array) : Number{
			var listBase:ListBase = ListBase(_container);
			if(!listBase.dataProvider){
				 return 0;	
			}
			else{
				return listBase.rowHeight * listBase.dataProvider.length + _initY;
			}
		}
		
		override public function layout(children:Array) : void{
			// dont layout
		}
		
		public function get numberOfVerticalRenderersNeededForDisplay():int{
			return Math.ceil(_container.height/ListBase(_container).rowHeight)+1;
		}
		
		public function get visibleRenderers():Array{
			var listBase:ListBase = ListBase(_container);
			var scrollAbleHeight:Number = listBase.contentHeight - listBase.height;
			var scrollPos:Number = listBase.verticalScrollPosition*scrollAbleHeight;
			var newTopRendererIndex:int = Math.floor(scrollPos/listBase.rowHeight);
			var newRenderersIndexes:Array = []
			for(var i:int=newTopRendererIndex; i<newTopRendererIndex+numberOfVerticalRenderersNeededForDisplay; i++){
				newRenderersIndexes.push(i);	
			}
			return newRenderersIndexes;
		}
		
		public function positionRendererMap(map:Dictionary):void{
			var listBase:ListBase = ListBase(_container);
			for(var a:String in map){
				DisplayObject(map[a]).y = listBase.rowHeight*Number(a);
			}
			var scrollAbleHeight:Number = listBase.contentHeight - listBase.height;
			listBase.scrollContentPaneY(listBase.verticalScrollPosition*scrollAbleHeight);
		}
	}
}