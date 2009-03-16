package
{
	import org.openPyro.core.UIContainer;
	import org.openPyro.core.UIControl;
	import org.openPyro.layout.ColumnGridLayout;
	import org.openPyro.painters.FillPainter;
	
	import flash.display.Sprite;
	
	public class TestLayouts extends Sprite
	{
		public function TestLayouts()
		{
			
			stage.scaleMode = "noScale"
			stage.align = "TL"
			
			var c1:UIContainer = new UIContainer()
			c1.width = c1.height = 600;
			c1.backgroundPainter = new FillPainter(0xffffff)
			c1.layout = new ColumnGridLayout(5, 60, 10);
			addChild(c1);
			
			for(var i:uint=0; i<20; i++){
				var c:UIControl = new UIControl()
				c.width = c.height = 50;
				c.backgroundPainter = new FillPainter(0xcccccc);
				c1.addChild(c);
				
			}
		}

	}
}