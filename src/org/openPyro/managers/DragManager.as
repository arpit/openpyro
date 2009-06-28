package org.openPyro.managers
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.openPyro.managers.events.DragEvent;
	import org.openPyro.utils.ArrayUtil;
	import org.openPyro.utils.GraphicUtil;
	
	public class DragManager extends EventDispatcher{
		
		private static var dragProxy:Sprite;
		
		private static var _dragInitiator:DisplayObject
		private static var _data:Object;
		private static var mouseStartY:Number = 0
		private static var mouseStartX:Number = 0
		private static var dropClients:Array = [];
		
		
		public function DragManager() {
		}
		
		public static function doDrag(dragInitiator:DisplayObject, data:Object, bounds:Rectangle=null, centerDragProxy:Boolean=false):void{
			dropAcceptingClients = [];
			for each(var client:DisplayObject in dropClients){
				client.addEventListener(MouseEvent.ROLL_OVER, onMouseOverPossibleDropTarget);
			}
			
			if(!bounds){
				bounds = new Rectangle(0,0, dragInitiator.stage.stageWidth, dragInitiator.stage.stageHeight);
			}
			_dragInitiator = dragInitiator;
			_data = data;
			dragProxy = createDragProxy(dragInitiator, centerDragProxy);
			dragInitiator.stage.addChild(dragProxy);
			
			// position the dragproxy off the stage till the user
			// actually begins moving the mouse
			dragProxy.x = -dragProxy.width;
			dragProxy.y = -dragProxy.height;
			
			dragProxy.startDrag(true, bounds);
			_isDragging = true;
			
			mouseStartY = dragInitiator.stage.mouseY
			mouseStartX = dragInitiator.stage.mouseX;
			dragInitiator.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			
			var event:DragEvent = new DragEvent(DragEvent.DRAG_INIT);
			event.data = data;
			dragInitiator.dispatchEvent(event);
		
		}
		
		private static function onMouseUp(event:MouseEvent):void{
			if(!dragProxy || !_isDragging) return;
			_isDragging = false;
			if(dropAcceptingClients.length == 0){
				showDropRejectedAnimation();
				return;
			}
			
			var target:DisplayObject =  dropAcceptingClients[0];
			var dropEvent:DragEvent = new DragEvent(DragEvent.DRAG_DROP);
			
			dropEvent.stageX = event.stageX;
			dropEvent.stageY = event.stageY;
			dropEvent.data = _data;
			dropEvent.dragInitiator = _dragInitiator;
			dropEvent.mouseXDelta = dragProxy.parent.stage.mouseX-mouseStartX;
			dropEvent.mouseYDelta = dragProxy.parent.stage.mouseY-mouseStartY;
			
			showDropAcceptedAnimation();
			target.dispatchEvent(dropEvent);
				
		
		}
		
		private static function showDropRejectedAnimation():void{
			//TODO: show the rejection animation
			dragProxy.parent.removeChild(dragProxy);
			dragProxy = null;
			return;
		}
		
		
		private static function showDropAcceptedAnimation():void{
			//TODO: show the acecpted animation
			dragProxy.parent.removeChild(dragProxy);
			dragProxy = null;
			return;
		}
		
		
		private static function createDragProxy(source:DisplayObject, centerDragProxy:Boolean):Sprite{
			var bmp:Bitmap = GraphicUtil.getBitmap(source);
			var sp:Sprite = new Sprite();
			sp.addChild(bmp);
			if(centerDragProxy){
				bmp.x = -bmp.width/2;
				bmp.y = -bmp.height/2;
			}
			sp.alpha = .5;
			sp.mouseEnabled = false;
			return sp;
			
		}
		
		private static var _isDragging:Boolean = false;
		
		/**
		 * Flag to check if the DragManager is dragging 
		 * a proxy across the application
		 */ 
		public static function isDragging():Boolean{
			return _isDragging;
		}
		
		public static function registerDropClient(client:DisplayObject):void{
			if(dropClients.indexOf(client)==-1){
				dropClients.push(client);
			}
		}
		
		private static function onMouseOverPossibleDropTarget(event:MouseEvent):void{
			var evt:DragEvent = new DragEvent(DragEvent.DRAG_ENTER);
			evt.data = _data;
			DisplayObject(event.target).dispatchEvent(evt);
			DisplayObject(event.target).addEventListener(MouseEvent.MOUSE_OUT, 
															onMouseOutOfPossibleDropTarget);
		}
		
		private static function onMouseOutOfPossibleDropTarget(event:MouseEvent):void{
			DisplayObject(event.target).dispatchEvent(new DragEvent(DragEvent.DRAG_EXIT));
			ArrayUtil.remove(dropAcceptingClients, (event.target));
		}
		
		private static var dropAcceptingClients:Array = [];
		
		public static function acceptDragDrop(target:DisplayObject):void{
			if(dropAcceptingClients.indexOf(target) == -1){
				dropAcceptingClients.push(target);
			}
		}
		
		public static function removeDropClient(client:DisplayObject):void{
			if(dropClients.indexOf(client) != -1){
				ArrayUtil.remove(dropClients, client);
			}
		}

	}
}