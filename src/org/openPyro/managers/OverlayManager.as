package org.openPyro.managers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.openPyro.core.UIControl;
	
	public class OverlayManager
	{
		public function OverlayManager()
		{
			super();
		}
		
		protected var _overlayDisplayObject:DisplayObjectContainer
		
		/**
		 * The overlay layer on which the popups are rendered. If a new layer
		 * is set as the overlayContainer, the old one is removed from the 
		 * stage, so please set displayobjects for this value to be dedicated
		 * to just displaying overlays.
		 */ 
		public function set overlayContainer(dp:DisplayObjectContainer):void{
			/*
			If there already was an overlay created, remove
			it and all its children
			*/
			if(_overlayDisplayObject){
				while(_overlayDisplayObject.numChildren > 0){
					_overlayDisplayObject.removeChildAt(0)
				}
				bgSprite = null;
				if(_overlayDisplayObject.parent){
					_overlayDisplayObject.parent.removeChild(_overlayDisplayObject);
				}	
			}
			_overlayDisplayObject = dp;
		}
		
		public function get overlayContainer():DisplayObjectContainer{
			return _overlayDisplayObject;
		}
		
		private static var instance:OverlayManager
		public static function getInstance():OverlayManager{
			if(!instance){
				instance = new OverlayManager()
			}
			return instance;
		}
		
		
		private var bgSprite:Sprite;
		private var centeredPopup:DisplayObject
		
		public function showPopUp(popupObject:DisplayObject, modal:Boolean=false, center:Boolean=true):void{
			if(!_overlayDisplayObject){
				throw new Error("No overlay displayObject defined on which to draw")
			}
			
			if(modal){
					
				if(!bgSprite){
					bgSprite = new Sprite()
					bgSprite.graphics.beginFill(0x00000, .5)
					bgSprite.graphics.drawRect(0,0,50,50);
					_overlayDisplayObject.addChild(bgSprite);
					_overlayDisplayObject.stage.addEventListener(Event.RESIZE, onBaseStageResize)
					// capture mouse interactions here.
				}
				bgSprite.width = _overlayDisplayObject.stage.stageWidth;
				bgSprite.height = _overlayDisplayObject.stage.stageHeight
				bgSprite.visible = true;
			}
			
			_overlayDisplayObject.addChild(popupObject);
			if(center){
				centeredPopup = popupObject
				popupObject.x = (_overlayDisplayObject.stage.stageWidth-popupObject.width)/2;
				popupObject.y = (_overlayDisplayObject.stage.stageHeight-popupObject.height)/2;
			}
			
		}
		
		/**
		 * Shows the object DisplayObject at the x and y coordinates of the target DisplayObject.
		 * If the target is not supplied, the object is positioned at 0,0.
		 */ 
		public function showOnOverlay(object:DisplayObject, target:DisplayObject=null):void{
			_overlayDisplayObject.addChild(object);
			if(target){
				var orig:Point = new Point(0,0)
				var pt:Point = target.localToGlobal(orig)
				pt = _overlayDisplayObject.globalToLocal(pt);
				object.x = pt.x
				object.y = pt.y
			}
			
			var xp:Number = object.stage.stageWidth - (object.x+object.width+10);
			if(xp < 0){
				object.x += xp; 
			}
		}
		
		public function remove(popup:DisplayObject):void{
			
			if(!popup || !popup.parent) return;
			
			popup.parent.removeChild(popup);
			bgSprite.visible = false;
		}
		
		private function onBaseStageResize(event:Event):void{
			if(bgSprite){
				bgSprite.width = _overlayDisplayObject.stage.stageWidth
				bgSprite.height = _overlayDisplayObject.stage.stageHeight
			}
			if(centeredPopup){
				centeredPopup.x = (_overlayDisplayObject.stage.stageWidth-centeredPopup.width)/2;
				centeredPopup.y = (_overlayDisplayObject.stage.stageHeight-centeredPopup.height)/2;
			}
		}

	}
}