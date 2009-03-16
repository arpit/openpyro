package
{
	import org.openPyro.aurora.AuroraContainerSkin;
	import org.openPyro.containers.SlidePane;
	import org.openPyro.core.UIContainer;
	import org.openPyro.painters.FillPainter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TestViewStack extends Sprite
	{
		public function TestViewStack()
		{
			super();
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			testViewStack();
		}
		
		private var children:Array = []
		private var viewStack:SlidePane = new SlidePane();
		private var red:UIContainer = new UIContainer()
		private var blue:UIContainer = new UIContainer()
		
		private function testViewStack():void
		{
			
			viewStack.width = 200;
			viewStack.height = stage.stageHeight-300;
			viewStack.x = viewStack.y = 10;
			viewStack.skin = new AuroraContainerSkin()
			viewStack.backgroundPainter = new FillPainter(0xcccccc);
			addChild(viewStack);
			
			
			red.backgroundPainter = new FillPainter(0xff0000);
			red.width = 300;
			red.height = 400;
			red.name = "red";
			viewStack.addChild(red);
			
			children.push(red)
			
			blue.backgroundPainter = new FillPainter(0x0000ff);
			blue.width = 150;
			blue.height = 300;
			blue.name = "blue";
			viewStack.addChild(blue);
			
			children.push(blue)
			
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
			stage.addEventListener(Event.RESIZE, function(event:Event):void{
				viewStack.height = stage.stageHeight-300;
			});
		}
		
		private function onStageClick(event:MouseEvent):void
		{
			if(viewStack.selectedChild == red){
				viewStack.selectedChild = blue
			}
			else
			{
				viewStack.selectedChild = red;
			}
		}
		
	}
}