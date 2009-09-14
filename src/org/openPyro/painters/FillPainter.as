package org.openPyro.painters
{
	import org.openPyro.core.Padding;
	
	import flash.display.Graphics;
	
	public class FillPainter implements IPainter
	{
		public var color:uint;
		public var alpha:Number;
		public var stroke:Stroke;
		private var _padding:Padding;
		private var _cornerRadius:Number=0;
		
		public function FillPainter(color:uint=0xffffff, alpha:Number=1, stroke:Stroke=null, cornerRadius:Number=0){
			this.color = color;
			this.alpha = alpha;
			stroke = stroke;
			_cornerRadius = cornerRadius;	
		}
		
		public function set cornerRadius(r:Number):void{
			_cornerRadius = r;
		}
		
		
		public var initX:Number = 0;
		public var initY:Number = 0;
		
		
		
		public function draw(gr:Graphics, w:Number, h:Number):void
		{
			var drawX:Number = initX;
			var drawY:Number = initY;
			var drawW:Number = w;
			var drawH:Number = h;
			
			if(_padding){
				drawX += _padding.left
				drawY += _padding.top
				drawW -= _padding.right + _padding.left
				drawH -= padding.top + _padding.bottom
			}

			if(stroke){
				gr.lineStyle(stroke.thickness, 
							stroke.color, 
							stroke.alpha, 
							stroke.pixelHinting, 
							stroke.scaleMode, 
							stroke.caps,
							stroke.joints,
							stroke.miterLimit);
			}
			gr.beginFill(color,alpha);
			gr.drawRoundRect(drawX,drawY,drawW,drawH,_cornerRadius, _cornerRadius);
			gr.endFill();
		}
		
		public function set padding(p:Padding):void{
			_padding = p
		}
		
		public function get padding():Padding{
			return _padding;
		}
		
		public function toString():String{
			return ("color: "+color.toString(16)+"\n stroke: "+stroke+"\n"+alpha)
		}
	}
}