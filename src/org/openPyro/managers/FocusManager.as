package org.openPyro.managers
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import org.openPyro.effects.Effect;
	import org.openPyro.painters.Stroke;
	
	public class FocusManager
	{
		private var _focusChildren:Array;
		
		private var _currentlyFocussedChildIndex:uint;
		
		public static const FOCUS_MANAGER_PRIORITY:int = 100;
		
		private var _stage:Stage;
		public function FocusManager()
		{
			_focusChildren = [];
		}
		
		
		private static var instance:FocusManager;
		public static function getInstance():FocusManager{
			if(!instance){
				instance = new FocusManager();
			}
			return instance;
		}
		
		/**
		 * 
		 */
		public function set stage(s:Stage):void{
			_stage = s;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyUp, false, FOCUS_MANAGER_PRIORITY);
		}
		
		
		/**
		 * Expects an ordered list of focusable children
		 * to tab through.
		 */ 
		public function setFocusChildren(children:Array):void{
			_focusChildren = children;
			for(var i:int=0; i<_focusChildren.length; i++){
				registerFocusChild(_focusChildren[i]);
			}
			if(_focussedChild){
				var idx:Number = _focusChildren.indexOf(_focussedChild);
				if(idx == -1){
					_focussedChildIndex = NaN;
					_focussedChild = null;
				}
				else{
					_focussedChildIndex = idx;
				}
			}
		}
		
		public function get focusChildren():Array{
			return _focusChildren;
		}
		
		public function get focussedChild():DisplayObject{
			return _focussedChild;
		}
		
		public function registerFocusChild(child:DisplayObject):void{
			child.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void{
				if(_focussedChild != child){
					setFocus(child);
				}
			})
		}
		
		private function onStageKeyUp(event:KeyboardEvent):void{
			if(!(event.keyCode == Keyboard.TAB)){
				return;
			}
			// cancel the default tab behavior
			event.stopImmediatePropagation();
			event.preventDefault();
			
			if(isNaN(_focussedChildIndex)){
				setFocus(_focusChildren[0])
			}
			
			if(event.shiftKey){
				// tab forward
				if(_focussedChildIndex == 0){
					setFocus(_focusChildren[_focusChildren.length-1])
				}	
				else{
					setFocus(_focusChildren[_focussedChildIndex-1])
				}
			}
			else{
				// tab backwards
				if(_focussedChildIndex == _focusChildren.length-1){
					setFocus(_focusChildren[0])
				}	
				else{
					setFocus(_focusChildren[_focussedChildIndex+1])
				}
				
			}
		}
		
		
		private var _focussedChildIndex:Number = NaN;
		private var _focussedChild:DisplayObject;
		
		public function setFocus(child:DisplayObject):void{
			_focussedChildIndex = _focusChildren.indexOf(child);
			_focussedChild = child;
			if(child.hasOwnProperty("setFocus")){
				child["setFocus"]()
			}
			drawFocus(child);
		}
		
		
		private var focusRect:Shape
		public var focusStroke:Stroke = new Stroke(2,0x63bbff);
		
		public function drawFocus(child:DisplayObject):void{
			if(focusRect){
				focusRect.graphics.clear();
				focusRect.alpha= 1;
				Effect.on(focusRect).cancelCurrent();
			}
			else{
				focusRect = new Shape();	
			}
			
			focusStroke.apply(focusRect.graphics);
			//focusRect.graphics.beginFill(0xff0000,0.4);
			focusRect.graphics.drawRect(0,0, child.width, child.height);
			
			_stage.addChild(focusRect);
			
			var rect:Rectangle = child.getBounds(_stage)
				
			var point:Point = new Point(rect.x, rect.y);
			var pt:Point = _stage.localToGlobal(point);
			focusRect.x = pt.x
			focusRect.y = pt.y;
			
			Effect.on(focusRect).fadeOut()
			
		}

	}
}