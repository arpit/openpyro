package org.openPyro.controls
{
	import flash.display.Sprite;
	
	import org.openPyro.core.UIControl;
	import org.openPyro.painters.FillPainter;
	import org.openPyro.painters.IPainter;
	
	public class ProgressBar extends UIControl{
		
		public function ProgressBar(){}
		
		protected var _fillSkin:Sprite;
		protected var _fillSkinMask:Sprite;
		
		override protected function createChildren():void{
			super.createChildren();
			_fillSkin = new Sprite();
			addChild(_fillSkin);
			
			_fillSkinMask = new Sprite();
			addChild(_fillSkinMask);
			new FillPainter(0xff0000).draw(_fillSkinMask.graphics, 10, 10);
			
			_fillSkin.mask = _fillSkinMask;
			
			// create a default fillPainter
			if(!_fillPainter){
				_fillPainter = new FillPainter(0xdfdfdf);
			}
			if(!_backgroundPainter){
				_backgroundPainter = new FillPainter(0xcccccc);
			}
		}
		
		public function get fillSkin():Sprite{
			return _fillSkin;
		}
		
		protected var _fillPainter:IPainter;
		public function setFillPainter(painter:IPainter):ProgressBar{
			_fillPainter = painter;
			invalidateDisplayList();
			return this;
		}
		
		protected var _percentComplete:Number = 0;
		public function setProgress(value:Number, total:Number):ProgressBar{
			var val:Number = value/total;
			if(val != _percentComplete){
				_percentComplete = val;
				updateProgress();
			}
			return this;
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			_fillSkin.graphics.clear();
			_fillPainter.draw(_fillSkin.graphics, unscaledWidth, unscaledHeight);
			_fillSkinMask.height = unscaledHeight;
			updateProgress();
		}
		
		protected function updateProgress():void{
			if(_fillSkinMask){
				_fillSkinMask.width = width*_percentComplete;
			}
		}

	}
}