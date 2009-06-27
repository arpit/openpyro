package org.openPyro.core{
	import org.openPyro.events.PyroEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	[Event(name="preInitialize", type="org.openPyro.events.PyroEvent")]
	[Event(name="initialize", type="org.openPyro.events.PyroEvent")]
	[Event(name="sizeInvalidated", type="org.openPyro.events.PyroEvent")]
	[Event(name="sizeValidated", type="org.openPyro.events.PyroEvent")]
	[Event(name="sizeChanged", type="org.openPyro.events.PyroEvent")]
	[Event(name="updateComplete", type="org.openPyro.events.PyroEvent")]
	
	[Event(name="propertyChange", type="org.openPyro.events.PyroEvent")]
	[Event(name="resize", type="flash.events.Event")]
	
	
	/**
	 * The Measurable control is the basic class that
	 * participates in Pyro's measurement strategy. Measurable controls understand
	 * a variety of properties like explicit height/width which is set if you set the
	 * width or height property with an actual neumerical value, or percentUnusedWidth
	 * and percentUnusedHeight which are set if the control's size is based on
	 * measurement of the parent control. Controls can also be sized using the 
	 * percentWidth or percentHeight which is based on the parent's size without taking
	 * the other children in the parent under consideration.
	 * 
	 * Note: As of right now percentWidth and percentHeight may not be respected
	 * by certain containers like DividedBoxes
	 */ 
	public class MeasurableControl extends Sprite{
		
		public function MeasurableControl(){
			this.addEventListener(Event.ADDED, onAddedToParent);
			super.visible = false;
		}
		
		/**
		 * The event listener executed when this component 
		 * has been added to the parent.
		 */ 
		protected function onAddedToParent(event:Event):void{
			if(!this.parent) return;
			this.removeEventListener(Event.ADDED, onAddedToParent);
			this.addEventListener(Event.REMOVED, onRemovedFromParent,false,0,true);
			this._parentContainer = this.parent as UIControl;
			if(!_parentContainer)
			{
				doOnAdded();
			}
		}
		
		/**
		 * Property indicates whether a control has been initialized 
		 * or not. Initialization happens the first time the control
		 * is added to the parent.
		 */ 
		public var initialized:Boolean = false;
		
		/**
		 * This happens only once when a child is
		 * first added to any parent. Subsequent 
		 * removeChild and addChild actions do not
		 * trigger this function but rather directly call 
		 * validateSize.
		 */ 
		public function initialize():void
		{
			dispatchEvent(new PyroEvent(PyroEvent.PREINITIALIZE))
			createChildren();
			dispatchEvent(new PyroEvent(PyroEvent.INITIALIZE));
			initialized = true;
			this.validateSize();
		}
		
		/**
		 * This is where the new children should
		 * be created and then added to the displaylist.
		 * Similar to Flex's createChildren() method.
		 */ 
		protected function createChildren():void{}
		
		protected var _explicitWidth:Number = NaN;
		protected var _explicitHeight:Number = NaN;
		
		/**
		 * The width set in terms of actual pixels.
		 * You do not call this function in your code.
		 * Setting the width of the control to an actual
		 * numeric value (rather than percent) calls this
		 * function
		 * Call this function only if you want to set
		 * width without calling the invalidation methods 
		 * 
		 * [TODO] This class should 
		 * have namespace access control (pyro_internal)
		 */ 
		public function set explicitWidth(w:Number):void{
			_explicitWidth = w;	
		}
		
		/** The height set in terms of actual pixels.
		 * You do not call this function in your code.
		 * Setting the width of the control to an actual
		 * numeric value (rather than percent) calls this
		 * function
		 * Call this function only if you want to set
		 * width without calling the invalidation methods 
		 * 
		 * [TODO] This class should 
		 * have namespace access control (pyro_internal)
		 */ 
		public function get explicitWidth():Number{
			return _explicitWidth;	
		}
		
		/**
		 * @private
		 */ 
		public function set explicitHeight(h:Number):void{
			_explicitHeight = h;	
		}
		
		/**
		 * @private
		 */ 
		public function get explicitHeight():Number{
			return this._explicitHeight;	
		}
		
		/**
		 * Set/get the width of the control. If the width
		 * is set to a different value from the one the 
		 * control is already at, it triggers the size 
		 * invalidation cycle
		 */ 
		override public function set width(n:Number):void{
			if(n == _explicitWidth) return;
			this._explicitWidth = n
			_dimensionsChanged = true;
			displayListInvalidated = true;
			if(!initialized) return;
			invalidateSize();
		}
		
		/**
		 * @private 
		 */ 
		override public function get width():Number{
			return this.getExplicitOrMeasuredWidth()
		}
		
		/**
		 * Set/get the height of the control. If the height
		 * is set to a different value from the one the 
		 * control is already at, it triggers the size 
		 * invalidation cycle
		 */ 
		override public function set height(n:Number):void{
			if (n == _explicitHeight) return;
			this._explicitHeight = n
			displayListInvalidated = true;
			_dimensionsChanged=true;	
			if(!initialized) return;
			invalidateSize();
			//invalidateDisplayList();
		}
		
		/**
		 * @private
		 */ 
		override public function get height():Number{
			return this.getExplicitOrMeasuredHeight();
		}
		
		protected var _maximumWidth:Number = NaN;
		public function set maximumWidth(n:Number):void{
			_maximumWidth = n;
			invalidateSize();
		}
		
		public function get maximumWidth():Number{
			return _maximumWidth;
		}
		
		/*protected var _minimumHeight:Number = NaN;
		public function set minimumHeight(n:Number):void{
			_minimumHeight = n;
			invalidateSize();
		}
		
		public function get minimumHeight():Number{
			return _minimumHeight;
		}*/
		
		protected var _maximumHeight:Number = NaN;
		public function set maximumHeight(n:Number):void{
			_maximumHeight = n;
			invalidateSize();
		}
		
		public function get maximumHeight():Number{
			return _maximumHeight;
		}
		
		
		protected var _percentUnusedWidth:Number;
		protected var _percentUnusedHeight:Number;
		
		/** 
		 * Only setting percent width/heights changes the 
		 * needsMeasurement flag which makes its parent 
		 * container call measure on it.
		 * If width and height are set directly, measurement 
		 * is never called (although size invalidation 
		 * still does if size has changed)
		 */ 
		public var needsMeasurement:Boolean=true;
		
		/**
		 * Set/get the percent width. If the value is 
		 * different from the earlier, it sets the measurement 
		 * flag and calls invalidateSize
		 */ 
		public function set percentUnusedWidth(w:Number):void{
			if(w == _percentUnusedWidth) return;
			_percentUnusedWidth = w;
			if(!initialized) return;
			invalidateSize()
		}
		
		/**
		 * @private
		 */ 
		public function get percentUnusedWidth():Number{
			return _percentUnusedWidth;
		}
		
		/**
		 * Set/get the percent height. If the value is 
		 * different from the earlier, it sets the measurement 
		 * flag and calls invalidateSize
		 */ 
		public function set percentUnusedHeight(h:Number):void{
			if(h==_percentUnusedHeight) return;
			//needsMeasurement = true;
			_percentUnusedHeight = h;
			if(!initialized) return;
			this.invalidateSize()
		}
		
		protected var _percentWidth:Number
		public function set percentWidth(w:Number):void
		{
			if(w==_percentWidth) return;
			_percentWidth = w;
			if(!initialized) return;
			this.invalidateSize()
		}
		
		public function get percentWidth():Number
		{
			return _percentWidth
		}
		
		protected var _percentHeight:Number
		public function set percentHeight(h:Number):void
		{
			if(h==_percentHeight) return;
			_percentHeight = h;
			if(!initialized) return;
			this.invalidateSize()
		}
		
		public function get percentHeight():Number
		{
			return _percentHeight;
		}
		
		/**
		 * @private
		 */ 
		public function get percentUnusedHeight():Number{
			return _percentUnusedHeight;
		}
		
		protected var _parentContainer:UIControl;
		
		public function set parentContainer(c:UIControl):void{
			this._parentContainer = c;
		}
		
		public function get parentContainer():UIControl
		{
			return _parentContainer;
		}
		
		/**
		 * The flag to mark that the control's size
		 * has been invalidated. This means the control
		 * is now waiting for a validateSize call.
		 */ 
		public var sizeInvalidated:Boolean=false;
		
		/**
		 * Marks itself dirty and waits till either the container 
		 * to validateSize or validates itself at the next enterframe 
		 * if it has no parent container.
		 * 
		 * This method is overridden by UIControl. The code here 
		 * will only be useful for a Spacer type of component. 
		 */ 
		public function invalidateSize(event:PyroEvent=null):void{
			if(sizeInvalidated) return;
			sizeInvalidated=true;
			dispatchEvent(new PyroEvent(PyroEvent.SIZE_INVALIDATED));
			if(!this._parentContainer){
				/*
				 * If this is not contained in a OpenPyro control,
				 * take the responsibility for validating the 
				 * displaylist
				 */ 
				this.addEventListener(Event.ENTER_FRAME, doQueuedValidateSize);
			}
			
		}
		
		/**
		 * doQueueValidateSize is executed by the top level UIControl.
		 */ 
		protected function doQueuedValidateSize(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, doQueuedValidateSize);
			this.validateSize();	
		}
		
		/**
		 * This property defines whether measure() will be called during 
		 * validateSize() or not. 
		 */ 
		public function get usesMeasurementStrategy():Boolean{
			if(isNaN(this._explicitHeight) || isNaN(this._explicitWidth)){
				return true;
			}
			else{
				return false;
			}
		}
		
		/**
		 * The validateSize function is called in response to 
		 * a component declaring its size invalid (usually
		 * by calling invalidateSize()). The job of this 
		 * method is to compute the final width and height 
		 * (whether by calling measure if an explicit w/h
		 * is not declared or not if an explicit w & h is 
		 * declared)
		 * 
		 * @see invalidateSize()
		 * @see measure()
		 * @see usesMeasurementStrategy
		 */ 
		public function validateSize():void{
			if(usesMeasurementStrategy){
				measure();
				checkDisplayListValidation()
				sizeInvalidated=false;
			}	
			else{
				sizeInvalidated=false;
				if(displayListInvalidated){
					queueValidateDisplayList();
				}
			}
			for(var j:uint=0; j<this.numChildren; j++){
				var child:MeasurableControl = this.getChildAt(j) as MeasurableControl;
				if(!child) continue;
				child.validateSize()
				//child.dispatchEvent(new PyroEvent(PyroEvent.SIZE_VALIDATED));	
			}
			dispatchEvent(new PyroEvent(PyroEvent.SIZE_VALIDATED));	
		}
		
		/**
		 * [Temp] This function is called automatically 
		 * by a parent UIControl if this is created as a 
		 * child of a UIControl. Else you have to call 
		 * this function for now. 
		 */ 
		public function doOnAdded():void
		{	
			if(!initialized){
				this.initialize();
				initialized = true;
			}
			else
			{
				validateSize();
			}
			
			if(!(this.parent is UIControl)) {
				if(displayListInvalidated){
					queueValidateDisplayList();
				}
			}
			else{
				
				if(this.sizeInvalidated){
					_parentContainer.invalidateSize();
				}
			}
		}
		
		protected var _measuredWidth:Number=NaN;
		protected var _measuredHeight:Number=NaN;
		
		protected var _dimensionsChanged:Boolean=true;
		
		/**
		 * Measure is called during the validateSize if
		 * the needsmeasurement flag is set. 
		 * At this point, new measured width/heights are 
		 * calculated. If these values are different from
		 * the values previously calculated, the 
		 * resizeHandler is queued for the next enterframe
		 * 
		 */ 
		public function measure():void{
			if(isNaN(this._explicitWidth))
			{
				calculateMeasuredWidth()
			}
			if(isNaN(this._explicitHeight))
			{
				calculateMeasuredHeight();
			}
			this.needsMeasurement=false;
		}
		
		/**
		 * Calculates the measuredWidth property.
		 */ 
		 protected function calculateMeasuredWidth():void
		{
			var computedWidth:Number;
			if(!isNaN(this._percentUnusedWidth) && this._parentContainer)
			{
				computedWidth = this._parentContainer.widthForMeasurement()*this._percentUnusedWidth/100;
			}
			else if(!isNaN(this._percentWidth) && this._parentContainer)
			{
				computedWidth = this._parentContainer.width*this._percentWidth/100;
			}
			if(!isNaN(_maximumWidth)){
				computedWidth = Math.min(_maximumWidth, computedWidth);
			}
			measuredWidth = computedWidth;
		}
		
		/**
		 * Calculates the measuredHeight property.
		 */ 
		protected function calculateMeasuredHeight():void
		{
			var computedHeight:Number;
			if(!isNaN(this._percentUnusedHeight) && this._parentContainer)
			{
				
				computedHeight = this._parentContainer.heightForMeasurement()*this._percentUnusedHeight/100;	
			}
			else if(!isNaN(this._percentHeight) && this._parentContainer)
			{
				computedHeight = this._parentContainer.height*this._percentHeight/100;
			}
			if(!isNaN(_maximumHeight)){
				computedHeight = Math.min(_maximumHeight, computedHeight);
			}
			this.measuredHeight = computedHeight;
		}
		
		/**
		 * Set the measured height of the control. This is
		 * usually set by the same control's measure()
		 * function. If the measuredHeight is changed, 
		 * the displayList is invalidated
		 */ 
		public function set measuredHeight(h:Number):void{
			if(h == _measuredHeight) return;
			_measuredHeight = h;
			displayListInvalidated = true;
			_dimensionsChanged = true;
		}
		
		
		
		/**
		 * @private
		 */ 
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		
		/**
		 * Returns the measured width after the control has been
		 * measured. Note this value will return NaN if the control
		 * is explicitly sized by setting the explicitWidth property
		 */ 
		public function set measuredWidth(w:Number):void{
			if(w  == _measuredWidth) return;
			_measuredWidth = w;
			displayListInvalidated = true;
			_dimensionsChanged = true
		}
		
		/**
		 * @private
		 */ 
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}
		
		/**
		 * Flag to mark a dirty displaylist. It basically means it is
		 * waiting for a call to updateDisplayList at some point
		 */ 
		public var displayListInvalidated:Boolean=true;
		
		public var forceInvalidateDisplayList:Boolean=false;
		
		protected function invalidateDisplayList():void{
			if(!initialized) return;
			if((!this.sizeInvalidated && !displayListInvalidated) || forceInvalidateDisplayList){
				forceInvalidateDisplayList=false;
				displayListInvalidated=true;
				queueValidateDisplayList();
				
			}
		}
		
		/**
		 * Calls the queueValidateDisplayList if measure causes
		 * _dimensionsChanged to change to true.
		 * 
		 * UIControl overrides this with a call to doChildBasedValidation 
		 * which then goes and checks if the size of the children 
		 * affects the size of the control.
		 */ 
		public function checkDisplayListValidation():void{
			if(_dimensionsChanged){
				queueValidateDisplayList()
			}	
		}
		
		/**
		 * This function is called if the framework determines that dimensions of the 
		 * control have changed. This determination is made during the validateSize() function.
		 * 
		 * If this control is the top level OpenPyro control, it will validate the displaylist
		 * in the next enter frame, otherwise it just dispatches the size changed event
		 * and waits till the validateDisplaylist is called.
		 */ 
		public function queueValidateDisplayList(event:PyroEvent=null):void{
			
			if(this._parentContainer && _dimensionsChanged){
				dispatchEvent(new PyroEvent(PyroEvent.SIZE_CHANGED));
			}else{
				if(this.stage){
					stage.invalidate();
					this.addEventListener(Event.RENDER, validateDisplayList);
				}
				
			}
		}
		
		/**
		 * validateDisplayList is called as a response to invalidateDisplayList.
		 */ 
		public function validateDisplayList(event:Event=null):void{
			
			if(isNaN(this.getExplicitOrMeasuredWidth()) || isNaN(this.getExplicitOrMeasuredHeight())){
				return;
			}
			if(event){
				this.removeEventListener(Event.RENDER,validateDisplayList) 
			}
			for(var j:uint=0; j<this.numChildren; j++){
				var child:MeasurableControl = this.getChildAt(j) as MeasurableControl;
				if(!child) continue;
				child.validateDisplayList()
			}
			this.updateDisplayList(this.getExplicitOrMeasuredWidth(), this.getExplicitOrMeasuredHeight());
			if(_dimensionsChanged){
				_dimensionsChanged = false;
				resizeHandler();
			}
			this.displayListInvalidated=false
			dispatchUpdateComplete();
			
		}
		
		/*
		TODO:
		protected var _unscaledWidth:Number = NaN;
		protected var _unscaledHeight:Number = NaN;
		
		public function setActualSize(w:Number, h:Number):void
		{
			_unscaledWidth = w;
			_unscaledHeight = h;
			this.validateSize()
			this.validateDisplayList()
		}
		*/
		
		
		protected var _creationCompleteFired:Boolean = false;
		
		public function get creationCompleteFired():Boolean{
			return _creationCompleteFired;
		}
		
		/**
		 * Dispatches the UpdateComplete event
		 */ 
		protected function dispatchUpdateComplete():void{
			dispatchEvent(new PyroEvent(PyroEvent.UPDATE_COMPLETE));
			if(!_creationCompleteFired){
				if(this._isVisible){
					this.visible = true;
				}
				dispatchEvent(new PyroEvent(PyroEvent.CREATION_COMPLETE));
				_creationCompleteFired = true;
			}
		}
		
		/**
		 * @private
		 */ 
		protected var _isVisible:Boolean = true;
		
		/**
		 * @inheritDoc
		 */ 
		override public function set visible(value:Boolean):void{
			this._isVisible = value;
			super.visible =value
		}
		
		public function resizeHandler():void{
			//trace('resize');
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		 * The updateDisplayList is triggered everytime the framework
		 * determines that some event has taken place that needs the
		 * UI to be refreshed.
		 * 
		 * @param unscaledWidth		The computed width of the control
		 * @param unscaledHeight	The computed height of the control
		 */ 
		public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			// stub. This is overridden in later controls
		}
		
		/**
		 * Returns the explicitly defined width or the measured
		 * number computed by the <code>measure</code> function.
		 * 
		 */ 
		public function getExplicitOrMeasuredWidth():Number{
			if(!isNaN(this._explicitWidth)){
				return _explicitWidth	
			}
			else{
				return _measuredWidth
			}
		}
		
		/**
		 * Returns the explicitly defined height or the measured
		 * height computed by the <code>measure</code> function.
		 */ 
		public function getExplicitOrMeasuredHeight():Number{
			if(!isNaN(this._explicitHeight)){
				return _explicitHeight	
			}
			else{
				return _measuredHeight
			}
		}
		
		private function onRemovedFromParent(event:Event):void{
			this.addEventListener(Event.ADDED, onAddedToParent);
		}
		
		
		///////// Utils ///////////
		
		public function cancelMouseEvents():void{
			this.addEventListener(MouseEvent.MOUSE_OVER, disableEvent, true, 1,true);
			this.addEventListener(MouseEvent.MOUSE_DOWN, disableEvent, true, 1,true);
			this.addEventListener(MouseEvent.MOUSE_OUT, disableEvent, true, 1,true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, disableEvent, true, 1,true);
			//this.addEventListener(MouseEvent.MOUSE_UP, disableEvent, true, 1,true);
			this.addEventListener(MouseEvent.CLICK, disableEvent, true, 1,true);
			_mouseActionsDisabled = true
			
		}	
		
		public function enableMouseEvents():void{
			//this.removeEventListener(MouseEvent.MOUSE_UP, disableEvent,true);
			this.removeEventListener(MouseEvent.MOUSE_OVER, disableEvent,true);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, disableEvent,true);
			this.removeEventListener(MouseEvent.MOUSE_OUT, disableEvent,true);
			this.removeEventListener(MouseEvent.CLICK, disableEvent,true);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, disableEvent,true);
			_mouseActionsDisabled = false;
		}
		
		protected function disableEvent(event:Event):void{
			event.stopImmediatePropagation()
			event.preventDefault()
		}
		
		protected var _mouseActionsDisabled:Boolean = false;
		public function get mouseActionsDisabled():Boolean{
			return _mouseActionsDisabled;
		}
		
		/**
		 * Utility function to check if a mouseEvent happened
		 * while the mouse was over the displayObject
		 */
		 public function isMouseOver(event:MouseEvent):Boolean{
		 	if(event.localX < this.width && event.localX > 0 && 
			event.localY < this.height && event.localY > 0){
				return true
			}
			else{
				return false
			}
		 } 
		
		
		/**
		 * @private
		 * Since the addChild function is overridden in all MeasurableControls,
		 * this function is defined to keep the native implementation available
		 */ 
		public final function $addChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
		/**
		 * @private
		 * Since the addChild function is overridden in all MeasurableControls,
		 * this function is defined to keep the native implementation available
		 */ 
		public final function $addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child,index);
		}
		
		private var _includeInLayout:Boolean = true
		
		/**
		 * @private
		 */ 
		public function set includeInLayout(value:Boolean):void{
			_includeInLayout = value
		}
		
		/**
		 * Specifies whether this control participates in the 
		 * layout system in OpenPyro. For example if you have 3
		 * <code>UIControls</code> sitting in a container with a 
		 * <code>HLayout</code> layout, but the second control as the
		 * includeInLayout property set to false, the layout will
		 * not position that control.
		 */ 
		public function get includeInLayout():Boolean{
			return _includeInLayout;
		}
		
		/**
		 * @private
		 */ 
		public final function get $width():Number
		{
			return super.width
		}
		
		/**
		 * @private
		 */ 
		final public function set $width(w:Number):void
		{
			super.width = w;
		}
		
		/**
		 * @private
		 */ 
		final public function get $height():Number
		{
			return super.height
		}
		
		/**
		 * @private
		 */ 
		final public function set $height(h:Number):void
		{
			super.height = h;
		}
		
	}
}