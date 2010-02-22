package org.openPyro.layout
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import org.openPyro.controls.Tree;
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.controls.events.TreeEvent;
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
			
			// decide whether the new renderers animate from the top or bottom
			var appearFromTop:Boolean = (Tree(_listBase).treeState == TreeEvent.ITEM_OPENING);
								
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
							Effect.on(renderer).completeCurrent().moveY(newRendererY,animDuration).onComplete(dispatchComplete);
						}
						else{
							
							Effect.on(renderer).cancelCurrent();
							if(appearFromTop){
								renderer.y = newRendererY - newRenderersGroupSize
							}
							else{
								renderer.y = newRendererY + newRenderersGroupSize
							}
							Effect.on(renderer).moveY(newRendererY,animDuration).onComplete(dispatchComplete);
						}
					}
					
					else{
						if(!firstTime){
							renderer.y = newRendererY;
						}
						else{
							renderer.y = newRendererY - newRenderersGroupSize
							Effect.on(renderer).moveY(newRendererY, animDuration).onComplete(dispatchComplete);
						}
						
					}
				}
				firstTime = false;
		}
		
		private function dispatchComplete(effect:Effect):void{
			for (var a:String in _listBase.visibleRenderersMap){
				if (Effect.isPlayingOn(_listBase.visibleRenderersMap[a])){
					return;
				} 
			}
			_listBase.dispatchEvent(new ListEvent(ListEvent.RENDERERS_REPOSITIONED));
		}
	}
}