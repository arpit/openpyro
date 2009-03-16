package
{
	import org.openPyro.core.Direction;
	import org.openPyro.shapes.Triangle;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestShapes extends Sprite
	{
		private var triangle:Triangle
		public function TestShapes()
		{
			stage.scaleMode = "noScale"
			stage.align = "TL"
			triangle = new Triangle(Direction.LEFT, 100,50);
			this.addEventListener(Event.ENTER_FRAME, init)
		}
		
		private function init(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, init)
			addChild(triangle);
		}

	}
}