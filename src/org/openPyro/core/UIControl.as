package org.openPyro.core{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.openPyro.events.PyroEvent;
	import org.openPyro.managers.DragManager;
	import org.openPyro.managers.SkinManager;
	import org.openPyro.managers.TooltipManager;
	import org.openPyro.managers.events.DragEvent;
	import org.openPyro.painters.IPainter;
	import org.openPyro.skins.ISkin;
	import org.openPyro.skins.ISkinClient;
	
	
	[Event(name="dragDrop", type="org.openPyro.managers.events.DragEvent")]
	
	
	/**
	 * The UIControl is the basic building block for
	 * pyro controls. UIControls extend from Measurable control so
	 * can use all the different sizing properties like explicit or percent widths/heights.
	 * UIControls can also include other UIControls
	 * as children but cannot use layouts to position them. To use layouts, 
	 * use UIContainers.
	 * 
	 * UIControls also implement the ISkinClient interface so can be skinned and
	 * the ISkin interface so themselves can be used as base classes for skins
	 */ 
	public class UIControl extends MeasurableControl implements ISkinClient, ISkin{
		
		public function UIControl() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function initialize():void
		{
			super.initialize()
			if(_skin || !_styleName ) return;
			SkinManager.getInstance().registerSkinClient(this, _styleName);
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return addChildAt(child, this.numChildren);
		}
		
		
		/**
		 * @inheritDoc
		 */ 
		override public function addChildAt(child:DisplayObject,index:int):DisplayObject
		{
			var ch:DisplayObject =  super.$addChildAt(child, index);
			if(child is MeasurableControl)
			{
				var control:MeasurableControl  = child as MeasurableControl;
				control.parentContainer = this;
				control.addEventListener(PyroEvent.SIZE_INVALIDATED, invalidateSize);
				control.addEventListener(PyroEvent.SIZE_CHANGED, queueValidateDisplayList);
				control.doOnAdded()
			}
			this.invalidateSize()
			return ch
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function measure():void{
			if(isNaN(this._explicitWidth) && 
				(!isNaN(this._percentWidth) || !isNaN(_percentUnusedWidth)))
			{
				calculateMeasuredWidth()
			}
			if(isNaN(this._explicitHeight) && 
				(!isNaN(this._percentHeight) || !isNaN(_percentUnusedHeight)))
			{
				calculateMeasuredHeight();
			}
			this.needsMeasurement=false;
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function checkDisplayListValidation():void
		{
			doChildBasedValidation()
			super.checkDisplayListValidation()
		}
		
		/**
		 * While UIControls can be sized based on the dimensions of the parent
		 * container, if the explicit or percent dimension values are not specified,
		 * the UIControl can look at its children's dimensions and base its
		 * sizing off them.
		 * 
		 * For example, Label controls can look at the size of the text rendered
		 * by them to define their own width.
		 */ 
		protected function doChildBasedValidation():void
		{
			var child:DisplayObject;
			if(isNaN(this._explicitWidth) && isNaN(this._percentWidth) && isNaN(_percentUnusedWidth))
			{
				var maxW:Number = 0
				for(var j:uint=0; j<this.numChildren; j++){
					child = this.getChildAt(j);
					if(child.width > maxW)
					{
						maxW = child.width;
					}
				}
				
				super.measuredWidth = maxW + _padding.left + _padding.right;
			}
			if(isNaN(this._explicitHeight) && isNaN(this._percentHeight) && isNaN(_percentUnusedHeight))
			{
				var maxH:Number = 0
				for(var k:uint=0; k<this.numChildren; k++){
					child = this.getChildAt(k);
					if(child.height > maxH)
					{
						maxH = child.height;
					}
				}
				super.measuredHeight = maxH + _padding.top + _padding.bottom;
			}
		}
		
		
		/**
		 * Overrides the set measuredWidth property from 
		 * <code>MeasurableControl</code> to invalidate children
		 * (UIControl acknowledges that it can have children whose
		 * dimensions are based on its own)
		 */ 
		override public function set measuredWidth(w:Number):void{
			if(w  == _measuredWidth) return;
			_dimensionsChanged = true;
			_measuredWidth = w;
			for(var i:uint=0; i<this.numChildren; i++){
				var child:UIControl = this.getChildAt(i) as UIControl;
				if(!child) continue;
				child.needsMeasurement=true;
			}
			dispatchEvent(new PyroEvent(PyroEvent.SIZE_INVALIDATED));	
			invalidateDisplayList()
		}
			
		/**
		 * Overrides the set measuredHeight property from 
		 * <code>MeasurableControl</code> to invalidate children
		 * (UIControl acknowledges that it can have children whose
		 * dimensions are based on its own)
		 */
		override public function set measuredHeight(h:Number):void{
			if(h == _measuredHeight) return;
			this._dimensionsChanged = true;
			_measuredHeight = h;
			for(var i:uint=0; i<this.numChildren; i++){
				var child:UIControl = this.getChildAt(i) as UIControl;
				if(!child) continue;
				child.needsMeasurement=true;
			}
			dispatchEvent(new PyroEvent(PyroEvent.SIZE_INVALIDATED));	
			invalidateDisplayList()
		}
		
		/**
		 * When measure is called, it uses the widthForMeasurement and 
		 * heightForMeasurement to calculate the sizes for 
		 * percent-dimension based children
		 */
		public function widthForMeasurement():Number{
			return this.width
		}
		
		/**
		 * When measure is called, it uses the widthForMeasurement and 
		 * heightForMeasurement to calculate the sizes for 
		 * percent-dimension based children
		 */
		public function heightForMeasurement():Number{
			return this.height
		}
		
		/**
		 * @inhertiDoc
		 */ 
		override public function removeChild(d:DisplayObject):DisplayObject{
			
			var d2:DisplayObject = super.removeChild(d);
			this.invalidateSize()
			return d2;
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			//$width = unscaledWidth
			//$height = unscaledHeight;
			if(this._backgroundPainter){
				this.graphics.clear()
				_backgroundPainter.draw(Sprite(this).graphics, unscaledWidth,unscaledHeight);
			}
			if(_skin && !(_skin is MeasurableControl) && (_skin is DisplayObject)){
				DisplayObject(_skin).width = unscaledWidth;
				DisplayObject(_skin).height = unscaledHeight;
			}
			doLayoutChildren()
		}
		
		public function doLayoutChildren():void
		{
			for(var i:uint=0; i<this.numChildren; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				// Skin elements do not get positioned. Its upto the
				// skin to deal with the padding
				if(child == _skin) continue;
				
				//child.x = padding.left;
				//child.y = padding.top;
			}
		}
		/////////////// Painters Implementation //////////////
		
		protected var _backgroundPainter:IPainter;
		
		/**
		 * UIControls can have a backgroundPainter object attached that is 
		 * triggered everytime updateDisplayList is called. 
		 * 
		 * @see org.openPyro.painters
		 */
		public function get backgroundPainter():IPainter
		{
			return _backgroundPainter;
		}
		
		/**
		 * @private
		 */ 
		public function set backgroundPainter(painter:IPainter):void{
			this._backgroundPainter = painter;
			this.invalidateDisplayList();
		}
		
		public function removeBackgroundPainter():void{
			this._backgroundPainter = null;
			this.invalidateDisplayList();
		}
		
		///////////////////// Skinning implementation ////////////
		
		protected var _styleName:String
		
		/**
		 * Defines the skin this component is registered to.
		 * As long as a skin is registered with the same 
		 * name as this value, this control will get that
		 * skin when instantiated or when that definition
		 * changes.
		 * 
		 * @see org.openPyro.managers.SkinManager
		 */ 
		public function get styleName():String
		{
			return _styleName;
		}
		
		/**
		 * @private
		 */ 
		public function set styleName(selector:String):void
		{
			if(_styleName == selector) return;	
			if(initialized){
				SkinManager.getInstance().unregisterSkinClient(this,_styleName);
				SkinManager.getInstance().registerSkinClient(this, selector)
			}
			this._styleName = selector;
		}
		
		public function dispose():void{}
		
		protected var _skinnedControl:UIControl;
		
		public function set skinnedControl(uic:UIControl):void
		{
			if(_skinnedControl){
				_skinnedControl.removeEventListener(Event.RESIZE, onSkinnedControlResize)
			}
			_skinnedControl = uic;
			_skinnedControl.addEventListener(Event.RESIZE, onSkinnedControlResize)
		}
		
		public function get skinnedControl():UIControl
		{
			return _skinnedControl;
		}
		
		/**
		 * Event handler for when the UIControl is applied as a Skin
		 * and the control it is skinning is resized.
		 * 
		 * @see org.openPyro.skins
		 */ 
		protected function onSkinnedControlResize(event:Event):void
		{
			this.width = _skinnedControl.width;
			this.height = _skinnedControl.height;
		}
		
		protected var _skin:ISkin;
		
		public function set skin(skinImpl:ISkin):void{
			if(!skinImpl) return;
			
			if(this._skin)
			{
				_skin.dispose();
				_skin = null;
			}
			_skin = skinImpl;
			_skin.skinnedControl = this;
			if(_skin is UIControl){
				addChild(UIControl(_skin))
				//UIControl(_skin).percentUnusedWidth = 100
				//UIControl(_skin).percentUnusedHeight = 100
			}
		}
		
		///////// handle drag /////
		
		protected var _dragEnabled:Boolean = false;
		
		public function get dragEnabled():Boolean{
			return _dragEnabled;
		}
		
		public function set dragEnabled(b:Boolean):void{
			_dragEnabled = b
			if(_dragEnabled){
				this.addEventListener(MouseEvent.MOUSE_DOWN, handlePreDragMouseDown);
			}
			else{
				this.removeEventListener(MouseEvent.MOUSE_DOWN, handlePreDragMouseDown);
			}
		}
		
		protected var _dropEnabled:Boolean = false;
		public function set dropEnabled(b:Boolean):void{
			_dropEnabled = b;
			if(_dropEnabled){
				DragManager.registerDropClient(this);
			}
			else{
				DragManager.removeDropClient(this);
			}
		}
		
		protected var isMouseDown:Boolean = false;
		
		public var dragData:Object = {source:this};
		
		/**
		 * This function is called if the UIControl instance is drag enabled
		 * and the user clicks the mouse down. The control then waits for the
		 * mouse to move for dispatching the DragEvent.DRAG_START event. That 
		 * event can be used to trigger DragManager's doDrag() function to 
		 * implement Drag And Drop
		 */ 
		protected function handlePreDragMouseDown(event:Event):void{
			isMouseDown = true;
			DragManager.doDrag(this, dragData, null, true);
			//this.addEventListener(MouseEvent.MOUSE_MOVE, dispatchDragStart);
		}
		
		protected function dispatchDragStart(event:MouseEvent):void{
			dispatchEvent(new DragEvent(DragEvent.DRAG_START));
			this.removeEventListener(MouseEvent.MOUSE_MOVE, dispatchDragStart);
		}
		
		////////////////////// ToolTip //////////////////////////
		
		protected var _toolTipData:*;
		protected var toolTipRenderer:Class;
	
		public function set toolTip(data:*):void{
			_toolTipData = data;
			if(_toolTipData){
				this.addEventListener(MouseEvent.MOUSE_OVER, 
										function(event:MouseEvent):void{
											TooltipManager.getInstance().showToolTip(event, _toolTipData, toolTipRenderer)
										})
				
				this.addEventListener(MouseEvent.MOUSE_OUT, 
				function(event:MouseEvent):void{
					TooltipManager.getInstance().hideToolTip()
				})
			}
		}
		
		///////////////////// Padding //////////////////////////////
		
		protected var _padding:Padding = new Padding();
		
		/**
		 * Paddings define the unusable space within
		 * UIContainers that should not be used for
		 * measurement and layout. Similar to 
		 * HTML/CSS padding
		 */ 
		public function get padding():Padding
		{
			return _padding;
		}
		
		/*override public function setActualSize(w:Number,h:Number):void
		{
			this._explicitWidth = w;
			this._explicitHeight = h;
			for(var i:uint=0; i<this.numChildren; i++){
				var uic:UIControl = this.getChildAt(i) as UIControl
				if(!uic) continue
				uic.validateSize();
				uic.validateDisplayList();
			}
			this.updateDisplayList(this.getExplicitOrMeasuredWidth(), this.getExplicitOrMeasuredHeight());
		}*/
		
		
		/**
		 * @private
		 */ 
		public function set padding(p:Padding):void
		{
			if(_padding == p) return;
			_padding = p;
			if(!initialized) return;
			this.invalidateSize();
		}
	
		
		//////////////////// End Skinning Implementation ///////////
		
		/**
		 * Convinience function for setting width and height
		 * in one call. The parameters can either be Strings
		 * or Numbers. When passing strings, you can append
		 * a '%' character at the end of the string to set a 
		 * percent value
		 * 
		 * @param	w	Width either as a Number or as a String 
		 * 				ending with a % character
		 * @param	h	Height either as a Number or as a String 
		 * 				ending with a % character
		 * 
		 * @throws	Error if the datatype passed in is not a Number 
		 * 			or String
		 */ 
		public function size(w:*, h:*):UIControl{
			var str:String
			if(w is Number){
				this.width = w
			}
			else if(w is String){
				str = String(w)
				if(str.charAt(str.length-1)== "%"){
					str = str.substring(0, str.length-1)
					this.percentUnusedWidth = Number(str);
				}
			}
			
			else{
				throw new Error('SetSize can only take a string or number as a param')
			}
			
			if(h is Number){
				this.height = h
			}
			else if(h is String){
				str = String(h)
				if(str.charAt(str.length-1)== "%"){
					str = str.substring(0, str.length-1)
					this.percentUnusedHeight = Number(str);
				}
			}
			
			else{
				throw new Error('SetSize can only take a string or number as a param')
			}
			return this;
		}
		
		public function position(x:Number, y:Number):UIControl{
			this.x = x;
			this.y = y;
			return this;
		}
		
	}
}