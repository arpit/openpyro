package org.openPyro.controls
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import org.openPyro.aurora.AuroraContainerSkin;
	import org.openPyro.controls.events.ButtonEvent;
	import org.openPyro.controls.events.ListEvent;
	import org.openPyro.controls.listClasses.DefaultListRenderer;
	import org.openPyro.controls.skins.IComboBoxSkin;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.UIControl;
	import org.openPyro.effects.Effect;
	import org.openPyro.managers.OverlayManager;
	import org.openPyro.painters.FillPainter;
	import org.openPyro.skins.ISkin;
	import org.openPyro.utils.StringUtil;
	
	[Event(name='open',type='org.openPyro.controls.events.DropDownEvent')]
	[Event(name='close',type='org.openPyro.controls.events.DropDownEvent')]
	[Event(name="change", type="org.openPyro.controls.events.ListEvent")]
	[Event(name="itemClick", type="org.openPyro.controls.events.ListEvent")]

	public class ComboBox extends UIControl
	{
		private var _bttn:Button;
		private var listHolder:Sprite;
		private var _list:List;
	
		public function ComboBox() {
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			listHolder = new Sprite()
			addChild(listHolder);
			
			if(!_bttn){
				_bttn = new Button()
				_bttn.addEventListener(ButtonEvent.DOWN, onButtonDown)
				addChild(_bttn);
				if(_dataProvider){
					_bttn.label = _bttnLabelFunction(_dataProvider[_selectedIndex]);
				}
				if(this._skin){
					if(this._skin is IComboBoxSkin)
					{
						_bttn.skin = IComboBoxSkin(this._skin).buttonSkin
					}
				}
			}
		}
		
		override public function set skin(skinImpl:ISkin):void
		{
			super.skin = skinImpl;
			if(!(skinImpl is IComboBoxSkin)) return;
			var cbSkin:IComboBoxSkin = IComboBoxSkin(this._skin);
			if(this._bttn)
			{
				_bttn.skin = cbSkin.buttonSkin;
			}
			
		}
		
		protected var _dataProvider:Array;
		protected var _selectedIndex:int = -1;
		public function set dataProvider(data:Array):void
		{
			_dataProvider = data;
			_selectedIndex = 0;
			if(_bttn)
			{
				_bttn.label = _bttnLabelFunction(data[0]);
			}
		}
		
		public var _bttnLabelFunction:Function = StringUtil.toStringLabel;
			
		public function set button(bttn:Button):void{
			if(_bttn){
				_bttn.removeEventListener(ButtonEvent.DOWN, onButtonDown)	
			}
			_bttn = bttn;
			_bttn.addEventListener(ButtonEvent.DOWN, onButtonDown)
		}
		
		public function set list(l:List):void{
			if(_list){
				_list.removeEventListener(ListEvent.ITEM_CLICK,onListItemClick);
				_list.removeEventListener(ListEvent.CHANGE, onListChange);
			}
			_list.addEventListener(ListEvent.ITEM_CLICK, onListItemClick)
			_list.addEventListener(ListEvent.CHANGE, onListChange);
		}
		
		protected var _isOpen:Boolean = false;
		
		private function onButtonDown(event:Event):void{
			if(_isOpen)
			{
				close()
			}
			else
			{
				open()
			}
			
		}
		
		protected var _maxDropDownHeight:Number = NaN;
		
		/**
		 * Sets the height of the dropdown list. If this value
		 * is set and the list's data needs more height than that
		 * was set as the <code>maxDropDownHeight</code>, the list
		 * tries to create a scrollbar as long as the IComboButtonSkin
		 * specifies a List skin with Scrollbars defined.
		 * 
		 * @see org.openPyro.controls.skins.IComboBoxSkin
		 */ 
		public function set maxDropDownHeight(value:Number):void
		{
			_maxDropDownHeight = value;	
		}
		
		/**
		 * @private
		 */ 
		public function get maxDropDownHeight():Number
		{
			return _maxDropDownHeight;
		}
		
		public function open():void
		{
			if(_isOpen) return;
			_isOpen = true;
			
			
			
			if(!_list)
			{
				_list = new List();
				_list.skin = new AuroraContainerSkin();
				var renderers:ClassFactory = new ClassFactory(DefaultListRenderer);
				renderers.properties = {percentWidth:100, height:25};
				_list.itemRenderer = renderers;
				
				/*
				Hack: For some reason without any background painter, the list renders
				with a 1px line dividing itemRenderers initially. So we just set the
				backgroundPainter to white.
				*/
				_list.backgroundPainter = new FillPainter(0xffffff);
		
				_list.filters = [new DropShadowFilter(2,90, 0, .5,2,2)];
				
				listHolder.addChildAt(_list,0);
				var overlayManager:OverlayManager = OverlayManager.getInstance();
				if(!overlayManager.overlayContainer){
					var sprite:Sprite = new Sprite();
					this.stage.addChild(sprite);
					overlayManager.overlayContainer = sprite;
				}
				overlayManager.showOnOverlay(listHolder, this);
				_list.width = this.width;
				
				if(!isNaN(_maxDropDownHeight))
				{
					_list.height = _maxDropDownHeight;	
				}
				_list.dataProvider = _dataProvider;	
				_list.addEventListener(ListEvent.ITEM_CLICK, onListItemClick);
				_list.addEventListener(ListEvent.CHANGE, onListChange);
				_list.validateSize();
				
			}
			
			_list.selectedIndex = _selectedIndex;
			
			_list.y = this.height+2;
			
			Effect.on(_list).slideDown(1).onComplete(function():void{
				stage.addEventListener(MouseEvent.CLICK, onStageClick)
			});
			
		}
		
		protected function onStageClick(event:MouseEvent):void{
			if(this._isOpen){
				close();
			}
		}
		
		protected function onListItemClick(event:ListEvent):void
		{
			this._bttn.label = _bttnLabelFunction(_list.selectedItem);
			_selectedIndex = _list.selectedIndex;
			dispatchEvent(event);
			close()
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		protected function onListChange(event:ListEvent):void
		{
			_selectedIndex = _list.selectedIndex;
			dispatchEvent(event.clone());
		}
		
		public function close():void
		{
			if(!_isOpen) return;
			stage.removeEventListener(MouseEvent.CLICK, onStageClick)
			_isOpen = false;
			//TweenMax.to(_list, .5, {y:this.height-_list.height})
			Effect.on(_list).wipeUp(.5);
		}
		
		
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_bttn){
				_bttn.width = unscaledWidth;
				_bttn.height = unscaledHeight;
			}
		}

	}
}