package org.openPyro.containers
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.openPyro.containers.events.DividerEvent;
	import org.openPyro.controls.skins.IDividedBoxSkin;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.UIContainer;
	import org.openPyro.managers.DragManager;
	import org.openPyro.managers.events.DragEvent;
	
	[Event(name="dividerDoubleClick", type="org.openPyro.containers.events.DividerEvent" )]

	public class DividedBox extends UIContainer
	{
		/**
		 * Static identifier for identifying Drag
		 * 
		 * @private
		 */
		public static var DIVIDED_BOX_DIVIDER_MOVE:String = "DividedBoxDividerMove";
		
		public function DividedBox()
		{
			super();
			this.dropEnabled = true;
		}
		
		protected var dividers:Array = new Array();
		
		
		protected var _dividerFactory:ClassFactory;
		public function set dividerFactory(f:ClassFactory):void{
			_dividerFactory = f;
		}
		public function get dividerFactory():ClassFactory{
			return _dividerFactory;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject{
			if(contentPane.numChildren > 0){
				contentPane.addChild(getNewDivider())
			}
			return super.addChildAt(child, index);
		}
		
		
		protected function getNewDivider():DisplayObject{
			var divider:DisplayObject 
			if(this._skin){
				divider = IDividedBoxSkin(_skin).getNewDividerSkin();
			}
			else{
				if(!_dividerFactory){
					_dividerFactory = defaultDividerFactory;
				}
				divider = _dividerFactory.newInstance();
			}
			dividers.push(divider);
			InteractiveObject(divider).doubleClickEnabled = true;
			divider.addEventListener(MouseEvent.MOUSE_DOWN, onDividerMouseDown);
			divider.addEventListener(MouseEvent.CLICK, onDividerClick);	
			divider.addEventListener(MouseEvent.DOUBLE_CLICK, onDividerDoubleClick);	
			return divider;
		}
		
		protected function get defaultDividerFactory():ClassFactory{
			return null;
			// override
		}
		
		/**
		 * Event handler for when a mouse is pressed over a divider.
		 * This begins the drag operation on the divider
		 */ 
		protected function onDividerMouseDown(event:MouseEvent):void{
			var divider:DisplayObject = DisplayObject(event.currentTarget);
			this.addEventListener(DragEvent.DRAG_ENTER, onDividerDragEnter);
			divider.addEventListener(DragEvent.DRAG_INIT, onDividerDragInit);
			this.addEventListener(DragEvent.DRAG_DROP, onDividerDragDrop);
			DragManager.doDrag(divider,{type:DIVIDED_BOX_DIVIDER_MOVE, source:this},getDividerDragRect());
		}
		
		/**
		 * Event handler for when the divider begins dragging. At this
		 * point, the <code>DividedBox</code> accepts drops of any divider.
		 */ 
		protected function onDividerDragInit(event:DragEvent):void{
			if(event.data.type == DividedBox.DIVIDED_BOX_DIVIDER_MOVE && event.data.source==this){
				DragManager.acceptDragDrop(this);
			}
		}
		
		/**
		 * Returns the <code>Rectangle</code> where the drop action is permitted
		 */ 
		protected function getDividerDragRect():Rectangle{
			return null;
		}
		
		protected function onDividerDragEnter(event:DragEvent):void{
			if(event.data.type == DividedBox.DIVIDED_BOX_DIVIDER_MOVE && event.data.source==this){
				DragManager.acceptDragDrop(this);
			}
		}
		
		protected function onDividerDragDrop(event:DragEvent):void{}
		
		protected function onDividerDoubleClick(event:MouseEvent):void{
			var evt:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_DOUBLE_CLICK)
			evt.divider = event.currentTarget as DisplayObject;
			evt.dividerIndex = dividers.indexOf(event.currentTarget);
			dispatchEvent(evt);
		}
		
		protected function onDividerClick(event:MouseEvent):void{
			var evt:DividerEvent = new DividerEvent(DividerEvent.DIVIDER_CLICK)
			evt.divider = event.currentTarget as DisplayObject;
			evt.dividerIndex = dividers.indexOf(event.currentTarget);
			dispatchEvent(evt);
		}
		
		/*
		 Removes the child required and also the previous divider or the next one if one 
		 was created 
		 */ 
		override public function removeChild(child:DisplayObject):DisplayObject{
			
			var prevDivider:DisplayObject;
			for(var i:int=0; i<contentPane.numChildren; i++){
				var uiObject:DisplayObject = contentPane.getChildAt(i)
				if(dividers.indexOf(uiObject)!=-1){
					prevDivider = uiObject
					continue
				}
				if(uiObject == child){
					if(!prevDivider){
						if(i < this.contentPane.numChildren-1){
							prevDivider = contentPane.getChildAt(i+1);
						}
					}
					break;
				}
			}
			
			if(prevDivider){
				contentPane.removeChild(prevDivider);
			}
			return super.removeChild(child);
		}
	}
}