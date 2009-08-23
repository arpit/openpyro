package
{
	import org.openPyro.aurora.AuroraComboBoxSkin;
	import org.openPyro.aurora.AuroraContainerSkin;
	import org.openPyro.controls.ComboBox;
	import org.openPyro.controls.List;
	import org.openPyro.controls.listClasses.DefaultListRenderer;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.layout.VLayout;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	public class TestComboBox extends Sprite
	{
		public function TestComboBox()
		{
			stage.scaleMode = "noScale"
			stage.align = "TL"
			
			testCB()
			
		}
		
		private var _list:List;
		private function testBasicList():void
		{
			_list = new List()
			_list.skin = new AuroraContainerSkin()
			var renderers:ClassFactory = new ClassFactory(DefaultListRenderer)
			renderers.properties = {percentWidth:100, height:25}
			_list.itemRenderer = renderers;
			_list.filters = [new DropShadowFilter(2,90, 0, .5,2,2)];
			addChildAt(_list,0);
			_list.width = 100;
			//_list.height = 200;
			_list.dataProvider = ["one","two","three","four"];
			
			_list.x = _list.y = 10
			
			
		}
		
		private function testCB():void
		{
			var comboBox:ComboBox = new ComboBox()
			comboBox.width = 200
			comboBox.height = 25
			comboBox.skin = new AuroraComboBoxSkin()
			comboBox.x = comboBox.y = 50;
			comboBox.dataProvider = ["one","two","three","four","five","six"]
			addChild(comboBox);
		}
		
	}
}