package {
	import org.openPyro.core.Padding;
	import org.openPyro.core.UIControl;
	import org.openPyro.managers.TooltipManager;
	import org.openPyro.painters.GradientFillPainter;
	import org.openPyro.utils.MathUtil;
	
	import flash.display.Sprite;

	public class OpenPyroTooltip extends Sprite
	{
		
		private var fp:GradientFillPainter = new GradientFillPainter([0xCC0000, 0x220000]);
		private var pad:Padding = new Padding(5,20,5,20);
		
		public function OpenPyroTooltip()
		{
			
			stage.scaleMode = "noScale"
			stage.align = "TL"
			
			TooltipManager.getInstance().moveWithMouse = true;
			
			
			for(var i:int=0; i<10; i++){
				var control:UIControl = new UIControl()
				control.toolTip = "This is a tooltip for "+i;
				control.backgroundPainter = fp;
				control.name = "red";
				control.width = 200
				control.height = 200
				control.x = MathUtil.randRange(0, stage.stageWidth-205);
				control.y = MathUtil.randRange(0,stage.stageHeight-205);
				addChild(control);
			}
			
			
			

		}
	}
}
