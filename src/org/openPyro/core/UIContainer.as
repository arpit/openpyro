package org.openPyro.core{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.openPyro.controls.ScrollBar;
	import org.openPyro.controls.events.ScrollEvent;
	import org.openPyro.controls.skins.IScrollableContainerSkin;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.layout.AbsoluteLayout;
	import org.openPyro.layout.IContainerMeasurementHelper;
	import org.openPyro.layout.ILayout;

	/**
	 * UIContainers extend UIControls and introduce
	 * the concept of scrolling and layouts. If the 
	 * bounds of the children of a UIContainer, they
	 * get clipped by the mask layer on top.
	 * 
	 * todo: Create UIContainer.clipContent = false/true function 
	 * 
	 * @see #layout
	 */ 
	public class UIContainer extends UIControl{
		
		protected var contentPane:UIControl;
		protected var _horizontalScrollPolicy:Boolean = true
		protected var _verticalScrollPolicy:Boolean = true;
		
		public function UIContainer(){
			super();
			contentPane = new UIControl();
			contentPane.name = "contentPane_"+this.name
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function initialize():void
		{
			/*
			Since the first time the container is
			validated, it may cause scrollbars to 
			be added immediately, the contentPane
			is added before any of that so that 
			scrollbars are not placed under it
			*/
			$addChild(contentPane);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			
			super.initialize();
			
			contentPane.percentUnusedWidth = 100;
			contentPane.percentUnusedHeight = 100;
			contentPane.doOnAdded()
			
			this.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver, true)
		
		}
		
		public static var mouseOverDisabled:Boolean = false;
		
		private function handleMouseOver(event:MouseEvent):void{
			if(UIContainer.mouseOverDisabled){
				event.stopImmediatePropagation()
				event.preventDefault()
			}
		}
		
		public function set horizontalScrollPolicy(b:Boolean):void{
			_horizontalScrollPolicy = b;
		}
		public function get horizontalScrollPolicy():Boolean{
			return _horizontalScrollPolicy
		}
		
		public function set verticalScrollPolicy(b:Boolean):void{
			_verticalScrollPolicy = b;
		}
		
		public function get verticalScrollPolicy():Boolean{
			return _verticalScrollPolicy;
		}

        override public function addChild(child:DisplayObject):DisplayObject
		{
			return addChildAt(child, this.contentPane.numChildren);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var ch:DisplayObject = contentPane.addChild(child);
			if(child is MeasurableControl)
			{
				var control:MeasurableControl  = child as MeasurableControl;
				control.parentContainer = this;
				control.addEventListener(PyroEvent.SIZE_INVALIDATED, invalidateSize);
				control.addEventListener(PyroEvent.SIZE_CHANGED, queueValidateDisplayList);
				control.doOnAdded()
			}
			return ch;
		}
		
		override public function getChildByName(name:String):DisplayObject{
			return contentPane.getChildByName(name);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject{
			return contentPane.removeChild(child)
		}
		
		public function removeAllChildren():void{
			while(this.contentPane.numChildren>0){
				contentPane.removeChildAt(0);
			}
		}
		
		override protected function doChildBasedValidation():void
		{
			var child:DisplayObject;
			if(isNaN(this._explicitWidth) && isNaN(this._percentWidth) && isNaN(_percentUnusedWidth))
			{
				super.measuredWidth = _layout.getMaxWidth(this.layoutChildren) + _padding.left + _padding.right;
			}
			if(isNaN(this._explicitHeight) && isNaN(this._percentHeight) && isNaN(_percentUnusedHeight))
			{
				super.measuredHeight = _layout.getMaxHeight(this.layoutChildren) + _padding.top + _padding.bottom;
			}
		}
		
		
		private var _explicitlyAllocatedWidth:Number = 0;
		private var _explicitlyAllocatedHeight:Number = 0;
		
		/**
		 * This property are modified by IContainerMeasurementHelpers.
		 * which most container layouts implement.
		 * 
		 * @see org.openPyro.layout.IContainerMeasurementHelper 
		 */ 
		public function set explicitlyAllocatedWidth(w:Number):void
		{
			_explicitlyAllocatedWidth = w;
		}
		
		/**
		 * @private
		 */ 
		public function get explicitlyAllocatedWidth():Number
		{
			return _explicitlyAllocatedWidth ;
		}
		
		/**
		 * This property are modified by IContainerMeasurementHelpers.
		 * which most container layouts implement.
		 * 
		 * @see org.openPyro.layout.IContainerMeasurementHelper 
		 */ 
		public function set explicitlyAllocatedHeight(h:Number):void
		{
			_explicitlyAllocatedHeight = h;
		}
		
		/**
		 * @private
		 */ 
		public function get explicitlyAllocatedHeight():Number
		{
			return _explicitlyAllocatedHeight;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * If validateSize is called on UIContainers, the container does
		 * a check at the end to see if the children layout requires a 
		 * scroll and if the scrollbar needs to be created. If so, it
		 * creates the scrollbars and calls validateSize again.
		 */ 
		override public function validateSize():void
		{
			_contentHeight = this._layout.getMaxHeight(this.layoutChildren);
			_contentWidth = this._layout.getMaxWidth(this.layoutChildren);
			_explicitlyAllocatedWidth = _padding.left+_padding.right
			_explicitlyAllocatedHeight = _padding.top+_padding.bottom;
			var layoutChildrenArray:Array = layoutChildren;
			
			_layout.initX = this.padding.left;
			_layout.initY = this.padding.top;
			
			if(_layout is IContainerMeasurementHelper)
			{
				IContainerMeasurementHelper(_layout).calculateSizes(layoutChildrenArray, this)
			}
			super.validateSize();
			
			if(this._verticalScrollBar && _verticalScrollBar.visible)
			{
				this.explicitlyAllocatedWidth-=_verticalScrollBar.width;
				_verticalScrollBar.setScrollProperty(this.scrollHeight, this._contentHeight);
			}
			
			if(this._horizontalScrollBar && _horizontalScrollBar.visible)
			{
				this.explicitlyAllocatedHeight-=_horizontalScrollBar.height
				_horizontalScrollBar.setScrollProperty(this.scrollWidth, contentWidth);	
			}
			
			if(_verticalScrollBar)
			{
				if(_horizontalScrollBar && _horizontalScrollBar.visible){
					_verticalScrollBar.height = this.height - _horizontalScrollBar.height//setActualSize(_verticalScrollBar.width,this.height - _horizontalScrollBar.height);	
				}
				else{
					_verticalScrollBar.height = this.height
				}
			}
			if(_horizontalScrollBar)
			{
				if(_verticalScrollBar && _verticalScrollBar.visible)
				{
					_horizontalScrollBar.width = this.width-_verticalScrollBar.width;
				}
				else{
					_horizontalScrollBar.width = this.width;
				}
			}
			checkRevalidation()	
		}
		
		protected var _layout:ILayout = new AbsoluteLayout()
		protected var layoutInvalidated:Boolean = true;
		/**
		 * Containers can be assigned different layouts
		 * which control the positioning of the 
		 * different controls.
		 * 
		 * @see org.openPyro.layout
		 */ 
		public function get layout():ILayout
		{
			return _layout;
		}
		
		/**
		 * @private
		 */ 
		public function set layout(l:ILayout):void
		{
			if(_layout == l) return;
			layoutInvalidated = true;
			_layout = l;
			_layout.container = this;
			if(!initialized) return;
			
			this.invalidateSize()
		}
		
		/**
		 * Returns an Array of displayObjects whose positions
		 * are controlled by the <code>ILayout</code> object.
		 * These do not include, for example, the scrollbars.
		 * 
		 * @see org.openPyro.layout
		 */ 
		public function get layoutChildren():Array
		{
			var children:Array = new Array();
			if(!contentPane) return children;
			for(var i:uint=0; i<this.contentPane.numChildren; i++)
			{
				var child:MeasurableControl = contentPane.getChildAt(i) as MeasurableControl
				if(!child || !child.includeInLayout) continue;
				children.push(child);
			}
			return children;
		}
		
		/////////// END LAYOUT ///////////
		
		/**
		 * @inheritDoc
		 */ 
		override public function widthForMeasurement():Number
		{
			var containerWidth:Number = this.width - this._explicitlyAllocatedWidth
			if(this._verticalScrollBar && _verticalScrollBar.visible==true)
			{
				containerWidth-=_verticalScrollBar.width;
			}
			return containerWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function heightForMeasurement():Number
		{
			var containerHeight:Number =  this.height-this._explicitlyAllocatedHeight;
			if(this._horizontalScrollBar && _horizontalScrollBar.visible==true)
			{
				containerHeight-=_horizontalScrollBar.height;
			}
			return containerHeight;
		}
		
		/**
		 * scrollWidth is the max width a horizontal 
		 * scrollbar needs to scroll
		 */ 
		public function get scrollWidth():Number
		{
			var containerWidth:Number = this.width-padding.left-padding.right
			if(this._verticalScrollBar && _verticalScrollBar.visible==true)
			{
				containerWidth-=_verticalScrollBar.width;
			}
			return containerWidth;
		}
		
		/**
		 * scrollHeight is the max height a vertical 
		 * scrollbar needs to scroll
		 */ 
		public function get scrollHeight():Number
		{
			var containerHeight:Number =  this.height-padding.top-padding.bottom;
			if(this._horizontalScrollBar && _horizontalScrollBar.visible==true)
			{
				containerHeight-=_horizontalScrollBar.height;
			}
			return containerHeight;
		}
		
		protected var _verticalScrollBar:ScrollBar;
		protected var _horizontalScrollBar:ScrollBar;
		
		/**
		 * Returns The instance of the created verticalScrollBar
		 * or null if it was never created or is not visible. Note
		 * that this function does cannot be used to detect if the
		 * scrollbar was created or not, since scrollbars once 
		 * created are never distroyed, even if a subsequent change
		 * in the container's layout does not require the scrollbar
		 * anymore.
		 */ 
		public function get verticalScrollBar():ScrollBar
		{
			if(_verticalScrollBar && _verticalScrollBar.visible)
			{
				return _verticalScrollBar
			}
			else
			{
				return null;
			}
		}
		
		
		/**
		 * Returns The instance of the created horizontal
		 * or null if it was never created or is not visible. Note
		 * that this function does cannot be used to detect if the
		 * scrollbar was created or not, since scrollbars once 
		 * created are never distroyed, even if a subsequent change
		 * in the container's layout does not require the scrollbar
		 * anymore.
		 */ 
		public function get horizontalScrollBar():ScrollBar
		{
			if(_horizontalScrollBar && _horizontalScrollBar.visible)
			{
				return _horizontalScrollBar
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * @private
		 */ 
		public function set verticalScrollBar(scrollBar:ScrollBar):void
		{
			if(_verticalScrollBar)
			{
				_verticalScrollBar.removeEventListener(ScrollEvent.SCROLL, onVerticalScroll);
				_verticalScrollBar.removeEventListener(PyroEvent.UPDATE_COMPLETE, onVScrollBarUpdateComplete)
				_verticalScrollBar.removeEventListener(PyroEvent.SIZE_VALIDATED, onVerticalScrollBarSizeValidated)
			}
			_verticalScrollBar = scrollBar;
			addChild(scrollBar);
			if(this._contentHeight > this.height)
			{
				setVerticalScrollBar();
			}
		}
		
		protected var scrollBarsChanged:Boolean = false;
		
		protected function checkRevalidation():void
		{
			if(_horizontalScrollPolicy){
				checkNeedsHScrollBar()
			}
			if(_verticalScrollPolicy)
			{
				checkNeedsVScrollBar()
			}
			
			if(needsHorizontalScrollBar && 
					this._skin && 
					this._skin is IScrollableContainerSkin && 
					IScrollableContainerSkin(_skin).horizontalScrollBarSkin)
			{
				if(!_horizontalScrollBar)
				{
					createHScrollBar();
				}
				if(_horizontalScrollBar.visible==false)
				{
					_horizontalScrollBar.visible = true;
					scrollBarsChanged = true;
				}
			}
			else
			{
				if(_horizontalScrollBar && _horizontalScrollBar.visible==true)
				{
					_horizontalScrollBar.visible = false;
					scrollBarsChanged = true;
				}
			}
			if(needsVerticalScrollBar && 
				this._skin && 
				this._skin is IScrollableContainerSkin && 
				IScrollableContainerSkin(_skin).verticalScrollBarSkin)
			{
				if(!_verticalScrollBar)
				{
					createVScrollBar();
				}
				if(_verticalScrollBar.visible == false)
				{
					_verticalScrollBar.visible = true;
					scrollBarsChanged=true;
				}
			}
			else
			{
				if(_verticalScrollBar && _verticalScrollBar.visible == true)
				{
					_verticalScrollBar.visible = false;
					scrollBarsChanged = true;
				}
			}
			
			if(scrollBarsChanged)
			{
				scrollBarsChanged = false;
				dispatchEvent(new PyroEvent(PyroEvent.SCROLLBARS_CHANGED));
				validateSize();
			}
		}
			
		protected var _contentHeight:Number = 0;
		protected var _contentWidth:Number = 0;
		
		public function get contentHeight():Number{
			return _contentHeight;
		}
		public function get contentWidth():Number{
			return _contentWidth;
		}
		
		
		protected var needsVerticalScrollBar:Boolean = false;
		protected var needsHorizontalScrollBar:Boolean = false;
		
		protected function checkNeedsVScrollBar():void
		{
			_contentHeight = this._layout.getMaxHeight(this.layoutChildren);
			if(_contentHeight > this.height){
				needsVerticalScrollBar = true
			}
			else{
				needsVerticalScrollBar = false;
			}
		}
		protected function checkNeedsHScrollBar():void
		{
			_contentWidth = this._layout.getMaxWidth(this.layoutChildren);
			if(_contentWidth > this.width){
				needsHorizontalScrollBar = true
			}
			else{
				needsHorizontalScrollBar = false;
			}
		}
		
		protected function createVScrollBar():void
		{
			_verticalScrollBar = new ScrollBar(Direction.VERTICAL);
			_verticalScrollBar.maximum = 1;
			_verticalScrollBar.minimum = 0;
			_verticalScrollBar.incrementalScrollDelta = _verticalScrollIncrement;
			_verticalScrollBar.name = "vscrollbar_"+this.name;
			_verticalScrollBar.width = 15;
			_verticalScrollBar.addEventListener(Event.ADDED_TO_STAGE, function():void{
				_verticalScrollBar.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void{
					mouseOverDisabled = true;
				})
				_verticalScrollBar.stage.addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void{
					mouseOverDisabled = false;
				})
			});
			_verticalScrollBar.addEventListener(PyroEvent.SIZE_VALIDATED, onVerticalScrollBarSizeValidated);
			_verticalScrollBar.addEventListener(PyroEvent.UPDATE_COMPLETE, onVScrollBarUpdateComplete);
			_verticalScrollBar.skin = IScrollableContainerSkin(_skin).verticalScrollBarSkin;
			_verticalScrollBar.addEventListener(ScrollEvent.SCROLL, onVerticalScroll)
			_verticalScrollBar.doOnAdded()
			_verticalScrollBar.visible = false;
			$addChild(_verticalScrollBar);
			_verticalScrollBar.addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void{
				mouseOverDisabled = false;
			})
		}
		
		protected function hideVScrollBar():void
		{
			if(_verticalScrollBar)
			{
				_verticalScrollBar.visible=false;
			}
		}
			
		protected function createHScrollBar():void
		{
			_horizontalScrollBar = new ScrollBar(Direction.HORIZONTAL);
			_horizontalScrollBar.maximum = 1
			_horizontalScrollBar.minimum = 0
			_horizontalScrollBar.incrementalScrollDelta = _horizontalScrollIncrement
			_horizontalScrollBar.name = "hscrollbar_"+this.name;
			_horizontalScrollBar.height = 15;
			
			_horizontalScrollBar.addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void{
				_horizontalScrollBar.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void{
					mouseOverDisabled = true;
				});
				_horizontalScrollBar.stage.addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void{
					mouseOverDisabled = false;
				});			
			});
			
			_horizontalScrollBar.addEventListener(PyroEvent.SIZE_VALIDATED, onHorizontalScrollBarSizeValidated)
			_horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, onHorizontalScroll);
			_horizontalScrollBar.parentContainer = this;
			_horizontalScrollBar.doOnAdded()
			_horizontalScrollBar.skin = IScrollableContainerSkin(_skin).horizontalScrollBarSkin;	
			_horizontalScrollBar.visible = false;
			$addChild(_horizontalScrollBar);
		}
		
		protected function onHorizontalScrollBarSizeValidated(event:PyroEvent):void
		{
			_horizontalScrollBar.removeEventListener(PyroEvent.SIZE_VALIDATED, onHorizontalScrollBarSizeValidated)
			_horizontalScrollBar.setScrollProperty(this.scrollWidth, contentWidth);	
		}
		
		protected function onVerticalScrollBarSizeValidated(event:PyroEvent):void
		{
			_verticalScrollBar.removeEventListener(PyroEvent.SIZE_VALIDATED, onVerticalScrollBarSizeValidated)
			_verticalScrollBar.setScrollProperty(this.scrollWidth, contentWidth);
		}
		
		protected function hideHScrollBar():void
		{
			if(_horizontalScrollBar)
			{
				_horizontalScrollBar.visible=false;
			}
		}
		
		protected function setVerticalScrollBar():void{
			if(_verticalScrollBar.parent != this)
			{
				addChild(_verticalScrollBar);
			}
			_verticalScrollBar.height = this.height;
		}
		
		protected function handleMouseWheel(event:MouseEvent):void{
			if(this.verticalScrollBar){
				var scrollDelta:Number = verticalScrollBar.value - event.delta*.02;
				scrollDelta = Math.min(scrollDelta, 1)
				scrollDelta = Math.max(0, scrollDelta);
				verticalScrollBar.value = scrollDelta;
			}
		}
		
		public function set horizontalScrollPosition(value:Number):void{
			if(!_horizontalScrollBar) return
			if(value > 1){
				throw new Error("UIContainer scrollpositions range from 0 to 1")
			}
			this._horizontalScrollBar.value = value;
		}
		
		public function get horizontalScrollPosition():Number{
			return _horizontalScrollBar.value;
		}
		
		private var _horizontalScrollIncrement:Number = 25;
		public function set horizontalScrollIncrement(n:Number):void{
			_horizontalScrollIncrement = n;
			if(_horizontalScrollBar){
				_horizontalScrollBar.incrementalScrollDelta = n;
			}
		}
		
		public function get horizontalScrollIncrement():Number{
			return _horizontalScrollIncrement
		}
		
		private var _verticalScrollIncrement:Number = 25;
		public function set verticalScrollIncrement(n:Number):void{
			_verticalScrollIncrement = n;
			if(_verticalScrollBar){
				_verticalScrollBar.incrementalScrollDelta = n;
			}
		}
		
		public function get verticalScrollIncrement():Number{
			return _verticalScrollIncrement
		}
		
		
		/**
		 * Sets the scrollposition of the vertical scrollbar
		 * The valid values are between 0 and 1 
		 */ 
		public function set verticalScrollPosition(value:Number):void{
			if(!_verticalScrollBar) return;
			if(value > 1){
				throw new Error("UIContainer scrollpositions range from 0 to 1")
			}
			this._verticalScrollBar.value = value;
		}
		
		public function get verticalScrollPosition():Number{
			return _verticalScrollBar.value;
		}
		
		protected var scrollY:Number = 0;
		protected var scrollX:Number = 0;
		
		/**
		 * Event listener for when the vertical scrollbar is 
		 * used.
		 */ 
		protected function onVerticalScroll(event:ScrollEvent):void
		{
			var scrollAbleHeight:Number = this._contentHeight - this.height;
			if(_horizontalScrollBar)
			{
				scrollAbleHeight+=_horizontalScrollBar.height;
			}
			scrollY = event.value*scrollAbleHeight
			setContentMask()
		}
		
		/**
		 * Event listener for when the horizontal scrollbar is 
		 * used.
		 */ 
		protected function onHorizontalScroll(event:ScrollEvent):void
		{
			var scrollAbleWidth:Number = this.contentWidth - this.width;
			if(_verticalScrollBar)
			{
				scrollAbleWidth+=_verticalScrollBar.width;
			}
			scrollX = event.value*scrollAbleWidth
			setContentMask()
		}
		
		/**
		 * Unlike UIControls, UIContainers do not apply a skin directly on 
		 * themselves but interpret the skin file and apply them to the 
		 * different children. So updateDisplayList here does not call
		 * super.updateDisplayList()
		 * 
		 * @inheritDoc
		 */ 
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(layoutInvalidated)
			{
				doLayoutChildren()
			}
			if(_verticalScrollBar && _verticalScrollBar.visible==true)
			{
				_verticalScrollBar.x = this.width - _verticalScrollBar.width;
			}
			if(_horizontalScrollBar && _horizontalScrollBar.visible==true)
			{
				_horizontalScrollBar.y = this.height - _horizontalScrollBar.height;
			}	
			super.updateDisplayList(unscaledWidth, unscaledHeight);	
			if(_clipContent){
				//this.scrollRect = new Rectangle(0,0,unscaledWidth, unscaledHeight);
				this.setContentMask()
			}
		}
		
		
		protected var _clipContent:Boolean = true;
		
		public function set clipContent(b:Boolean):void
		{
			if(!b) this.scrollRect = null;
			_clipContent = b;
		}
		
		public function get clipContent():Boolean
		{
			return _clipContent;
		}
		
		/**
		 * Lays out the layoutChildren based <code>ILayout</code>
		 * object. 
		 * 
		 * @see #layoutChildren
		 */ 
		override public function doLayoutChildren():void
		{
			_layout.layout(this.layoutChildren);
			layoutInvalidated = false;
		}
		
		/**
		 * Event listener for the vertical scrollbar's
		 * creation and validation event.
		 */ 
		protected function onVScrollBarUpdateComplete(event:PyroEvent):void
		{
			if(_horizontalScrollBar){
				_horizontalScrollBar.y = _verticalScrollBar.height;
				if(_clipContent){
					//this.scrollRect = new Rectangle(0,0, this.width, this.height);
					this.setContentMask()
				}
			}
		}
		
		/**
		 * Event listener for the horizontal scrollbar's
		 * creation and validation event.
		 */
		protected function onHScrollBarUpdateComplete(event:PyroEvent):void
		{
			if(_verticalScrollBar){
				_verticalScrollBar.x = _horizontalScrollBar.width;
				if(_clipContent){
					//this.scrollRect = new Rectangle(0,0, this.width, this.height);
					this.setContentMask()
				}
			}
		}
		
		protected function setContentMask():void{
			var contentW:Number = width
			var contentH:Number = height;
			
			if(_verticalScrollBar && _verticalScrollBar.visible==true){
				contentW-=_verticalScrollBar.width	
			}
			if(_horizontalScrollBar && _horizontalScrollBar.visible==true){
				contentH-=_horizontalScrollBar.height
			}
			if(_verticalScrollBar){
				
			}
			var rect:Rectangle = new Rectangle(scrollX,scrollY,contentW,contentH);
			
			this.contentPane.scrollRect = rect
		}
	}
}
