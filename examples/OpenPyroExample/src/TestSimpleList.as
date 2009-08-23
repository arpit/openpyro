package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openPyro.aurora.AuroraContainerSkin;
	import org.openPyro.aurora.AuroraPainterButtonSkin;
	import org.openPyro.collections.ArrayCollection;
	import org.openPyro.controls.Button;
	import org.openPyro.controls.List;
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.controls.listClasses.DefaultListRenderer;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.painters.GradientFillPainter;

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
			for(var i:int=0; i< 100; i++){
				dp.push("original data: "+i)
			}
			
			list.dataProvider = dp;
			
			var bttn:Button = createButton();
			bttn.label = "Add some data"
			bttn.x = 250
			bttn.y = 10;
			bttn.addEventListener(MouseEvent.CLICK, onBttnClick);
			
			var bttn2:Button = createButton();
			bttn2.label = "Set scrollPosition"
			bttn2.x = 250
			bttn2.y = 50
			bttn2.addEventListener(MouseEvent.CLICK, onBttn2Click);
			
			
		}
		
		private function createButton():Button{
			var bttn:Button = new Button()
			bttn.height = 25
			var bttnSkin:AuroraPainterButtonSkin  = new AuroraPainterButtonSkin();
			bttnSkin.painters = new GradientFillPainter([0xdfdfdf, 0xffffff])
			bttn.skin = bttnSkin;
			addChild(bttn);
			bttn.width = 110;
			return bttn;
		}
		
		private function onBttn2Click(event:Event):void{
			list.verticalScrollPosition = 1;
		}
		
		private var newdataIdx:Number = 0;
		private function onBttnClick(event:MouseEvent):void{
			ArrayCollection(list.dataProvider).addItemsAt(["new data "+newdataIdx++], 0)
		}
		
		private function onListItemClick(event:ListEvent):void{
			trace("click --> ");
		}
		
	}
}