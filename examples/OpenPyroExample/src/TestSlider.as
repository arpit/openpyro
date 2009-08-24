package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openPyro.aurora.AuroraScrollBarSkin;
	import org.openPyro.aurora.AuroraSliderSkin;
	import org.openPyro.controls.ScrollBar;
	import org.openPyro.controls.Slider;
	import org.openPyro.core.Direction;
	import org.openPyro.core.UIContainer;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.examples.HaloTrackSkin;
	import org.openPyro.examples.SimpleButtonSkin;
	import org.openPyro.layout.VLayout;
	import org.openPyro.painters.FillPainter;
	
	public class TestSlider extends Sprite
	{
		
		public function TestSlider()
		{
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			//testScrollBarWithAuroraSkin();
			//testSliderWithAuroraSkin();
			testSliderBug();
			//stage.addEventListener(Event.RESIZE, onResize)
		}
		
		private function testSliderBug():void{
			
			var container:UIContainer = new UIContainer();
			container.size(585, 700);
			container.layout = new VLayout(10);
			
			container.backgroundPainter = new FillPainter(0xcccccc);
			
			var redMultiplier:Slider = new Slider(Direction.HORIZONTAL);
			redMultiplier.percentWidth = 90;
			redMultiplier.height = 15;
			redMultiplier.minimum = 0;
			redMultiplier.maximum = 4;
			redMultiplier.skin = new AuroraSliderSkin();
			redMultiplier.thumbButtonWidth = 10;
			container.addChild(redMultiplier);
			redMultiplier.value = 1;
			
			var greenMultiplier:Slider = new Slider(Direction.HORIZONTAL);
			greenMultiplier.percentWidth = 90;
			greenMultiplier.height = 15;
			greenMultiplier.minimum = 0;
			greenMultiplier.maximum = 4;
			greenMultiplier.skin = new AuroraSliderSkin();
			greenMultiplier.thumbButtonWidth = 10;
			greenMultiplier.value = 1;
			container.addChild(greenMultiplier);
			
			addChild(container);
		}
		
		private function onResize(event:Event):void
		{
			if(scrollBar)
			{
				scrollBar.height = stage.stageHeight/3;
			}
			if(slider)
			{
				slider.height = stage.stageHeight/3
			}
		}
		
		private var scrollBar:ScrollBar
		private function testScrollBarWithAuroraSkin():void
		{
			scrollBar = new ScrollBar(Direction.VERTICAL);
			scrollBar.addEventListener(PyroEvent.UPDATE_COMPLETE, onScrollBarUpdate);
			scrollBar.x = 150
			scrollBar.y = 100
			
			scrollBar.width = 15;
			scrollBar.height = stage.stageHeight/3;
			addChild(scrollBar);
			
			var auroraScrollBarSkin:AuroraScrollBarSkin = new AuroraScrollBarSkin()
			auroraScrollBarSkin.direction = Direction.VERTICAL;
			scrollBar.skin = auroraScrollBarSkin
		}
		
		private function onScrollBarUpdate(event:PyroEvent):void
		{
			trace("-----------------------");
		}
		
		private var slider:Slider
		private function testSliderWithAuroraSkin():void
		{
			
			var uic:UIContainer = new UIContainer();
			uic.width = 400;
			uic.height = 200;
			uic.backgroundPainter = new FillPainter(0xefefef);
			addChild(uic);
			
			/*
			slider = new Slider(Direction.VERTICAL);
			addChild(slider);
			
			slider.setSize(15, stage.stageHeight/3);
			
			var sliderSkin:AuroraSliderSkin = new AuroraSliderSkin()
			
			slider.skin = sliderSkin
			slider.x = 50;
			slider.y = 100;
			slider.thumbButtonHeight = 20
			
			addChild(slider);
			*/
			
			var hSlider:Slider = new Slider(Direction.HORIZONTAL);
			hSlider.width = 200
			hSlider.height = 15;
			hSlider.thumbButtonWidth = 20;
			
			
			
			uic.addChild(hSlider)
			
			var hSliderSkin:AuroraSliderSkin = new AuroraSliderSkin()
			hSliderSkin.trackGradientRotation = Math.PI/2
			hSlider.skin = hSliderSkin
			
			
			hSlider.x = 50;
			hSlider.y = 50;
			
			stage.addEventListener(MouseEvent.CLICK, function():void{
					
			})
			
			
		}
		
		private function testSliderWithExplicitSkins():void
		{
				
			/*
			slider.thumbSkin = new SimpleButtonSkin();
			slider.addEventListener(SliderEvent.THUMB_DRAG, onThumbDrag)
			slider.trackSkin = new HaloTrackSkin();
			*/
		}
		
		private function testScrollBarWithExplicitSkins():void
		{
			
			var scrollBar:ScrollBar = new ScrollBar(Direction.VERTICAL);
			scrollBar.x = 100
			scrollBar.y = 100
			
			scrollBar.width = 15;
			scrollBar.height = 300;
			addChild(scrollBar);
			
			scrollBar.slider.trackSkin = new HaloTrackSkin()
			scrollBar.slider.thumbSkin = new SimpleButtonSkin()
			scrollBar.incrementButtonSkin = new SimpleButtonSkin()
			scrollBar.decrementButtonSkin = new SimpleButtonSkin();
			
		}
		
		private function onThumbDrag(event:Event):void{
			//trace(this,'-->'+slider.value)
		}

	}
}