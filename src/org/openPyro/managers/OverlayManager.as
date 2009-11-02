package org.openPyro.managers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class OverlayManager
	{
		public function OverlayManager()
		{
			super();
		}
		
		protected var _overlayDisplayObject:DisplayObjectContainer
		
		/**
		 * The overlay layer on which the popups are 
		 * rendered
		 */ 
		public function set overlayContainer(dp:DisplayObjectContainer):void{
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
		
		public function showOnOverlay(object:DisplayObject, target:DisplayObject=null):void{
			_overlayDisplayObject.addChild(object);
			if(target){
				var orig:Point = new Point(0,0)
				var pt:Point = target.localToGlobal(orig)
				pt = _overlayDisplayObject.globalToLocal(pt);
				object.x = pt.x
				object.y = pt.y
			}
			
		}
		
		public function remove(popup:DisplayObject):void{
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