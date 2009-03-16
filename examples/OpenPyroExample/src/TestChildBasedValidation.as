package
{
	import org.openPyro.controls.Label;
	import org.openPyro.core.Padding;
	import org.openPyro.core.UIContainer;
	import org.openPyro.core.UIControl;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.layout.HLayout;
	import org.openPyro.painters.FillPainter;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class TestChildBasedValidation extends Sprite
	{
		private var tag:UIControl ;
		private var label:Label
		private var container:UIContainer = new UIContainer()
		
		private var labelData:Array = ["one","two","three", "four","five"]
		
		public function TestChildBasedValidation()
		{
			stage.scaleMode = "noScale"
			stage.align = "TL";
			stage.addEventListener(MouseEvent.CLICK, onStageMouseClick);
			
			testBasic()
			
		}
		
		private function testText():void
		{
			
		}
		
		
		private function testBasic():void
		{
			// without setting width and height the children arent 
			// being validated. Gah !!!
			//container.width = 600
			//container.height = 50
			
			container.layout = new HLayout(5);
			
			
			for(var i:uint=0; i<labelData.length; i++)
			{
				var tag:UIControl = createLabel(i);
				container.addChild(tag);
			}
			addChild(container);
		}
		
		private function createLabel(i:uint):UIControl
		{
			var label:Label = new Label()
			label.padding = new Padding(5,5,5,5);
			label.text = labelData[i]
			label.textFormat = new TextFormat("Arial",16)
			label.backgroundPainter = new FillPainter(0x00ff00)
			//label.width = 60;
			
			return label;
			
			
		}
		
		private function onLabelUpdateComplete(event:PyroEvent):void
		{
			trace('---> label update complete')
			//trace(label.usesChildBasedValidation)
			
		}
		
		private function onStageMouseClick(event:MouseEvent):void
		{
			trace('setting txt')
			
			//label.text = "hello I am a label"
		}
		
		private function testTagButton():void
		{
			tag = new UIControl();
			tag.name = "tag"
			tag.backgroundPainter = new FillPainter(0x555555);
			tag.addEventListener(PyroEvent.SIZE_VALIDATED, onSizeValidated)
			tag.addEventListener(PyroEvent.UPDATE_COMPLETE, onUpdateComplete);
			addChild(tag);
			
			var uic:UIControl = new UIControl()
			uic.name = "uic"
			uic.width = uic.height = 50;
			
			tag.addChild(uic);
		}
		
		private function onSizeValidated(event:PyroEvent):void
		{
			
		}
		
		private function onUpdateComplete(event:PyroEvent):void
		{
			trace("updateComplete: "+tag.width, tag.height);
		}

	}
}