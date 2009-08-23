package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openPyro.aurora.AuroraButtonSkin;
	import org.openPyro.aurora.AuroraContainerSkin;
	import org.openPyro.collections.ICollection;
	import org.openPyro.collections.XMLCollection;
	import org.openPyro.collections.XMLNodeDescriptor;
	import org.openPyro.controls.Button;
	import org.openPyro.controls.List;
	import org.openPyro.controls.TextInput;
	import org.openPyro.controls.Tree;
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.controls.listClasses.DefaultListRenderer;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.painters.FillPainter;

	public class TestTree extends Sprite
	{
		private var tree:Tree;
		private var ti:TextInput = new TextInput()
			
		public function TestTree()
		{
			stage.scaleMode = "noScale"
			stage.align = "TL"
			
			//createTree()
			testList()
		}
		private function testList():void{
			var l:List = new List();
			l.labelFunction = function(data:XMLNodeDescriptor):String{
				if(data.node.nodeKind() == "element"){
					return String(data.node.@label)
				}
				return String(data.node);
			} 
			l.dataProvider = xmlData;
			l.skin = new AuroraContainerSkin();
			l.backgroundPainter = new FillPainter(0xffffff);
			var r:ClassFactory = new ClassFactory(DefaultListRenderer);
			r.properties = {percentUnusedWidth:100, height:25};
			l.itemRenderer = r;
			l.size(300, 100);
			addChild(l);
			
			
		}
		
		
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
				XMLCollection(tree.dataProvider).filterFunction=null;
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
		
		private var xmlData:XML = <node label="rootNode">
									<leaf label="leaf1">value1</leaf>
									<leaf label="leaf2">value1</leaf>
									<leaf label="leaf3">
										<leaf label="leaf3_1">
											<leaf label="leaf3_2">
											</leaf>
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
			}*/
		}
		
		private function onTreeItemClick(event:ListEvent):void{
			trace("tree>> "+XMLNodeDescriptor(tree.selectedItem).isLeaf());
		}
		
	}
}