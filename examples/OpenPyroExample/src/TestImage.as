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
			image.source = "assets/calvin.jpg"
			
			
		}

	}
}