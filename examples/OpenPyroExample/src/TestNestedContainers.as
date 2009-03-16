package
{
	import org.openPyro.aurora.AuroraContainerSkin;
	import org.openPyro.core.UIContainer;
	import org.openPyro.core.UIControl;
	import org.openPyro.layout.HLayout;
	import org.openPyro.painters.FillPainter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import net.comcast.logging.Logger;
	import net.comcast.logging.consoles.LogBookConsole;
	
	public class TestNestedContainers extends Sprite
	{
		private var container3:UIContainer
		public function TestNestedContainers()
		{
			
			stage.scaleMode = "noScale"
			stage.align = "TL"
			
			Logger.addConsole(new LogBookConsole('_test'))
			Logger.debug(this, "Init")
		
			
			var container:UIContainer = new UIContainer()
			container.name = "c1"
			container.width = 200
			container.percentUnusedHeight = 100
			container.skin = new AuroraContainerSkin()
			
			
			var red:UIControl = new UIControl()
			red.backgroundPainter = new FillPainter(0xff0000)
			red.width = 400
			red.height = 800
			
			container.addChild(red)
			
			//addChild(container);
			//container.validateSize()
			
			var container2:UIContainer = new UIContainer()
			container2.name = "c2"
			container2.width = 300;
			container2.height = 200
			container2.skin = new AuroraContainerSkin()
			
			var blue:UIControl = new UIControl()
			blue.backgroundPainter = new FillPainter(0x0000ff)
			blue.width = 300
			blue.height = 400;
			
			container2.addChild(blue)
			
			container3 = new UIContainer()
			container3.name = "c3"
			container3.skin = new AuroraContainerSkin()
			container3.layout = new HLayout(20)
			
			container3.addChild(container)
			container3.addChild(container2)
			
			
			addChild(container3);
			
			container3.width = stage.stageWidth/3
			container3.height = stage.stageHeight/3
			
			container3.x = container3.y = 100;
			container3.addEventListener(MouseEvent.CLICK, onC3Click);
			
			//container3.filters = [new DropShadowFilter()]
			
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onResize(event:Event):void
		{
			container3.width = stage.stageWidth/3
			container3.height = stage.stageHeight/3
			
		}
		
		private function onC3Click(event:Event):void
		{
			for(var i:uint=0; i<container3.numChildren; i++)
			{
				trace("child: "+i+" -> ",container3.getChildAt(i), container3.getChildAt(i).name);
			}
		}

	}
}