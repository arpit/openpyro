package org.openPyro.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
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
		
		public static function desaturate(source:DisplayObject):void{
			var matrix:Array= new Array();
    
			matrix = matrix.concat([1, 1, 1, 0, 0]); // red
			matrix = matrix.concat([1, 1, 1, 0, 0]); // green
			matrix = matrix.concat([1, 1, 1, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
    
			var cmFilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			source.filters=[cmFilter];
		}
	}
}