package org.openPyro.controls
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.openPyro.core.UIControl;

	/**
	 * Complete event is dispatched when the image load
	 * is completed.
	 */ 
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * The Image control is used to display images that 
	 * are loaded from a remote URL. Unlike the Flex 
	 * equivalent, OpenPyro Images cannot be used to 
	 * render embedded content.
	 */ 
	public class Image extends UIControl
	{
		private var _sourceURL:String = "";
		private var _loader:Loader;
		
		public function Image() {
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addChild(_loader);
			_loader.visible = false;
			if(!_loaderContext)
			{
				_loaderContext = new LoaderContext(true);
			}
			
			if(_autoLoad && (_sourceURL != "")){
				_loader.load(new URLRequest(_sourceURL), _loaderContext);	
			}
		}
		
		protected var _autoLoad:Boolean = true;
		public function set autoLoad(b:Boolean):void
		{
			_autoLoad = b;	
		}
		
		public function get autoLoad():Boolean
		{
			return _autoLoad;
		}
		
		protected var _isContentLoaded:Boolean = false;
		
		/**
		 * Flag to check if the remote content is loaded 
		 * or not.
		 */ 
		public function isContentLoaded():Boolean{
			return _isContentLoaded;
		}
		
		public function set source(url:String):void
		{
			if(url == _sourceURL) return;
			_sourceURL = url;
			if(_loader && _autoLoad){
				_isContentLoaded = false;
				_loader.load(new URLRequest(url), _loaderContext);
			}
		}
		
		private var _loaderContext:LoaderContext
		
		/**
		 * The LoaderContext that is used when loading an 
		 * image.
		 */ 
		public function set loaderContext(context:LoaderContext):void
		{
			_loaderContext = context;
		}
		
		/**
		 * @private
		 */ 
		public function get loaderContext():LoaderContext
		{
			return _loaderContext;
		}
		
		/**
		 * Returns the raw loader being used to load the image
		 */ 
		public function get loader():Loader
		{
			return _loader;
		}
		
		protected var _originalContentWidth:Number = NaN;
		protected var _originalContentHeight:Number = NaN;
		
		protected function onLoadComplete(event:Event):void
		{
			_originalContentWidth = _loader.content.width;
			_originalContentHeight = _loader.content.height;
			_isContentLoaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
			forceInvalidateDisplayList = true;
			invalidateSize();
			invalidateDisplayList()
		}
		override protected function doChildBasedValidation():void{
			if(!_loader ||  !_loader.content) return;
			if(isNaN(this._explicitWidth) && isNaN(this._percentWidth) && isNaN(_percentUnusedWidth)){
				measuredWidth = _originalContentWidth + _padding.left + _padding.right;
			}
			if(isNaN(this._explicitHeight) && isNaN(this._percentHeight) && isNaN(_percentUnusedHeight))
			{
				measuredHeight = _originalContentWidth + _padding.top + _padding.bottom;
			}
		}
		
		public function get contentWidth():Number{
			return _loader.content.width;
		}
		
		public function get contentHeight():Number{
			return _loader.content.height;
		}
		
		public function get originalContentWidth():Number{
			return _originalContentWidth
		}
		
		public function get originalContentHeight():Number{
			return _originalContentHeight;
		}
		
		
		protected function onIOError(event:IOErrorEvent):void
		{
			//todo: Put broken thumb skin here//
		}
		
		protected var _scaleToFit:Boolean = true;
		public function get scaleToFit():Boolean
		{
			return _scaleToFit;
		}
		
		public function set scaleToFit(value:Boolean):void
		{
			_scaleToFit = value;
			if(_scaleToFit && _loader && _loader.content)
			{
				scaleImageContent()
			}
		}
		
		
		
		protected var _maintainAspectRatio:Boolean = true;
		public function set maintainAspectRatio(value:Boolean):void
		{
			_maintainAspectRatio = value;
		}
		public function get maintainAspectRatio():Boolean
		{
			return _maintainAspectRatio;
		}
		
		protected function scaleImageContent():void
		{
		
			var scaleX:Number;
			var scaleY:Number;	
			scaleX = width / _originalContentWidth;
			scaleY = height / _originalContentHeight;
			
			if(_maintainAspectRatio)
			{
				var scale:Number = Math.min(scaleX, scaleY);
				_loader.content.width = _originalContentWidth*scale;
				_loader.content.height = _originalContentHeight*scale;	
			}
			else
			{
				_loader.content.width = _originalContentWidth*scaleX;
				_loader.content.height = _originalContentHeight*scaleY;
			}
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(_loader && _loader.content){
				_loader.visible = true;
				if(_scaleToFit){
					scaleImageContent();
				}
			}
			_loader.x = _padding.left
			_loader.y = _padding.top;
		}
		
	}
}