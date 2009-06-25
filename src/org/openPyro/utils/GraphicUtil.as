package org.openPyro.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	/**
	 * GraphicUtil contains a series of static helper functions
	 * for graphics
	 */ 
	public class GraphicUtil
	{
		public function GraphicUtil(){}
		
		/**
		 * Returns a Bitmap of the source DisplayObject
		 */ 
		public static function getBitmap(source:DisplayObject, transparent:Boolean=true, fillColor:uint=0):Bitmap{
			var data:BitmapData = new BitmapData(source.width, source.height,transparent,fillColor)
			data.draw(source);
			var bmp:Bitmap = new Bitmap(data)
			return bmp;
		}
	}
}