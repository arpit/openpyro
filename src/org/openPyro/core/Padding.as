package org.openPyro.core
{
	/**
	 * Defines a padding object that is used by different
	 * systems (like Painters) to define active areas in a 
	 * control
	 */ 
	public class Padding
	{
		
		private var _top:Number;
		private var _right:Number;
		private var _bottom:Number;
		private var _left:Number;
		
		/**
		 * Creates a new Padding object.
		 * 
		 * All arguments are optional and the behaviour with missing arguments is based on
		 * the way padding works in standard CSS. If you just provide one argument then that
		 * value is used on all sides. If you provide two arguments then the first argument is
		 * the padding on the top and bottom and the second argument is the padding on the right
		 * and left. If you provide three arguments then the first is the top padding, second 
		 * is right and left padding and the third argument is the bottom padding. If you supply
		 * all four arguments then each argument is the padding for the side it is named on.
		 */
		public function Padding(top:Number=0, right:Number=-1, bottom:Number=-1, left:Number=-1)
		{
			_top = top;
			_right = right > -1 ? right : _top;
			_bottom = bottom > -1 ? bottom : _top;
			_left = left > -1 ? left : _right;
		}
		
		public function get top():Number
		{
			return _top;
		}
		
		public function get right():Number
		{
			return _right;
		}
		
		public function get left():Number
		{
			return _left;
		}
		
		public function get bottom():Number
		{
			return _bottom;	
		}
		
		public function toString():String
		{
			return '[org.openPyro.core.Padding - ' + _top + ' ' + _right + ' ' + _bottom + ' ' + _left + ']';
		}

	}
}