package org.openPyro.aurora.skinClasses{
	import org.openPyro.aurora.AuroraButtonSkin;
	import org.openPyro.controls.Button;
	import org.openPyro.core.UIControl;
	import org.openPyro.painters.GradientFillPainter;

	public class HDividerSkin extends UIControl 
	{
		public function HDividerSkin()
		{
			super();
		}
		
		private var closeButton:Button;
		override protected function createChildren():void{
			this.backgroundPainter = new GradientFillPainter([0x999999, 0xffffff, 0x999999]);
			closeButton = new Button()
			closeButton.skin = new AuroraButtonSkin()
			closeButton.percentWidth=100;
			closeButton.height = 70;
			addChild(closeButton);
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			closeButton.y = (unscaledHeight-70)/2
		}
		
	}
}