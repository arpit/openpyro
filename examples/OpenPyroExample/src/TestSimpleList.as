package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openPyro.aurora.AuroraButtonSkin;
	import org.openPyro.aurora.AuroraContainerSkin;
	import org.openPyro.controls.Button;
	import org.openPyro.controls.List;
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.controls.listClasses.DefaultListRenderer;
	import org.openPyro.core.ClassFactory;

	public class TestSimpleList extends Sprite
	{
		public function TestSimpleList()
		{
			super();
			stage.scaleMode = "noScale"
			stage.align = "TL"
			this.addEventListener(Event.ENTER_FRAME, init)
		}
		
		private var list:List;
		private function init(event:Event):void{
			this.removeEventListener(Event.ENTER_FRAME, init)
			list = new List();
			
			var cf:ClassFactory = new ClassFactory(DefaultListRenderer);
			cf.properties = {percentUnusedWidth:100, height:25};
			list.itemRenderer = cf;
			list.addEventListener(ListEvent.ITEM_CLICK, onListItemClick)
			list.skin = new AuroraContainerSkin()
			
			list.width = 200
			list.height = 200
			list.x = list.y = 10;
			addChild(list);
			
			var dp:Array = new Array()
			for(var i:int=0; i< 40; i++){
				dp.push("label_"+i)
			}
			
			list.dataProvider = dp;
			
			var bttn:Button = new Button()
			bttn.width = 70
			bttn.height = 25
			bttn.label = "reset"
			bttn.skin = new AuroraButtonSkin()
			addChild(bttn);
			bttn.x = 250
			bttn.y = 10
			bttn.addEventListener(MouseEvent.CLICK, onBttnClick);
			
		}
		
		private function onBttnClick(event:MouseEvent):void{
			list.verticalScrollPosition =1
		}
		
		private function onListItemClick(event:ListEvent):void{
			trace("click")
		}
		
	}
}