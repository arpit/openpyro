package{
	import org.openPyro.core.UIContainer;
	import org.openPyro.layout.VLayout;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SimpleRepeater extends Sprite{
		
		private var renderers:Array = []
		
		public function SimpleRepeater(){
			stage.scaleMode = "noScale"
			stage.align = "TL";
			
			var bttn:Sprite = new Sprite()
			var gr:Graphics = bttn.graphics;
			gr.lineStyle(1, 0x333333)
			gr.beginFill(0xcccccc)
			gr.drawRect(0,0,100,40);
			gr.endFill();
			
			bttn.addEventListener(MouseEvent.MOUSE_DOWN, onBttnClick);
			addChild(bttn);
			bttn.x = 500
			bttn.y = 100;
			
			var container:UIContainer = new UIContainer();
			container.width = 300;
			container.height = 600;
			container.layout = new VLayout();
				
			addChild(container);
			
			for(var i:uint=0; i<5; i++){
				var renderer:Renderer = new Renderer();
				renderer.width = 300
				container.addChild(renderer);
				renderers.push(renderer);
			}
			
			var r:Renderer = renderers[0]
			r.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onResize(event:Event):void{
			trace('renderer got resized to '+event.target.height);
		}
		
		private var i:uint = 0
		private var stringList:Array = ["Lorem ipsum dolor sit amet, consectetuer " + 
						"adipiscing elit. Etiam lectus risus, semper varius," + 
						" imperdiet quis, sollicitudin nec, est. Cras in ipsum." + 
						" Mauris eu metus quis lorem aliquet blandit. Aliquam ",
						'hello World']
		public function onBttnClick(event:MouseEvent):void{
			for each(var r:Renderer in renderers){
				r.label = stringList[i]
				i++; 
				if(i == stringList.length){
					i=0;
				}
			}
		}
	}
}

import flash.display.Sprite;
import flash.display.Graphics;
import org.openPyro.core.UIControl;
import flash.text.TextField;
import net.comcast.logging.Logger;
import net.comcast.logging.consoles.TraceConsole;	

internal class Renderer extends UIControl{
	
	private var txt:TextField;
	
	public function Renderer(){
		
		//Logger.addConsole(new TraceConsole());
		
		txt = new TextField()
		txt.border=true;
		addChild(txt);
		txt.autoSize = "left";
		txt.wordWrap=true;
		
	}
	
	public function set label(s:String):void{
		this.txt.text = s;
		this.invalidateSize()
	}
	
	override public function measure():void{
		super.measure()
		
		this.measuredHeight = this.txt.height+20;
		
		//trace('[ ROOT set height ]'+_measuredHeight)
	}
	
	override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
		trace(this, " -> updateDisplayList ")
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		txt.width = unscaledWidth-20
		txt.x = 10
		txt.y = 10
		txt.height = 20
		
		var gr:Graphics = this.graphics;
		gr.clear()
		gr.lineStyle(1, 0x333333)
		gr.beginFill(0xcccccc)
		gr.drawRect(0,0,unscaledWidth,unscaledHeight);
		gr.endFill();
	}
}