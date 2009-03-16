package org.openPyro.painters
{
	import org.openPyro.core.Direction;
	import org.openPyro.core.Padding;
	
	import flash.display.Graphics;
	
	public class TrianglePainter implements IPainter
	{
		private var _fillColor:uint = 0;
		private var _fillAlpha:Number = 1;
		private var _stroke:Stroke;
		private var _padding:Padding;
		private var _direction:String;
		private var _w:Number;
		private var _h:Number;
		
		public static const CENTERED:String = "centered"
		
		private var graphics:Graphics;
		
		public function TrianglePainter(direction:String = Direction.UP){
			_direction = direction;	
		}
		
		public function setFill(color:uint, alpha:Number=1, stroke:Stroke=null):void{
			_fillColor = color;
			_fillAlpha = alpha;
			_stroke = stroke;	
		}
		
		public function setStroke(thickness:Number, color:uint=0x000000, alpha:Number=1, pixelHinting:Boolean=true):void{
			_stroke = new Stroke(thickness, color, alpha, pixelHinting)
		}
		
		public function draw(gr:Graphics, w:Number, h:Number):void
		{
			graphics = gr;
			_w = w;
			_h = h;
			gr.clear();
			if(_stroke){
				_stroke.apply(gr);
			}
			gr.beginFill(_fillColor, _fillAlpha);
			
			switch (_direction){
				case Direction.UP:		drawUpArrow()
										break;
				case Direction.DOWN:	drawDownArrow()
										break;
				case Direction.LEFT:	drawLeftArrow()
										break;
				case Direction.RIGHT:	drawRightArrow()
										break;
				case CENTERED:			drawCenteredArrow()
										break				
			}
			gr.endFill();
		}
		
		private function drawDownArrow():void
		{
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(Math.floor(_w/2), _h);
			this.graphics.lineTo(_w, 0);
			this.graphics.lineTo(0, 0);
		}
		
		
		private function drawLeftArrow():void
		{					
			_w = Math.round(_w)
			this.graphics.moveTo(_w,0);
			this.graphics.lineTo(_w, _h);
			this.graphics.lineTo(0, Math.round(_h/2));
			this.graphics.lineTo(_w, 0);
		
		}
		
		private function drawRightArrow():void
		{			
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(_w, _h/2);
			this.graphics.lineTo(0, _h);
			this.graphics.lineTo(0, 0);
		}
		
		private function drawUpArrow():void
		{			
			this.graphics.moveTo(0,_h);
			this.graphics.lineTo(_w/2, 0);
			this.graphics.lineTo(_w, _h);
			this.graphics.lineTo( 0, _h);
		}
		
		private function drawCenteredArrow():void{
			this.graphics.moveTo(-_w/2,-_h/2);
			this.graphics.lineTo(_w/2, 0);
			this.graphics.lineTo(-_w/2, _h/2);
			this.graphics.lineTo(-_w/2, -_h/2);
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