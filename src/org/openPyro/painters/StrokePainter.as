package org.openPyro.painters
{
	import org.openPyro.core.Padding;
	
	import flash.display.Graphics;
	
	/**
	 * Paints a Stroke on the Graphics context of a DisplayObject.
	 * The Painter can be configured to paint only selected sides
	 * of a control
	 */ 
	public class StrokePainter implements IPainter
	{
		private var _stroke:Stroke;
		private var _padding:Padding;
		
		private var _top:Boolean;
		private var _right:Boolean;
		private var _bottom:Boolean
		private var _left:Boolean;
		
		public function StrokePainter(stroke:Stroke, top:Boolean=true, right:Boolean=true, bottom:Boolean=true, left:Boolean=true ){
			_stroke = stroke;	
			_top = top
			_right = right
			_bottom = bottom
			_left = left
		}
		
		public function setBorderSides( top:Boolean=true, right:Boolean=true, bottom:Boolean=true, left:Boolean=true):void{
			_top = top
			_right = right
			_bottom = bottom
			_left = left
		}
		
		/**
		 * @inheritDoc
		 */ 
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
			
			gr.lineStyle(_stroke.thickness, 
						_stroke.color, 
						_stroke.alpha, 
						_stroke.pixelHinting, 
						_stroke.scaleMode, 
						_stroke.caps,
						_stroke.joints,
						_stroke.miterLimit);
			
			gr.moveTo(drawX, drawY);
			
			_top?gr.lineTo(drawW, drawY):gr.moveTo(drawW, drawY);
			_right?gr.lineTo(drawW, drawH):gr.moveTo(drawW, drawH);
			_bottom?gr.lineTo(drawX, drawH):gr.moveTo(drawX, drawH);
			_left?gr.lineTo(drawX, drawY):gr.moveTo(drawX, drawY);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set padding(p:Padding):void
		{
			_padding = p
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function get padding():Padding
		{
			return _padding;
		}

	}
}