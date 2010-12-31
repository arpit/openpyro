package org.openPyro.controls.listClasses
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.openPyro.core.UIControl;
	import org.openPyro.managers.SkinManager;
	import org.openPyro.painters.FillPainter;
	import org.openPyro.painters.IPainter;
	import org.openPyro.skins.ISkin;
	
	/**
	 * The default list item renderer. Creates a _labelField of height 20px that is 
	 * centered no matter how tall the renderer is. It should be noted that the 
	 * creation of the labelField is pretty nicely encapsulated in the 
	 * <code>createLabelField</code> function that can be overridden in your own 
	 * subclass.
	 */ 	
	public class DefaultListRenderer extends UIControl implements IListDataRenderer
	{
		
		protected var _labelField:TextField;
		
		protected var _rollOverBackgroundPainter:IPainter;
		protected var _rollOutBackgroundPainter:IPainter;
		protected var _highlightCursorSprite:Sprite;
		
		public function DefaultListRenderer() {
			super();
			if(!_styleName){
				_styleName = "defaultListRenderer";
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler)
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler)
			
			createLabelField();
			
			if(_data && _baseListData && _baseListData.list){
				_labelField.text = _baseListData.list.labelFunction(_data);
			}
			
			var sk:Object = SkinManager.getInstance().getSkinForStyleName(_styleName);
		
			if(sk && sk.hasOwnProperty("rollOverBackgroundPainter")){
				_rollOverBackgroundPainter = new FillPainter(sk.rollOverBackgroundPainter)
			}
			
			
			if(!_rollOverBackgroundPainter){
				_rollOverBackgroundPainter = new FillPainter(0x559DE6)
			}
			
			if(!_backgroundPainter){
				_backgroundPainter = new FillPainter(0xffffff);
			}
			_highlightCursorSprite = new Sprite();
			addChildAt(_highlightCursorSprite,0);
		}
		
		protected function createLabelField():void{
			_labelField = new TextField()
			_labelField.selectable=false;
			
			if(!_labelFormat){
				_labelField.defaultTextFormat= new TextFormat("Arial",12)
			} 
			else{
				_labelField.defaultTextFormat = _labelFormat;
			}
			_labelField.height = 20;
			addChild(_labelField);
		}
		
		protected var _baseListData:BaseListData;
		
		/**
		 * @private
		 */ 
		public function set baseListData(value:BaseListData):void{
			_baseListData = value
		}
		
		/**
		 * The <code>BaseListData</code> property relates the itemRenderer
		 * to the List (or List subclass) that it belongs to.
		 * 
		 * @see org.openPyro.controls.listClasses.BaseListData
		 */ 
		public function get baseListData():BaseListData{
			return _baseListData;
		}
		
		public function set rollOverBackgroundPainter(painter:IPainter):void
		{
			this._rollOverBackgroundPainter = painter;
		}
		
		protected var _labelFormat:TextFormat;
		public function set labelFormat(format:TextFormat):void
		{
			_labelFormat = format;
			if(_labelField){
				_labelField.defaultTextFormat = format;
				_labelField.setTextFormat(format);
			}
		}
		
		public function get labelFormat():TextFormat{
			return _labelFormat;
		}
		
		protected function mouseOverHandler(event:MouseEvent):void
		{
			if(! this._selected){
				drawHighlightCursor();
			}
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			if(!_selected){
				_highlightCursorSprite.visible=false;	
			}
		}
		
		protected var _data:*;
		
		public function set data(value:Object):void{
			_data = value;
			if( _baseListData && _baseListData.list){
				_labelField.text =  _baseListData.list.labelFunction(_data);
			}
			else{
				_labelField.text = String(data);
			}
			
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		protected var _selected:Boolean = false;
		public function set selected(b:Boolean):void
		{
			_selected = b;
			if(_selected){
				drawHighlightCursor();
			}
			else{
				_highlightCursorSprite.visible = false;
				
			}
			invalidateDisplayList();
			
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_highlightCursorSprite.visible){
				drawHighlightCursor();
			}
			_labelField.y = (unscaledHeight-_labelField.height)/2
			_labelField.x = 5
			_labelField.width = unscaledWidth-10
		}
		
		protected function drawHighlightCursor():void{
			if(isNaN(width) || isNaN(height)){
				return;
			}
			
			_highlightCursorSprite.graphics.clear();
			_rollOverBackgroundPainter.draw(_highlightCursorSprite.graphics,width, height);
			_highlightCursorSprite.visible = true;
		}

	}
}
