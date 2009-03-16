package org.openPyro.painters
{
	import flash.display.Graphics;
	import org.openPyro.core.Padding;
	
	/**
	 * Painters are classes that can draw things on the 
	 * graphics context of any DisplayObject. 
	 */ 
	public interface IPainter
	{
		/**
		 * The padding to be applied to the painter.
		 * Painters will paint only within the area
		 * defined inside the padded area
		 */ 
		function set padding(p:Padding):void;
		
		/**
		 * @private 
		 */ 
		 function get padding():Padding;
		 
		 /**
		 * Paints the graphics context of the DisplayObject
		 */ 
		 function draw(gr:Graphics, w:Number, h:Number):void;
	}
}