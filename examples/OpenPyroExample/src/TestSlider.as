package
{
	import org.openPyro.aurora.AuroraScrollBarSkin;
	import org.openPyro.aurora.AuroraSliderSkin;
	import org.openPyro.controls.ScrollBar;
	import org.openPyro.controls.Slider;
	import org.openPyro.core.Direction;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.examples.HaloTrackSkin;
	import org.openPyro.examples.SimpleButtonSkin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TestSlider extends Sprite
	{
		
		public function TestSlider()
		{
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			testScrollBarWithAuroraSkin();
			//testSliderWithAuroraSkin();
			stage.addEventListener(Event.RESIZE, onResize)
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
			slider = new Slider(Direction.VERTICAL);
			addChild(slider);
			
			slider = new Slider(Direction.VERTICAL);
			slider.setSize(15, stage.stageHeight/3);
			
			var sliderSkin:AuroraSliderSkin = new AuroraSliderSkin()
			
			slider.skin = sliderSkin
			slider.x = 50;
			slider.y = 100;
			addChild(slider);
			
			var hSlider:Slider = new Slider(Direction.HORIZONTAL);
			hSlider.width = 300
			hSlider.height = 15;
			
			var hSliderSkin:AuroraSliderSkin = new AuroraSliderSkin()
			hSliderSkin.trackGradientRotation = Math.PI/2
			
			hSlider.skin = hSliderSkin
			
			addChild(hSlider)
			hSlider.x = 100
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