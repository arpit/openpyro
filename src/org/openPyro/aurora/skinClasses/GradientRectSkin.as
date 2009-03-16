package org.openPyro.aurora.skinClasses{
	import org.openPyro.core.UIControl;
	import org.openPyro.painters.GradientFillPainter;
	import org.openPyro.painters.Stroke;
	
	public class GradientRectSkin extends UIControl
	
	{
		protected var _gradientRotation:Number = 0;
		protected var gradientFill:GradientFillPainter;
		
		public function GradientRectSkin()
		{
			gradientFill = new GradientFillPainter([0x999999,0xdfdfdf],[.6,1],[1,255],_gradientRotation)
			this.backgroundPainter = gradientFill;
		}
		
		public function set gradientRotation(r:Number):void
		{
			_gradientRotation = r;
			gradientFill.rotation = _gradientRotation;
			this.invalidateDisplayList();
		}
		
		protected var _stroke:Stroke = new Stroke(1,0x777777);
		
		public function set stroke(str:Stroke):void{
			_stroke = str;
			gradientFill.stroke = str;
			this.invalidateDisplayList();
		}
		
		public function get stroke():Stroke
		{
			return _stroke;
		}

	}
}