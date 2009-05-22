package {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.openPyro.core.Padding;
	import org.openPyro.core.UIControl;
	import org.openPyro.managers.TooltipManager;
	import org.openPyro.painters.GradientFillPainter;
	import org.openPyro.utils.MathUtil;

	public class OpenPyroTooltip extends Sprite
	{
		
		private var fp:GradientFillPainter = new GradientFillPainter([0xCC0000, 0x220000]);
		private var pad:Padding = new Padding(5,20,5,20);
		
		public function OpenPyroTooltip()
		{
			
			stage.scaleMode = "noScale"
			stage.align = "TL"
			stage.addEventListener(Event.ENTER_FRAME, init);
		}
		
		private function init(event:Event):void{
			stage.removeEventListener(Event.ENTER_FRAME, init);
			
			TooltipManager.getInstance().moveWithMouse = true;
			
			
			for(var i:int=0; i<10; i++){
				var control:UIControl = new UIControl()
				control.toolTip = "This is a tooltip for "+i;
				control.backgroundPainter = fp;
				control.name = "red";
				control.width = 100
				control.height = 100
				control.x = MathUtil.randRange(0, 800);
				control.y = MathUtil.randRange(0, 600);
				addChild(control);
			}
			
		}
	}
}
