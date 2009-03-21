package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.openPyro.aurora.AuroraCheckBoxSkin;
	import org.openPyro.controls.Button;
	
	public class TestCheckBox extends Sprite
	{
		public function TestCheckBox()
		{
			super();
			stage.scaleMode = "noScale";
			stage.align = "TL"
			this.addEventListener(Event.ENTER_FRAME, onEF);
		}
		
		private function onEF(event:Event):void{
			this.removeEventListener(Event.ENTER_FRAME, onEF);
			var cb:Button = new Button();
			cb.skin = new AuroraCheckBoxSkin();
			cb.toggle = true;
			cb.label = "Label";
			cb.x = cb.y = 10
			addChild(cb);
			
		}
		
	}
}