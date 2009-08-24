package
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openPyro.aurora.AuroraButtonSkin;
	import org.openPyro.controls.Button;
	import org.openPyro.core.Application;
	import org.openPyro.core.UIControl;
	import org.openPyro.effects.Effect;
	import org.openPyro.layout.VLayout;
	import org.openPyro.painters.GradientFillPainter;
	
	public class EffectsTest extends Application
	{
		public function EffectsTest()
		{
			
		}
		
		private var target:UIControl;
		override protected function createChildren():void{
			target = new UIControl();
			target.backgroundPainter = new GradientFillPainter([0xcccccc, 0xffffff],null,null, Math.PI/2);
			
			var tf:TextField = new TextField();
			tf.width = 180;
			tf.height = 180;
			tf.defaultTextFormat = new TextFormat("Arial", 14);
			tf.text = "Hello, this is an effects demo. Click on the buttons on the left to apply different effects.";
			tf.x = tf.y = 10;
			tf.multiline = true;
			tf.wordWrap=true;
			target.addChild(tf);
			
			target.size(200,200);
			target.x = 160;
			target.y = 20;
			addChild(target);
			
			createButton("Fade", function (event:MouseEvent):void{
				Effect.on(target).fadeIn(2);
			});
			createButton("Slide Up", function(event:MouseEvent):void{
				Effect.on(target).slideUp(1);
			});
			createButton("Wipe Up", function(event:MouseEvent):void{
				Effect.on(target).wipeUp(1);
			})
			createButton("Chain wipe and slide", function(event:MouseEvent):void{
				Effect.on(target).wipeDown(1).slideUp(1);
			})
			
			
		}
		
		
		private function createButton(label:String, clickHandler:Function):Button{
			var b:Button = new Button();
			with (b){
				skin = new AuroraButtonSkin();
				width = 140;
				height = 20;
				addEventListener(MouseEvent.CLICK, clickHandler);
			}
			addChild(b);
			b.label = label;
			return b;
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var layoutChildren:Array = [];
			for (var i:int=0; i< this.contentPane.numChildren; i++){
				var ch:DisplayObject = this.contentPane.getChildAt(i);
				if(ch is Button){
					layoutChildren.push(ch);
				}
			}
			var vlayout:VLayout = new VLayout(10);
			vlayout.initX = vlayout.initY = 10;
			vlayout.layout(layoutChildren);
		}
		

	}
}