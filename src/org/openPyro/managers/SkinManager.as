package org.openPyro.managers{
	import org.openPyro.core.ClassFactory;
	import org.openPyro.skins.FlaSymbolSkin;
	import org.openPyro.skins.ISkin;
	import org.openPyro.skins.ISkinClient;
	import org.openPyro.utils.ArrayUtil;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class SkinManager extends EventDispatcher{
		
		public static const SKIN_SWF_LOADED:String = "skinSWFLoaded"
		
		private var skinClients:Dictionary
		private var skinDefinitions:Dictionary;
		
		public function SkinManager(){
			skinClients = new Dictionary()
			skinDefinitions = new Dictionary();
		}
		
		private static var instance:SkinManager
		public static function getInstance():SkinManager
		{
			if(!instance)
			{
				instance = new SkinManager()
			}
			return instance;
		}
		
		public function registerSkinClient(client:ISkinClient, selector:String):void
		{
			if(skinClients.hasOwnProperty(selector))
			{
				var skinnable:Array = skinClients[selector]
				skinnable.push(client);
			}
			else
			{
				skinClients[selector] = [client]
			}
				
		}
		
		public function unregisterSkinClient(client:ISkinClient, selector:String):void
		{
			if(!skinClients.hasOwnProperty(selector)) return;
			var skinnable:Array = skinClients[selector]
			ArrayUtil.remove(skinnable, client);
		}
		
		
		
		public function getSkinForStyleName(styleName:String):ISkin
		{
			var skinFactory:ClassFactory =  ClassFactory(this.skinDefinitions[styleName])
			if(!skinFactory) return null;
			var skin:ISkin =skinFactory.newInstance() as ISkin;
			return skin;
		}
		
		
		
		private var timer:Timer;
		private var invalidSelectors:Array = [];
		
		public function registerSkin(skinFactory:ClassFactory, selector:String):void
		{
			if(skinDefinitions[selector] == skinFactory) return;
			this.skinDefinitions[selector] = skinFactory;
			invalidSelectors.push(selector);
			/* 
			[TODO:] This needs to happen on the next EnterFrame, not Timer
			*/
			invalidateSkins()
		}
		
		public function registerFlaSkin(skin:Class, selector:String):void
		{
			var flaSkinFactory:ClassFactory = new ClassFactory(FlaSymbolSkin);
			flaSkinFactory.properties = {movieClipClass:skin};
			registerSkin(flaSkinFactory, selector);
		}
		
		public function invalidateSkins():void
		{
			if(! timer){
				timer = new Timer(500, 1)
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, validateSkins);
			}
			if(!timer.running){
				timer.start()
			}	
		}
		
		public function validateSkins(event:TimerEvent):void
		{
			for each(var a:String in this.invalidSelectors)
			{ 
				var skinnable:Array = skinClients[a] as Array;
				var skinFactory:ClassFactory = this.skinDefinitions[a];
				
				if(!skinnable || !skinFactory) continue;
				for(var i:uint=0; i<skinnable.length; i++)
				{
					var client:ISkinClient = ISkinClient(skinnable[i])
					client.skin = ISkin(skinFactory.newInstance());
					
				}
			}
			this.invalidSelectors = new Array();	
		}
		
		public function loadSkinSwf(swfURL:String):void{
			var loader:Loader = new Loader()
			loader.contentLoaderInfo.addEventListener(Event.INIT, onSkinSWFLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError)
			loader.load(new URLRequest(swfURL), new LoaderContext(true, ApplicationDomain.currentDomain))
		}
		
		private function onIOError(event:Event):void{
			
		}
		
		
		private function onSkinSWFLoaded(event:Event):void{
			LoaderInfo(event.target).removeEventListener(Event.INIT, onSkinSWFLoaded)
			Object(LoaderInfo(event.target).loader.content).getDefinitions(this)
			
			/*
			for(var a:String in this.skinClients){
				var classDefinition:Class
				try{
					classDefinition = ApplicationDomain.currentDomain.getDefinition(a) as Class;	
				}catch(e:Error){
					continue
				}
				var skinnable:Array = skinClients[a] as Array;
				for(var i:uint=0; i<skinnable.length; i++){
					var client:ISkinClient = ISkinClient(skinnable[i])
					var skin:ISkin;
					try{
						var mclip:MovieClip = MovieClip(new classDefinition());
						skin = new FlaSymbolSkin(mclip);
					}catch(e:Error){
						trace('there was no movieclip in the loaded swf')
					}
					client.skin = skin;
				}
			}	
			dispatchEvent(new Event(SKIN_SWF_LOADED));
			*/
		}

	}
}