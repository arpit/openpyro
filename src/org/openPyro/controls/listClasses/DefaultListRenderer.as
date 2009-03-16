package org.openPyro.controls.listClasses
{
	import org.openPyro.core.UIControl;
	import org.openPyro.painters.FillPainter;
	import org.openPyro.painters.IPainter;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class DefaultListRenderer extends UIControl implements IListDataRenderer
	{
		
		protected var _labelField:TextField;
		
		protected var _rollOverBackgroundPainter:IPainter;
		protected var _rollOutBackgroundPainter:IPainter;
		
		public function DefaultListRenderer() {
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler)
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler)
			_labelField = new TextField()
			_labelField.selectable=false;
			
			if(!_labelFormat){
				_labelField.defaultTextFormat= new TextFormat("Arial",12)
			} 
			else{
				_labelField.defaultTextFormat = _labelFormat;
			}
			addChild(_labelField);
			if(_data && _baseListData && _baseListData.list){
				_labelField.text = _baseListData.list.labelFunction(_data);
			}
			
			if(!_rollOverBackgroundPainter){
				_rollOverBackgroundPainter = new FillPainter(0x559DE6)
			}
			if(!_rollOutBackgroundPainter){
				_rollOutBackgroundPainter = new FillPainter(0xffffff)
			}
			this.backgroundPainter = this._rollOutBackgroundPainter
		}
		
		protected var _baseListData:BaseListData;
		public function set baseListData(value:BaseListData):void{
			_baseListData = value
		}
		public function set rollOutBackgroundPainter(painter:IPainter):void
		{
			this._rollOutBackgroundPainter = painter;
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
			}
		}
		
		public function get labelFormat():TextFormat{
			return _labelFormat;
		}
		
		protected function mouseOverHandler(event:MouseEvent):void
		{
			this.backgroundPainter = _rollOverBackgroundPainter;
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			if(!_selected){
				this.backgroundPainter = _rollOutBackgroundPainter;
			}
		}
		
		protected var _data:*;
		
		public function set data(value:Object):void{
			_data = value;
			_labelField.text =  _baseListData.list.labelFunction(_data);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		private var _selected:Boolean = false;
		public function set selected(b:Boolean):void
		{
			_selected = b;
			if(_selected){
				this.backgroundPainter = _rollOverBackgroundPainter;
			}
			else{
				this.backgroundPainter = _rollOutBackgroundPainter;
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
		
			_labelField.x = _labelField.y = 5;
			_labelField.width = unscaledWidth-10
			_labelField.height = Math.max(unscaledHeight-10,20);
			
		}

	}
}