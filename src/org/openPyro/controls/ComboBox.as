package org.openPyro.controls
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openPyro.aurora.AuroraContainerSkin;
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
		
		/**
		 * Defines whether changes in selectedItem change the 
		 * label of the button defined. Note, even if this property
		 * is set to true but the <code>button</code> does not
		 * have a <code>label</code> property, nothing will 
		 * change on the button
		 */ 
		public var bindButtonLabelToSelectedItem:Boolean = true;
		
		private var _bttn:UIControl;
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
				Button(_bttn).toggle = true;
				_bttn.addEventListener(MouseEvent.MOUSE_DOWN, onButtonDown)
				addChild(_bttn);
				if(_dataProvider){
					if(_bttn.hasOwnProperty("label")){
						_bttn["label"] = _bttnLabelFunction(_dataProvider[_selectedIndex]);
					}
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
			if(_bttn && _bttn.hasOwnProperty("label") && bindButtonLabelToSelectedItem)
			{
				_bttn["label"] = _bttnLabelFunction(data[0]);
			}
		}
		
		public var _bttnLabelFunction:Function = StringUtil.toStringLabel;
			
		public function set button(bttn:UIControl):void{
			if(_bttn){
				_bttn.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonDown);	
			}
			_bttn = bttn;
			if(!bttn.parent){
				addChild(bttn);
			}
			_bttn.addEventListener(MouseEvent.MOUSE_DOWN, onButtonDown)
		}
		
		public function set list(l:List):void{
			if(_list){
				_list.removeEventListener(ListEvent.ITEM_CLICK,onListItemClick);
				_list.removeEventListener(ListEvent.CHANGE, onListChange);
			}
			_list = l;
			if(this._dataProvider){
				_list.dataProvider = _dataProvider;
			}
			_list.addEventListener(ListEvent.ITEM_CLICK, onListItemClick)
			_list.addEventListener(ListEvent.CHANGE, onListChange);
		}
		
		protected var _isOpen:Boolean = false;
		
		/**
		 * Check to see if the ComboBox is open or not. The only way
		 * to set this value is by calling open().
		 */ 
		public function get isOpen():Boolean{
			return _isOpen;
		}
		
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
				_list.selectedIndex = _selectedIndex;
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
			} else{
				_list.selectedIndex = _selectedIndex;
			}	
			
			listHolder.addChildAt(_list,0);
			var overlayManager:OverlayManager = OverlayManager.getInstance();
			if(!overlayManager.overlayContainer){
				var sprite:Sprite = new Sprite();
				this.stage.addChild(sprite);
				overlayManager.overlayContainer = sprite;
			}
			overlayManager.showOnOverlay(listHolder, this._bttn);
			_list.width = this.width;
			
			if(!isNaN(_maxDropDownHeight))
			{
				_list.height = _maxDropDownHeight;	
			}
			_list.dataProvider = _dataProvider;	
			_list.dropShadowEnabled = true;
			_list.addEventListener(ListEvent.ITEM_CLICK, onListItemClick);
			_list.addEventListener(ListEvent.CHANGE, onListChange);
			_list.validateSize();
			_list.visible = false;
			
			_list.y = _bttn.height+2;
			_list.visible = true;
			Effect.on(_list).slideDown(1).onComplete(function():void{
					overlayManager.overlayContainer.stage.addEventListener(MouseEvent.CLICK, onStageClick)
			});
		}
		
		protected function onStageClick(event:MouseEvent):void{
			if(this._isOpen){
				if(_bttn is Button){
					Button(_bttn).selected=false;
				}
				close();
			}
		}
		
		protected function onListItemClick(event:ListEvent):void
		{
			if(_bttn.hasOwnProperty("label") && bindButtonLabelToSelectedItem){
				this._bttn["label"] = _bttnLabelFunction(_list.selectedItem);
			}
			_selectedIndex = _list.selectedIndex;
			dispatchEvent(event);
			if(_bttn is Button){
				Button(_bttn).selected=false;
			}
			close()
		}
		
		public function get selectedIndex():int{
			return _selectedIndex;
		}
		
		public function get selectedItem():*{
			return _dataProvider[_selectedIndex];
		}
		
		protected function onListChange(event:ListEvent):void
		{
			_selectedIndex = _list.selectedIndex;
			dispatchEvent(event.clone());
		}
		
		public function close():void
		{
			if(!_isOpen) return;
			OverlayManager.getInstance().overlayContainer.stage.removeEventListener(MouseEvent.CLICK, onStageClick)
			_isOpen = false;
			Effect.on(_list).wipeUp(.5).onComplete(function():void{
				_list.visible = false;
			});
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