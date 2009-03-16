package org.openPyro.skins
{
	import org.openPyro.core.UIControl;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * This class defines the skins that are composed of raw graphic elements.
	 * For example this class defines button skins that use a graphic element
	 * embedded in the swf.
	 */ 
	public class GraphicSkin extends Sprite implements ISkin
	{
		private var _graphic:DisplayObject
		public function GraphicSkin(graphicObject:DisplayObject=null, useButtonMode:Boolean=true)
		{
			graphic = graphicObject;
			if(useButtonMode)
			{
				this.buttonMode = true;
				this.useHandCursor = true;
				this.mouseChildren = false;
			}
		}
		
		/**
		 * Sets the graphic element that needs to be used as 
		 * the skin
		 */ 
		public function set graphic(gr:DisplayObject):void
		{
			if(_graphic)
			{
				removeChild(_graphic)
				_graphic = null;
			}
			_graphic = gr;
			addChild(_graphic);
		}
		
		/**
		 * @private
		 */ 
		public function get graphic():DisplayObject
		{
			return _graphic
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function set skinnedControl(uic:UIControl):void
		{				
			uic.addChildAt(this,0);
		}
		
		/**
		 * @inheritDoc
		 */ 
		public function dispose():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this)
			}	
		}

	}
}