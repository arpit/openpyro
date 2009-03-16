package org.openPyro.examples{
	import org.openPyro.controls.events.ButtonEvent;
	import org.openPyro.core.UIControl;
	import org.openPyro.skins.ISkin;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class SimpleButtonSkin extends UIControl implements ISkin{
		
		private var _control:UIControl;
		private var _cornerRadius:Number;
		
		public function SimpleButtonSkin(cornerRadius:Number=5){
			super();
			this._cornerRadius = cornerRadius;
		}
		
		private var matrix:Matrix = new Matrix();
		
		override public function set skinnedControl(uic:UIControl):void{
			_control = uic;
			_control.addChildAt(this, 0);
			_control.addEventListener(Event.RESIZE, onResize);	
			
			matrix.createGradientBox(_control.width, _control.height, Math.PI/2);
			
			if(!isNaN(_control.width) && !isNaN(_control.height)){
			var gr:Graphics = this.graphics
			gr.lineStyle(1,0x777777)
			gr.beginGradientFill('linear',[0xdfdfdf, 0xffffff],[1,1],[0,255],matrix);
			gr.drawRoundRect(0,0,_control.width, _control.height,_cornerRadius,_cornerRadius);
			gr.endFill();	
			}	
		}
		
		private function onResize(event:Event):void{
			var gr:Graphics = this.graphics
			matrix.createGradientBox(_control.width, _control.height, Math.PI/2);
			gr.clear()
			gr.lineStyle(1,0x777777)
			gr.beginGradientFill('linear',[0xdfdfdf, 0xffffff],[1,1],[0,255],matrix);
			gr.drawRoundRect(0,0,_control.width, _control.height,_cornerRadius,_cornerRadius);
			gr.endFill();	
		}
		
		public function get selector():String{
			return "SimpleButtonSkin";
		}
		
		public function changeState(fromState:String, toState:String):void{
			var gr:Graphics = this.graphics
			gr.clear();
			gr.lineStyle(1,0x777777)
			if(toState == ButtonEvent.UP){
				gr.beginGradientFill('linear',[0xdfdfdf, 0xffffff],[1,1],[0,255],matrix);
			}
			else if(toState == ButtonEvent.OVER){
				gr.beginGradientFill('linear',[0xffffff,0xdfdfdf],[1,1],[0,255],matrix);
			}
			else if(toState == ButtonEvent.DOWN){
				gr.lineStyle(2,0x56A0EA);
				gr.beginGradientFill('linear',[0xffffff,0xdfdfdf],[1,1],[0,255],matrix);
			}
			else{
				gr.beginGradientFill('linear',[0xdfdfdf, 0xffffff],[1,1],[0,255],matrix);
			}
			gr.drawRoundRect(0,0,_control.width, _control.height,_cornerRadius,_cornerRadius);
			gr.endFill();		
		}
		
	}
}