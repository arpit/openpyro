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
		
		private var viewStack:SlidePane = new SlidePane();
		private var magenta:UIContainer = new UIContainer()
		private var cyan:UIContainer = new UIContainer()
		private var yellow:UIContainer = new UIContainer()
		
		private function testViewStack():void
		{
			
            viewStack.transitionAttitude = 1;
			viewStack.width = 400;
			viewStack.height = stage.stageHeight-300;
			viewStack.x = viewStack.y = 10;
			viewStack.skin = new AuroraContainerSkin()
			viewStack.backgroundPainter = new FillPainter(0xcccccc);
			addChild(viewStack);
			
			
			cyan.backgroundPainter = new FillPainter(0x00ffff);
			cyan.width = 150;
			cyan.height = 300;
			cyan.name = "cyan";
			viewStack.addChild(cyan);

            yellow.backgroundPainter = new FillPainter(0xffff00);
			yellow.width = 225;
			yellow.height = 350;
			yellow.name = "yellow";
			viewStack.addChild(yellow);

			magenta.backgroundPainter = new FillPainter(0xff00ff);
			magenta.width = 300;
			magenta.height = 400;
			magenta.name = "magenta";
			viewStack.addChild(magenta);
	
            stage.addEventListener(MouseEvent.CLICK, onStageClick);
			stage.addEventListener(Event.RESIZE, function(event:Event):void{
				viewStack.height = stage.stageHeight-300;
			});

		}
		
		private function onStageClick(event:MouseEvent):void
		{
            /*
			if(viewStack.selectedChild == magenta){
				viewStack.selectedChild = cyan
			}
			else
			{
				viewStack.selectedChild = magenta;
			}*/
            viewStack.selectedIndex = ((viewStack.selectedIndex +1) % 3);
		}
		
	}
}
