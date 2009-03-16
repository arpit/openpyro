package org.openPyro.painters
{
	import org.openPyro.core.Padding;
	
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	public class GradientFillPainter implements IPainter
	{
		private var _colors:Array;
		private var _alphas:Array;
		private var _ratios:Array;
		private var _type:String = "linear";
		private var _rotation:Number = 0;
		private var _padding:Padding;
		protected var _stroke:Stroke;
		protected var _cornerRadius:Number = 0
		
		public function GradientFillPainter(colors:Array,alphas:Array=null,ratios:Array=null, rotation:Number=0, cornerRadius:Number=0)
		{
			_colors = colors;
			_alphas = alphas;
			_ratios = ratios;
			_rotation = rotation;
			_cornerRadius = cornerRadius
			if(!_alphas){
				_alphas = new Array();
				for(var i:uint = 0; i<_colors.length; i++){
					_alphas.push(1);	
				}
			}
			
			if(!_ratios){
				_ratios = new Array();
				for(var j:uint = 0; j<_colors.length; j++){
					_ratios.push(j*255/_colors.length);	
				}
				_ratios[0] = 0;
				_ratios[_ratios.length-1]=255;
			}	
		}
		
		public function set rotation(r:Number):void{
			_rotation = r;	
		}
		
		public function set stroke(str:Stroke):void
		{
			_stroke = str;
		}
		
		public function set cornerRadius(val:Number):void
		{
			_cornerRadius = val;	
		}
		
		public function set colors(clrs:Array):void{
			_colors = clrs;
		}
		
		
		public function draw(gr:Graphics, w:Number, h:Number):void
		{
			var drawX:int = 0;
			var drawY:int = 0;
			var drawW:int = w;
			var drawH:int = h;
			
			if(_padding)
			{
				drawX += _padding.left
				drawY += _padding.top
				drawW -= _padding.right + _padding.left
				drawH -= padding.top + _padding.bottom
			}
			
			if(_stroke)
			{
				_stroke.apply(gr);
			}
			
			var m:Matrix = new Matrix()
			m.createGradientBox(w,h,_rotation);
			gr.beginGradientFill(_type,_colors,_alphas,_ratios,m)
			gr.drawRoundRect(drawX,drawY,drawW,drawH, _cornerRadius,_cornerRadius);
			gr.endFill();
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