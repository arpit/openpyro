package org.openPyro.layout
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import org.openPyro.controls.events.ScrollEvent;
	import org.openPyro.controls.listClasses.ListBase;
	import org.openPyro.core.IDataRenderer;
	import org.openPyro.core.UIContainer;
	import org.openPyro.collections.ICollection;
	import org.openPyro.collections.IIterator;

	public class VListLayout extends VLayout implements IVirtualizedLayout
	{
		public function VListLayout()
		{
			
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
		
		public function get visibleRenderersData():Array{
			var listBase:ListBase = ListBase(_container);
			var scrollAbleHeight:Number = listBase.contentHeight - listBase.height;
			var scrollPos:Number = listBase.verticalScrollPosition*scrollAbleHeight;
			var newTopRendererIndex:int = Math.floor(scrollPos/listBase.rowHeight);
			var newRenderersData:Array = []
			
			
			var sourceCollection:ICollection = listBase.dataProviderCollection;
			var iterator:IIterator = sourceCollection.iterator;
			iterator.cursorIndex = newTopRendererIndex;
			
			for(var i:int=0; i<numberOfVerticalRenderersNeededForDisplay; i++){
				var dataItem:* = iterator.getCurrent();
				newRenderersData.push(dataItem);
				iterator.cursorIndex++;	
			}
			return newRenderersData;
		}
		
		public function positionRendererMap(map:Dictionary):void{
			var listBase:ListBase = ListBase(_container);
			var index:Number = 0;
			
			var itemsArray:Array = [];
			for(var a:String in map){
				itemsArray.push(
								{data:a, 
								renderer:map[a], 
								itemIndex:listBase.dataProviderCollection.getItemIndex(a)
								})	
			}
			itemsArray.sortOn("itemIndex");
			
			var s:String =""
			for(var i:int=0; i<itemsArray.length; i++){
				itemsArray[i].renderer.y = itemsArray[i].itemIndex*listBase.rowHeight;
				s+=itemsArray[i].itemIndex+",";
			}
			var scrollAbleHeight:Number = listBase.contentHeight - listBase.height;
			listBase.scrollContentPaneY(listBase.verticalScrollPosition*scrollAbleHeight);
		}
	}
}