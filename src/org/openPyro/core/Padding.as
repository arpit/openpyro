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