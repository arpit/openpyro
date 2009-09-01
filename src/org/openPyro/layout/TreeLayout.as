package org.openPyro.layout
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import org.openPyro.controls.Tree;
	import org.openPyro.core.IDataRenderer;
	import org.openPyro.effects.Effect;

	public class TreeLayout extends VListLayout
	{
		public function TreeLayout()
		{
			super();
		}
		
		private var firstTime:Boolean = true;
		
		override public function positionRendererMap(map:Dictionary, newlyCreatedRenderers:Array, animate:Boolean):void{
			var itemsArray:Array = sortRenderersByPosition(map);
			
			var firstNewRenderer:DisplayObject = null;
			
			var appearFromTop:Boolean = false;
			var newRenderersGroupSize:Number = newlyCreatedRenderers.length*_listBase.rowHeight - _listBase.rowHeight;
			
			var animDuration:Number = Math.min(0.5,.3*newlyCreatedRenderers.length);
			
			for(var i:int=0; i<itemsArray.length; i++){
					var newRendererY:Number = itemsArray[i].itemIndex*_listBase.rowHeight;
					if(newRendererY == itemsArray[i].renderer.y && newlyCreatedRenderers.indexOf(itemsArray[i].renderer) == -1){
						continue;
					}
					var renderer:DisplayObject = itemsArray[i].renderer;
					
					if(animate){
						if(newlyCreatedRenderers.indexOf(renderer) == -1){
							Effect.on(renderer).completeCurrent().moveY(newRendererY,animDuration);
						}
						else{
							if(Tree(_listBase).treeState == Tree.ITEM_OPENING){
								appearFromTop = true;
							}
							
							Effect.on(renderer).cancelCurrent();
							if(appearFromTop){
								renderer.y = newRendererY - newRenderersGroupSize
							}
							else{
								renderer.y = newRendererY + newRenderersGroupSize
							}
							Effect.on(renderer).moveY(newRendererY,animDuration)
						}
					}
					
					else{
						if(!firstTime){
							renderer.y = newRendererY;
						}
						else{
							renderer.y = newRendererY - newRenderersGroupSize
							Effect.on(renderer).moveY(newRendererY, animDuration);
						}
						
					}
				}
				var scrollAbleHeight:Number = _listBase.contentHeight - _listBase.height;
				_listBase.scrollContentPaneY(_listBase.verticalScrollPosition*scrollAbleHeight);
				firstTime = false;
		}
	}
}