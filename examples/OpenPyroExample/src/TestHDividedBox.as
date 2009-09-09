package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.openPyro.aurora.AuroraHDividedBoxSkin;
	import org.openPyro.containers.HDividedBox;
	import org.openPyro.controls.scrollBarClasses.ScrollPolicy;
	import org.openPyro.core.UIControl;
	import org.openPyro.examples.DimensionMarkerSkin;
	
	public class TestHDividedBox extends Sprite
	{
		public function TestHDividedBox()
		{
			stage.scaleMode = "noScale"
			stage.align = "TL";
			stage.addEventListener(Event.ENTER_FRAME, initialize)
		}
		
		public function initialize(event:Event):void{
			stage.removeEventListener(Event.ENTER_FRAME, initialize);
			
			var hdbox:HDividedBox = new HDividedBox()
			hdbox.skin = new AuroraHDividedBoxSkin();
			hdbox.horizontalScrollPolicy = ScrollPolicy.OFF;
			hdbox.width = 600
			hdbox.height = 400
			
			var redBox:UIControl = new UIControl();
			redBox.name = "redBox"
			redBox.skin = new DimensionMarkerSkin()
			redBox.percentUnusedWidth = 50
			redBox.percentUnusedHeight = 100
			
			var greenBox:UIControl = new UIControl()
			greenBox.name = "greenBox";
			greenBox.skin = new DimensionMarkerSkin()
			greenBox.width = 200
			greenBox.percentUnusedHeight = 100
			
			var blueBox:UIControl = new UIControl()
			blueBox.name  = "blueBox"
			blueBox.skin = new DimensionMarkerSkin()
			blueBox.percentUnusedWidth = 50
			blueBox.percentUnusedHeight = 100
			
			
			
			
			hdbox.addChild(redBox)
			hdbox.addChild(greenBox)
			hdbox.addChild(blueBox);
			
			addChild(hdbox);
			hdbox.x = hdbox.y = 20;
			
		}

	}
}