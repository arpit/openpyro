package org.openPyro.examples
{
	import org.openPyro.core.UIControl;
	import org.openPyro.skins.ISkin;
	
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class DimensionMarkerSkin extends UIControl implements ISkin
	{
		
		private var _control:UIControl
		
		private var widthTxt:TextField
		private var heightTxt:TextField;
		
		public function DimensionMarkerSkin()
		{
			widthTxt = new TextField()
			widthTxt.autoSize = "left"
			widthTxt.defaultTextFormat = new TextFormat("Arial",11,0x00e0fb)
			
			heightTxt = new TextField()
			heightTxt.autoSize = "left"
			heightTxt.defaultTextFormat = new TextFormat("Arial",11,0x00e0fb)
			
			addChild(widthTxt)
			addChild(heightTxt);
			
			this.percentUnusedWidth = 100
			this.percentUnusedHeight = 100;
			
		}

		public function get selector():String
		{
			return null;
		}
		
		override public function set skinnedControl(uic:UIControl):void
		{
			this._control = uic;
			_control.addChild(this);
				
		}
		
		override public function validateSize():void{
			//trace(this+ ' validate size called '+this.usesMeasurementStrategy)
			super.validateSize();
		}
	
		
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var gr:Graphics = this.graphics;
			gr.clear();
			gr.lineStyle(1,0x333333);
			gr.beginGradientFill("linear",[0xffffff,0xdfdfdf],[1,1],[0,255]);
			gr.drawRect(0,0,unscaledWidth,unscaledHeight);
			gr.endFill();
			
			gr.lineStyle(1,0x00e0fb);
			gr.moveTo(2,10)
			gr.lineTo(unscaledWidth-4, 10);
			
			widthTxt.text = isNaN(_control.explicitWidth)?_control.percentUnusedWidth+"%":_control.explicitWidth+"px"
			widthTxt.x = unscaledWidth/2
			widthTxt.y = 12;
			
			
			gr.moveTo(10,2)
			gr.lineTo( 10, unscaledHeight-4);
			
			heightTxt.text = isNaN(_control.explicitHeight)?_control.percentUnusedHeight+"%":_control.explicitHeight+"px"
			heightTxt.x = 12
			heightTxt.y = unscaledHeight/2;
		}
		
	}
}