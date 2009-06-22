package org.openPyro.core
{
	import flash.events.Event;
	
	/**
	 * Application is the top level Sprite that constitutes the main 
	 * canvas of the OpenPyro application. 
	 * 
	 * [Todo] The Application sprite is responsible for preloaders, 
	 * for the application, setup logging and any kind of manager.  
	 */ 
	public class Application extends UIContainer
	{
		
		protected var _applicationWidth:uint = 0;
		protected var _applicationHeight:uint = 0;
		
		public function Application(applicationWidth:uint = 0, applicationHeight:uint=0)
		{
			_applicationWidth = applicationWidth;
			_applicationHeight = applicationHeight;
			
			if(!this.stage){
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			else{
				onAddedToStage();
			}
		}
		
		protected function onAddedToStage(event:Event=null):void{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if(stage.stageWidth == 0 || stage.stageHeight == 0){
				this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else{
				appInit();
			}
		}
		
		private function onEnterFrame(event:Event):void{
			if(stage.stageWidth == 0 || stage.stageHeight == 0) return;
			this.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			appInit();
		}
		
		/**
		 * This function is called once the application has ensured it has
		 * a reference to the stage variable that is not 0. If no 
		 * applicationWidth, applicationHeight is set for the Application,
		 * the application goes to its default behavior of being as big as the
		 * stage and resizing when the stage resizes.
		 */ 
		protected function appInit():void{
			if(_applicationWidth == 0 || _applicationHeight == 0){
				_applicationWidth = stage.stageWidth;
				_applicationHeight = stage.stageHeight;
				stage.addEventListener(Event.RESIZE, onStageResize);
			}
			this.width = _applicationWidth;
			this.height = _applicationHeight;
		}
		
		private function onStageResize(event:Event):void{
			_applicationWidth = stage.stageWidth;
			_applicationHeight = stage.stageHeight;
			this.width = _applicationWidth;
			this.height = _applicationHeight;
		}

	}
}