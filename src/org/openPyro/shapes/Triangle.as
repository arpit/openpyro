package org.openPyro.shapes
{
	import org.openPyro.core.Direction;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Triangle extends Sprite implements IShape
	{
		private var _direction:String = Direction.UP;
		
		protected var _h:Number;
		protected var _w:Number;
		
		protected var _fillColor:uint = 0x666666;
		protected var _fillAlpha:Number = 1
		
		protected var _strokeColor:uint=0x000000;
		protected var _strokeWidth:Number=0;
		protected var _strokeAlpha:Number=1;
		
		public function Triangle(direction:String = Direction.UP, width:Number=30, height:Number=30)
		{
			_h = height;
			_w = width;
			_direction = direction;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		protected function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawShape();
		}	
		public function setStroke(strokeWidth:Number, strokeColor:uint=0x000000, strokeAlpha:Number=1):void
		{
			this._strokeWidth = strokeWidth;
			this._strokeColor = strokeColor;
			this._strokeAlpha = strokeAlpha;
			if(this.stage){
				drawShape();
			}
		}
		
		public function setFill(fillColor:uint, fillAlpha:uint=1):void
		{
			_fillColor = fillColor;
			_fillAlpha = fillAlpha;
			if(this.stage){
				drawShape();
			}	
		}
		
		public function set direction(pointDirection:String):void
		{
			this._direction = pointDirection;
			if(this.stage){
				drawShape();
			}
		}
		
		public function drawShape():void
		{
			this.graphics.clear();
			if(_strokeWidth > 0){
				this.graphics.lineStyle(_strokeWidth, _strokeColor, _strokeAlpha);
			}
			this.graphics.beginFill(_fillColor, _fillAlpha);
			
			switch (_direction){
				case Direction.UP:
				drawUpArrow()
				break;
				case Direction.DOWN:
				drawDownArrow()
				break;
				case Direction.LEFT:
				drawLeftArrow()
				break;
				case Direction.RIGHT:
				drawRightArrow()
				break;
				
			}
			
			this.graphics.endFill();
		}
		
		private function drawDownArrow():void
		{
			this.graphics.moveTo(0, 0);
			this.graphics.lineTo(_w/2, _h);
			this.graphics.lineTo(_w, 0);
			this.graphics.lineTo(0, 0);
		}
		
		
		private function drawLeftArrow():void
		{					
			this.graphics.moveTo(_w,0);
			this.graphics.lineTo(_w, _h);
			this.graphics.lineTo(0, _h/2);
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
		
		
	}
}