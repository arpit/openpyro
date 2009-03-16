package org.openPyro.painters
{
	import flash.display.Graphics;
	import org.openPyro.core.Padding;

	public class CompositePainter implements IPainter
	{
		private var _padding:Padding;
		private var _painters:Array = new Array();
		
		public function CompositePainter()
		{
		}
		
		public function set padding(p:Padding):void
		{
			_padding = p
		}
		
		public function get padding():Padding
		{
			return _padding;
		}
		
		public function addPainter(painter:IPainter):void{
			_painters.push(painter);
		}

		public function draw(gr:Graphics, w:Number, h:Number):void
		{
			for(var i:uint=0; i<_painters.length; i++)
			{
				if(_padding)
				{
					IPainter(_painters[i]).padding = _padding;
				}
				IPainter(_painters[i]).draw(gr,w,h);
			}
		}
		
	}
}