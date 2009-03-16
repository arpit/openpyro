package
{
	import org.openPyro.containers.HDividedBox;
	import org.openPyro.containers.VDividedBox;
	import org.openPyro.core.UIControl;
	import org.openPyro.examples.DimensionMarkerSkin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestVDividedBox extends Sprite
	{
		public function TestVDividedBox()
		{
			stage.scaleMode = "noScale"
			stage.align = "TL";
			stage.addEventListener(Event.ENTER_FRAME, initialize)
		}
		
		public function initialize(event:Event):void{
			stage.removeEventListener(Event.ENTER_FRAME, initialize);
			
			var vdbox:VDividedBox = new VDividedBox()
			//hdbox.skin = new AuroraHDividedBoxSkin();
			//vdbox.horizontalScrollPolicy = false;
			vdbox.width = 400
			vdbox.height = 600
			
			var greenBox:UIControl = new UIControl()
			greenBox.name = "greenBox";
			greenBox.skin = new DimensionMarkerSkin()
			greenBox.percentUnusedWidth = 100
			greenBox.height = 40
			
			var redBox:UIControl = new UIControl();
			redBox.name = "redBox"
			redBox.skin = new DimensionMarkerSkin()
			redBox.percentUnusedWidth = 100
			redBox.percentUnusedHeight = 50
			
			
			
			var blueBox:UIControl = new UIControl()
			blueBox.name  = "blueBox"
			blueBox.skin = new DimensionMarkerSkin()
			blueBox.percentUnusedWidth = 100
			blueBox.percentUnusedHeight = 50
			
			
			
			vdbox.addChild(greenBox)
			
			vdbox.addChild(redBox)
			vdbox.addChild(blueBox);
			
			addChild(vdbox);
			
			
		}

	}
}