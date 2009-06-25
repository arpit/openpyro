package org.openPyro.managers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.openPyro.managers.events.DragEvent;
	import org.openPyro.utils.ArrayUtil;
	import org.openPyro.utils.MouseUtil;
	import org.openPyro.utils.GraphicUtil;
	
	public class DragManager extends EventDispatcher{
		
		private var dragProxy:Sprite;
		private var _dragInitiator:DisplayObject
		
		private var mouseStartY:Number = 0
		private var mouseStartX:Number = 0
		
		public function DragManager() {
			dropClients = [];
		}
		
		public function makeDraggable(object:DisplayObject, bounds:Rectangle=null, centerDragProxy:Boolean=false):void{
			if(!object.stage){
				throw new Error("DragTarget is not on stage")
			}
			if(!bounds){
				bounds = new Rectangle(0,0, object.stage.stageWidth, object.stage.stageHeight);
			}
			_dragInitiator = object;
			dragProxy = createDragProxy(object, centerDragProxy);
			object.stage.addChild(dragProxy);
			
			// position the dragproxy off the stage till the user
			// actually begins moving the mouse
			dragProxy.x = -dragProxy.width;
			dragProxy.y = -dragProxy.height;
			
			dragProxy.startDrag(true, bounds);
			this._isDragging = true;
			
			mouseStartY = object.stage.mouseY
			mouseStartX = object.stage.mouseX;
			object.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private static var instance:DragManager;
		public static function getInstance():DragManager{
			if(!instance){
				instance = new DragManager();
			}
			return instance;
		}
		
		private function onMouseUp(event:MouseEvent):void{
			if(!dragProxy || !_isDragging) return;
			_isDragging = false;
			
			for each(var target:DisplayObject in dropClients){
				if (MouseUtil.isMouseOver(target)){
					var dropEvent:DragEvent = new DragEvent(DragEvent.DRAG_DROP);
			
					dropEvent.stageX = event.stageX;
					dropEvent.stageY = event.stageY;
					dropEvent.dragInitiator = _dragInitiator;
					
					dropEvent.mouseXDelta = dragProxy.parent.stage.mouseX-mouseStartX;
					dropEvent.mouseYDelta = dragProxy.parent.stage.mouseY-mouseStartY;
					showDropAcceptedAnimation();
					target.dispatchEvent(dropEvent);
				}
			}
		}
		
		private function showDropRejectedAnimation():void{
			//TODO: show the rejection animation
			dragProxy.parent.removeChild(dragProxy);
			dragProxy = null;
			return;
		}
		
		
		private function showDropAcceptedAnimation():void{
			//TODO: show the acecpted animation
			dragProxy.parent.removeChild(dragProxy);
			dragProxy = null;
			return;
		}
		
		
		public function createDragProxy(source:DisplayObject, centerDragProxy:Boolean):Sprite{
			var bmp:Bitmap = GraphicUtil.getBitmap(source);
			var sp:Sprite = new Sprite();
			sp.addChild(bmp);
			if(centerDragProxy){
				bmp.x = -bmp.width/2;
				bmp.y = -bmp.height/2;
			}
			sp.alpha = .5;
			return sp;
			
		}
		
		private var _isDragging:Boolean = false;
		
		/**
		 * Flag to check if the DragManager is dragging 
		 * a proxy across the application
		 */ 
		public function isDragging():Boolean{
			return _isDragging;
		}
		
		private var dropClients:Array;
		public function registerDropClient(client:DisplayObject):void{
			if(dropClients.indexOf(client)==-1){
				client.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverPossibleDropTarget);
				dropClients.push(client);
			}
		}
		
		private function onMouseOverPossibleDropTarget(event:MouseEvent):void{
			DisplayObject(event.target).dispatchEvent(new DragEvent(DragEvent.DRAG_OVER));
		}
		
		public function removeDropClient(client:DisplayObject):void{
			if(dropClients.indexOf(client) != -1){
				ArrayUtil.remove(dropClients, client);
			}
		}

	}
}