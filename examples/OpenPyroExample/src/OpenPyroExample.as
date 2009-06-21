package {
	import org.openPyro.controls.*;
	import org.openPyro.core.*;
	import org.openPyro.layout.*;
	import org.openPyro.examples.DimensionMarkerSkin;
	
	import flash.display.Sprite;
	import flash.events.*;

	public class OpenPyroExample extends Sprite{
		
		private var overall:UIContainer
		private var container:UIContainer;
		private var red:UIControl;
		private var blue:UIControl;
		
		public function OpenPyroExample(){
			stage.scaleMode = "noScale"
			stage.align = "TL"
			testCompositeLayout();
		}
		
		private function testCompositeLayout():void{
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			//stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageClick)
			overall = new UIContainer()
			overall.name = "overall";
			overall.size(stage.stageWidth/2,stage.stageHeight/2);
			overall.x = overall.y = 10;
			
			addChild(overall);
			overall.layout = new HLayout(0);
			
			
			red = new UIControl()
			red.skin = new DimensionMarkerSkin();
			red.name = "red";
			red.percentUnusedHeight=100;
			red.width = 100
			overall.addChild(red);
			
			
			container = new UIContainer();
			container.name = "inner_container_1"
			container.size("100%","100%");
			container.layout = new VLayout();
			
			overall.addChild(container);
			
			
			var green:UIControl = new UIControl();
			green.skin = new DimensionMarkerSkin()
			green.name = "green"
			green.percentUnusedWidth = 100;
			green.percentUnusedHeight = 20
			container.addChild(green);
			
			
			blue = new UIControl()
			blue.skin = new DimensionMarkerSkin()
			blue.name = "blue";
			blue.percentUnusedWidth = 100;
			blue.percentUnusedHeight = 20
			container.addChild(blue);
			
			var c3:UIContainer = new UIContainer()
			c3.name = "container_3";
			c3.layout = new HLayout()
			c3.percentUnusedWidth = 100
			c3.percentUnusedHeight = 60
			
			container.addChild(c3)
			
			var white:UIControl = new UIControl()
			white.skin = new DimensionMarkerSkin()
			white.name="white"
			white.width = 100
			white.percentUnusedHeight=100
			c3.addChild(white)
			
			var c4:UIContainer = new UIContainer()
			c4.name = "c4"
			c4.layout = new VLayout()
			c4.percentUnusedWidth = 100
			c4.percentUnusedHeight=100
			c3.addChild(c4);
			
			var black:UIControl = new UIControl()
			black.skin = new DimensionMarkerSkin()
			black.name = "black"
			black.percentUnusedWidth=100
			black.height=50
			c4.addChild(black)
			
			var greyish:UIControl = new UIControl()
			greyish.skin = new DimensionMarkerSkin()
			greyish.percentUnusedWidth = 100
			greyish.percentUnusedHeight=100
			c4.addChild(greyish);
		}
		private function onStageResize(event:Event):void{
			overall.size(stage.stageWidth/2,stage.stageHeight/2);
		}
	}
	
	
}
