package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openPyro.aurora.AuroraContainerSkin;
	import org.openPyro.aurora.AuroraPainterButtonSkin;
	import org.openPyro.collections.TreeCollection;
	import org.openPyro.collections.XMLNodeDescriptor;
	import org.openPyro.controls.Button;
	import org.openPyro.controls.TextInput;
	import org.openPyro.controls.Tree;
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.controls.treeClasses.DefaultTreeItemRenderer;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.UIContainer;
	import org.openPyro.layout.VLayout;
	import org.openPyro.painters.FillPainter;
	import org.openPyro.painters.GradientFillPainter;

	public class TestTree extends Sprite
	{
		private var ti:TextInput = new TextInput()
			
		public function TestTree()
		{
			stage.scaleMode = "noScale"
			stage.align = "TL"
			
			//createTree()
			testList()
		}
		
		private var xmlData:XML = <node label="rootNode">
									<leaf label="leaf3" open="false">
										
											<leaf label="leaf3_2_1"></leaf>
											<leaf label="leaf3_2_2"></leaf>
											<leaf label="leaf3_2_3"></leaf>
											<leaf label="leaf3_2_4"></leaf>
											<leaf label="leaf3_2_5"></leaf>
											<leaf label="leaf3_2_6"></leaf>
											<leaf label="leaf3_2_7"></leaf>
											<leaf label="leaf3_2_8"></leaf>
											<leaf label="leaf3_2_9"></leaf>
											<leaf label="leaf3_2_10"></leaf>
											<leaf label="leaf3_2_11"></leaf>
											<leaf label="leaf3_2_12"></leaf>
											<leaf label="leaf3_2_13"></leaf>
											<leaf label="leaf3_2_14"></leaf>
									</leaf>
									<leaf label="leaf4">
										<leaf label="leaf4_1">
										</leaf>
									</leaf>
									<leaf label="leaf5">
										<leaf label="leaf5_1">
										</leaf>
									</leaf>
									<leaf label="leaf6">
										<leaf label="leaf6_1">
										</leaf>
									</leaf>
									
									
								</node>
								
		private var xmlData2:XML = <node label="rootNode">
									<leaf label="leaf1">value1</leaf>
									<leaf label="leaf2">value1</leaf>
									<leaf label="leaf3">
										<leaf label="leaf3_1">
											<leaf label="leaf3_2">
											</leaf>
										</leaf>
									</leaf>
								</node>
								
		private function testList():void{
			
			var uic:UIContainer = new UIContainer();
			addChild(uic);
			uic.backgroundPainter = new FillPainter(0xdfdfdf);
			uic.size(400,600)
			
			
			var l:Tree = new Tree();
			var xc:TreeCollection = new TreeCollection(xmlData);
			l.dataProvider = xc;
			uic.addChild(l);
			l.addEventListener(ListEvent.ITEM_CLICK, function(event:ListEvent):void{
				trace(l.selectedItem);
			}); 
			
			l.skin = new AuroraContainerSkin();
			l.backgroundPainter = new FillPainter(0xffffff);
			var r:ClassFactory = new ClassFactory(DefaultTreeItemRenderer);
			r.properties = {percentUnusedWidth:100, height:25};
			l.itemRenderer = r;
			l.size(200, 400);
			l.x = l.y = 20;
			addChild(l);
			
			var layout:VLayout = new VLayout(10);
			layout.initX = l.x+l.width+25;
			layout.initY = l.y;
			
			var bttn:Button = createButton('Click', function(event:Event):void{
				for(var i:int = 0; i<xc.length; i++){
					var des:XMLNodeDescriptor = xc.getNodeDescriptorFor(xc.getItemAt(i))
					if(des.depth == 1){
						l.closeNode(des)
					}
				}
			});
			
			layout.layout([bttn]);
			
			
		
			
		}
		
		private function createButton(label:String, clickHandler:Function):Button{
			var bttn:Button = new Button();
			bttn.label = label;
			bttn.height = 25
			var bttnSkin:AuroraPainterButtonSkin  = new AuroraPainterButtonSkin();
			bttnSkin.painters = new GradientFillPainter([0xdfdfdf, 0xffffff])
			bttn.skin = bttnSkin;
			addChild(bttn);
			bttn.width = 140;
			bttn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			return bttn;
		}
		/*
		private function createTree():void{
			tree = new Tree()
			tree.dataProvider = xmlData
			tree.width = 200;
			tree.height = 600;
			
			var bttn:Button = new Button()
			bttn.skin = new AuroraButtonSkin()
			bttn.addEventListener(MouseEvent.CLICK, onButtonClick);
			bttn.width = 70
			bttn.height = 25;
			bttn.label = "close node"
			addChild(bttn);
			bttn.x = 220
			
			tree.y = 10
			tree.x = 10
			tree.addEventListener(PyroEvent.CREATION_COMPLETE, onTreeCreationComplete);
			addChild(tree)
			
			ti.width = 120
			ti.height = 20
			ti.backgroundPainter = new FillPainter(0xffffff)
			ti.addEventListener(PyroEvent.ENTER, onEnterKey)
			addChild(ti);
			ti.x = 220
			ti.y = 60
			
			var bttn2:Button = new Button()
			bttn2.skin = new AuroraButtonSkin()
			bttn2.addEventListener(MouseEvent.CLICK, function(event:Event):void{
				TreeCollection(tree.dataProvider).filterFunction=null;
				//tree.dataProvider = xmlData2
			})
			bttn2.width = 70
			bttn2.height = 25;
			bttn2.label = "Clear"
			addChild(bttn2);
			bttn2.x = 340
			bttn2.y = 60
		}
		
		private function onEnterKey(event:PyroEvent):void{
			ICollection(tree.dataProvider).refresh()
		}
		
		private function onButtonClick(event:Event):void{
			var node:XMLNodeDescriptor = tree.getNodeByLabel('leaf2')
			tree.closeNode(node);
		}
		
		
		
		public function onTreeCreationComplete(event:PyroEvent):void{
			tree.addEventListener(ListEvent.ITEM_CLICK, onTreeItemClick);
			trace("setting dp")
			
			
			/*ICollection(tree.dataProviderCollection).filterFunction = function(item:*, index:int, array:Array):Boolean{
				
				var descriptor:XMLNodeDescriptor = XMLNodeDescriptor(item)
				if(String(descriptor.node.@label).indexOf(ti.text)==0
				||String(descriptor.node).indexOf(ti.text)==0){
					return true
				}
				else{
					return false;
				}
			}
		}
		
		private function onTreeItemClick(event:ListEvent):void{
			trace("tree>> "+XMLNodeDescriptor(tree.selectedItem).isLeaf());
		}
		*/
	}
}