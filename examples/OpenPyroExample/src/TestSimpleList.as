package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openPyro.aurora.AuroraContainerSkin;
	import org.openPyro.aurora.AuroraPainterButtonSkin;
	import org.openPyro.collections.ArrayCollection;
	import org.openPyro.controls.Button;
	import org.openPyro.controls.List;
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.controls.listClasses.DefaultListRenderer;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.UIContainer;
	import org.openPyro.layout.VLayout;
	import org.openPyro.painters.FillPainter;
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
		private var tf:TextField;
		
		private function init(event:Event):void{
			var uic:UIContainer = new UIContainer();
			addChild(uic);
			uic.backgroundPainter = new FillPainter(0xdfdfdf);
			uic.size(400,600)
		
			
			this.removeEventListener(Event.ENTER_FRAME, init)
			list = new List();
			
			var cf:ClassFactory = new ClassFactory(DefaultListRenderer);
			cf.properties = {percentUnusedWidth:100, height:25};
			list.itemRenderer = cf;
			//list.addEventListener(ListEvent.ITEM_CLICK, onListItemClick);
			list.addEventListener(ListEvent.CHANGE, onListItemClick);
			
			list.skin = new AuroraContainerSkin()
			
			list.width = 200;
			list.percentUnusedHeight = 60
			list.x = list.y = 10;
			uic.addChild(list);
			
			var dp:Array = new Array()
			for(var i:int=0; i< 25; i++){
				dp.push("original data: "+i)
			}
			
			list.dataProvider = dp;
			
			var bttn:Button = createButton();
			bttn.label = "Add some data"
			bttn.addEventListener(MouseEvent.CLICK, onBttnClick);
			
			var bttn2:Button = createButton();
			bttn2.label = "Set scrollPosition"
			bttn2.addEventListener(MouseEvent.CLICK, onBttn2Click);
			
			var bttn3:Button = createButton();
			bttn3.label = "Delete #2";
			bttn3.addEventListener(MouseEvent.CLICK, function(event:Event):void{
				list.dataProviderCollection.removeItem(list.dataProviderCollection.getItemAt(2));
			});
			
			var bttn5:Button = createButton();
			bttn5.label = "scroll to 10";
			bttn5.addEventListener(MouseEvent.CLICK, function(event:Event):void{
				list.scrollToItemAtIndex(10)
			});
			
			var bttn4:Button = createButton();
			bttn4.label = "Debug";
			bttn4.addEventListener(MouseEvent.CLICK, function(event:Event):void{
				for(var i:int=0; i<list.contentPane.numChildren; i++){
			 		var a:DisplayObject = getChildAt(i);
			 		with(a){
			 			trace(x, y, width, height);
			 		}
			 	}
			});
			
			tf = new TextField();
			tf.border = true;
			tf.borderColor = 0xdfdfdf;
			tf.background = true;
			tf.backgroundColor = 0xffffff;
			tf.width = 140;
			tf.height = 100;
			tf.defaultTextFormat = new TextFormat("Arial", 12);
			addChild(tf);
			
			var layout:VLayout = new VLayout(10);
			layout.initX = list.width+20;
			layout.initY = 20;
			layout.layout([bttn, bttn2, bttn3,bttn5, bttn4, tf]);
			
		}
		
		private function createButton():Button{
			var bttn:Button = new Button()
			bttn.height = 25
			var bttnSkin:AuroraPainterButtonSkin  = new AuroraPainterButtonSkin();
			bttnSkin.painters = new GradientFillPainter([0xdfdfdf, 0xffffff])
			bttn.skin = bttnSkin;
			addChild(bttn);
			bttn.width = 140;
			return bttn;
		}
		
		private function onBttn2Click(event:Event):void{
			list.verticalScrollPosition = 1;
		}
		
		private var newdataIdx:Number = 0;
		private function onBttnClick(event:MouseEvent):void{
			ArrayCollection(list.dataProviderCollection).addItemsAt(["new data "+newdataIdx++,"new data "+newdataIdx++,"new data "+newdataIdx++], 0)
		}
		
		private function onListItemClick(event:ListEvent):void{
			tf.appendText( "list selectedIndex: "+list.selectedIndex+"\n");
		//	list.dataProviderCollection.removeItem(list.selectedItem);
		}
		
	}
}