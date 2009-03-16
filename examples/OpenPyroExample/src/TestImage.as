package
{
	import org.openPyro.controls.Image;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	public class TestImage extends Sprite
	{
		public function TestImage()
		{
			stage.scaleMode = "noScale"
			stage.align = "TL"
			var image:Image = new Image()
			addChild(image);
			image.width = 300
			image.height = 100
			image.source = "http://img.villagephotos.com/p/2004-7/785459/calvin.jpg"
			
			
		}

	}
}