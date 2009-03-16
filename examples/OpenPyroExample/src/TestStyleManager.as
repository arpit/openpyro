package
{
	import org.openPyro.aurora.AuroraButtonSkin;
	import org.openPyro.controls.Button;
	import org.openPyro.controls.events.ButtonEvent;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.UIContainer;
	import org.openPyro.layout.VLayout;
	import org.openPyro.managers.SkinManager;
	import org.openPyro.painters.FillPainter;
	import org.openPyro.painters.Stroke;
	import org.openPyro.examples.SimpleButtonSkin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	public class TestStyleManager extends Sprite{
		
		private var button1:Button;
		private var button2:Button;
		
		public function TestStyleManager(){
			
			stage.scaleMode = "noScale"
			stage.align = "TL"
			
			testButtonSkinning()
			//basicTest();
		}
		
		private function testButtonSkinning():void
		{
			
			var buttonStyleFactory:ClassFactory = new ClassFactory(AuroraButtonSkin);
			buttonStyleFactory.properties = {cornerRadius:10, 
											percentUnusedWidth:100,
											percentUnusedHeight:100}
			
			SkinManager.getInstance().registerSkin(buttonStyleFactory, "Button")
			
			var button:Button = new Button()
			button.width = 150
			button.height = 25;
			addChild(button)
			button.addEventListener(ButtonEvent.DOWN, onButtonDown);
			button.x = button.y = 100;
			
			button2 = new Button()
			button2.width = 150
			button2.height = 25;
			addChild(button2);
			button2.addEventListener(ButtonEvent.DOWN, onButton2Down);
			button2.y = 100
			button2.x = 300;
			
			
		}
		
		private function onButton2Down(event:ButtonEvent):void
		{
			button2.styleName = "coolButtonStyle";
			SkinManager.getInstance().loadSkinSwf("Skin.swf");
		}
		
		private function onButtonDown(event:Event):void
		{
			var buttonStyleFactory:ClassFactory = new ClassFactory(AuroraButtonSkin);
			buttonStyleFactory.properties = {cornerRadius:20, 
												upColors:[0x750811, 0xff0000], 
												overColors:[0xff0000,0x750811],
												downColors:[0x750811, 0x750811],
												percentUnusedWidth:100,
												percentUnusedHeight:100}
			
			SkinManager.getInstance().registerSkin(buttonStyleFactory, "Button")
		}
		
		
		private function basicTest():void{
			var container:UIContainer = new UIContainer()
			addChild(container);
			
			var vLayout:VLayout = new VLayout(60);
			container.layout = vLayout;
			container.x = container.y = 100;
			
			var stroke:Stroke = new Stroke()
			stroke.thickness = 2;
			stroke.color = 0xff0000;
			
			
			var fillPainter:FillPainter = new FillPainter(0xcccccc,.4,stroke);
			container.backgroundPainter = (fillPainter);
			
			
			container.width = 100
			container.height = 300
			
			
			button1 = new Button()
			button1.addEventListener(Event.RESIZE, onResize);
			container.addChild(button1);
			button1.percentUnusedWidth = 100
			button1.percentUnusedHeight = 50;
			
			
			button2 = new Button()
			button2.addEventListener(Event.RESIZE, onResize);
			container.addChild(button2);
			button2.percentUnusedWidth = 100
			button2.percentUnusedHeight = 50;
			
			
			var skin:SimpleButtonSkin = new SimpleButtonSkin();
			button1.skin = skin;
			
			var skinManager:SkinManager = new SkinManager()
			skinManager.addEventListener(SkinManager.SKIN_SWF_LOADED, onSkinSwfLoaded);
			skinManager.registerSkinClient(button2, "SimpleFlaButtonSkin")
			skinManager.loadSkinSwf('Skin.swf');
			
		}
		
		private function onSkinSwfLoaded(event:Event):void{
			trace('swf loaded ')
		}
		
		private function onResize(event:Event):void{
			
		}
		
		public function onStageClick(event:MouseEvent):void{
			/*trace('stage click');
			var skin:SimpleButtonSkin = new SimpleButtonSkin();
			button.skin = skin;
			*/
		}

	}
}