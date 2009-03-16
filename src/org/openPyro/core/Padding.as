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
		
		public function Padding(top:Number=0, right:Number=0, bottom:Number=0, left:Number=0)
		{
			_top = top;
			_right = right;
			_bottom = bottom;
			_left = left;
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

	}
}