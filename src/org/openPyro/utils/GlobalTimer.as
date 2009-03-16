package org.openPyro.utils
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class GlobalTimer extends EventDispatcher
	{
		
		private var _stage:Stage
		
		private static var frameNumber:Number=0;
		
		public function GlobalTimer(stage:Stage)
		{
			_stage = stage
		}
		
		
		public function start():void
		{
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			frameNumber++;	
		}
		
		public static function getFrameNumber():Number
		{
			return frameNumber;
		}

	}
}