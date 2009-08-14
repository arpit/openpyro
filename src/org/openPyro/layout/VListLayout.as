package org.openPyro.layout
{
	import flash.utils.Dictionary;
	
	import org.openPyro.collections.ICollection;
	import org.openPyro.collections.IIterator;
	import org.openPyro.controls.listClasses.ListBase;

	public class VListLayout extends VLayout implements IVirtualizedLayout
	{
		public function VListLayout()
		{
			
		}
		
		private var _listBase:ListBase;
		public function set listBase(object:ListBase):void{
			_listBase = object;
		}
		
		override public function getMaxWidth(children:Array):Number
		{
			if(!_listBase.dataProvider){
				 return 0;	
			}
			else{
				return _listBase.columnWidth + this._initX;
			}
		}
		
		override public function getMaxHeight(children:Array) : Number{
			if(!_listBase.dataProvider){
				 return 0;	
			}
			else{
				return _listBase.rowHeight * _listBase.dataProviderCollection.length + _initY;
			}
		}
		
		override public function layout(children:Array) : void{
			// dont layout
		}
		
		public function get numberOfVerticalRenderersNeededForDisplay():int{
			return Math.ceil(_container.height/ListBase(_container).rowHeight)+1;
		}
		
		public function get visibleRenderersData():Array{
			var scrollAbleHeight:Number = _listBase.contentHeight - _listBase.height;
			var scrollPos:Number = _listBase.verticalScrollPosition*scrollAbleHeight;
			var newTopRendererIndex:int = Math.floor(scrollPos/_listBase.rowHeight);
			var newRenderersData:Array = []
			
			
			var sourceCollection:ICollection = _listBase.dataProviderCollection;
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