package org.openPyro.painters
{
	import org.openPyro.core.Padding;
	
	import flash.display.Graphics;
	
	public class FillPainter implements IPainter
	{
		private var _color:uint;
		private var _alpha:Number;
		private var _stroke:Stroke;
		private var _padding:Padding;
		private var _cornerRadius:Number=0;
		
		public function FillPainter(color:uint, alpha:Number=1, stroke:Stroke=null, cornerRadius:Number=0){
			_color = color;
			_alpha = alpha;
			_stroke = stroke;
			_cornerRadius = cornerRadius;	
		}
		
		public function set cornerRadius(r:Number):void{
			_cornerRadius = r;
		}
		
		public function draw(gr:Graphics, w:Number, h:Number):void
		{
			var drawX:int = 0;
			var drawY:int = 0;
			var drawW:int = w;
			var drawH:int = h;
			
			if(_padding){
				drawX += _padding.left
				drawY += _padding.top
				drawW -= _padding.right + _padding.left
				drawH -= padding.top + _padding.bottom
			}

			if(_stroke){
				gr.lineStyle(_stroke.thickness, 
							_stroke.color, 
							_stroke.alpha, 
							_stroke.pixelHinting, 
							_stroke.scaleMode, 
							_stroke.caps,
							_stroke.joints,
							_stroke.miterLimit);
			}
			gr.beginFill(_color,_alpha);
			gr.drawRoundRect(drawX,drawY,drawW,drawH,_cornerRadius, _cornerRadius);
			gr.endFill();
		}
		
		public function toString():String{
			return ("color: "+_color.toString(16)+"\n stroke: "+_stroke+"\n"+_alpha)
		}
		
		public function set padding(p:Padding):void
		{
			_padding = p
		}
		
		public function get padding():Padding
		{
			return _padding;
		}

	}
}