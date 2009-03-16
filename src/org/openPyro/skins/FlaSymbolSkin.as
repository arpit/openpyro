package org.openPyro.skins
{
	import org.openPyro.core.UIControl;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class FlaSymbolSkin implements ISkin{
		
		private var _skin:MovieClip
		private var _control:UIControl;
		
		public function FlaSymbolSkin()
		{
			
		}
		
		public function set movieClipClass(mcClass:Class):void
		{
			_skin = new mcClass();
		}
		
		public function get selector():String
		{
			return null;
		}
		
		public function set skinnedControl(uic:UIControl):void
		{
			_control = uic;
			_control.addChildAt(_skin, 0);
			if(!_skin) return;
			
			_skin.width = uic.width
			_skin.height = uic.height;
			_control.addEventListener(Event.RESIZE, onControlResize)
		}
		
		private function onControlResize(event:Event):void{
			_skin.width = event.target.width
			_skin.height = event.target.height;	
		}
		
		public function onState(fromState:String, toState:String):void
		{
			this._skin.gotoAndPlay(toState)
		}
		
		public function dispose():void
		{
			
		}
		
	}
}