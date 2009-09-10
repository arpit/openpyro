package org.openPyro.layout
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import org.openPyro.collections.ICollection;
	import org.openPyro.collections.IIterator;
	import org.openPyro.controls.listClasses.ListBase;
	import org.openPyro.effects.Effect;

	public class VListLayout extends VLayout implements IVirtualizedLayout
	{
		public function VListLayout()
		{
			
		}
		
		protected var _listBase:ListBase;
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
			/* 
			Calculate the scrollable height:
			Originally this was calling 
			*/
			var scrollAbleHeight:Number = Math.max(0,_listBase.contentHeight - _listBase.height);
			
			if(scrollAbleHeight == 0){
				_listBase.verticalScrollPosition = 0;
			}
			
			if(!_listBase.autoPositionViewport && _listBase.verticalScrollBar && _listBase.positionAnchorRenderer){
				var percent:Number = Math.min((_listBase.positionAnchorRenderer.y - 
									(_listBase.positionAnchorRenderer.y-_listBase.contentPane.scrollRect.top))/(_listBase.contentHeight-_listBase.height), 1);
				_listBase.verticalScrollBar.value = percent;
				_listBase.positionAnchorRenderer = null;
				
			}
			
			var scrollPos:Number = _listBase.verticalScrollPosition*scrollAbleHeight;
			var newTopRendererIndex:int = Math.floor(scrollPos/_listBase.rowHeight);
			
			var newRenderersData:Array = []
			
			
			var sourceCollection:ICollection = _listBase.dataProviderCollection;
			var iterator:IIterator = sourceCollection.iterator;
			iterator.cursorIndex = newTopRendererIndex;
			
			for(var i:int=0; i<numberOfVerticalRenderersNeededForDisplay; i++){
				var itemUID:String = sourceCollection.getUIDForItemAtIndex(iterator.cursorIndex);
				if(itemUID == null){
					break;
				}
				newRenderersData.push(itemUID);
				iterator.cursorIndex++;	
			}
			return newRenderersData;
		}
		
		public function positionRendererMap(map:Dictionary, newlyCreatedRenderers:Array, animate:Boolean):void{
			
			var itemsArray:Array = sortRenderersByPosition(map);
			
			for(var i:int=0; i<itemsArray.length; i++){
				var newRendererY:Number = itemsArray[i].itemIndex*_listBase.rowHeight;
				if(newRendererY == itemsArray[i].renderer.y && newlyCreatedRenderers.indexOf(itemsArray[i].renderer) == -1){
					continue;
				}
				var renderer:DisplayObject = itemsArray[i].renderer;
				if(animate){
					if(newlyCreatedRenderers.indexOf(renderer) == -1){
						Effect.on(renderer).completeCurrent().moveY(newRendererY,.7);
					}
					else{
						Effect.on(renderer).completeCurrent().fadeIn();
						renderer.y = newRendererY;
					}	
				}
				else{
					renderer.y = newRendererY;
				}
				
			}
			/*var scrollAbleHeight:Number = _listBase.contentHeight - _listBase.height;
			_listBase.scrollContentPaneY(_listBase.verticalScrollPosition*scrollAbleHeight);*/
		}
		
		/**
		 * Returns an Array of itemRenderers sorted in the order they are supposed
		 * to be laid out
		 */ 
		protected function sortRenderersByPosition(map:Dictionary):Array{
			
			var index:Number = 0;
			
			var itemsArray:Array = [];
			for(var uid:String in map){
				itemsArray.push(
								{data:uid, 
								renderer:map[uid], 
								itemIndex:_listBase.dataProviderCollection.getUIDIndex(uid)
								});	
			}
			itemsArray.sortOn("itemIndex");
			return itemsArray;
		}
		
	}
}