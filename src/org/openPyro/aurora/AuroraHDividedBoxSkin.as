package org.openPyro.aurora{
	import org.openPyro.aurora.skinClasses.HDividerSkin;
	import org.openPyro.controls.skins.IDividedBoxSkin;
	import org.openPyro.core.UIControl;
	
	public class AuroraHDividedBoxSkin extends AuroraContainerSkin implements IDividedBoxSkin
	{
		public function getNewDividerSkin():UIControl{
			var dividerSkin:UIControl =  new HDividerSkin();
			dividerSkin.width = 8;
			dividerSkin.percentUnusedHeight = 100;
			return dividerSkin;
		}
	}
}