package org.openPyro.effects
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import gs.TweenMax;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="starting", type="flash.events.Event")]
	
	public class PyroEffect extends EventDispatcher{
		
		/**
		 * Event dispatched just before the effect begins to
		 * play.
		 */ 
		public static const STARTING:String = "starting";
		
		[ArrayElementType("org.openPyro.effects.EffectDescriptor")]
		protected var _effDescriptors:Array;
		
		public function PyroEffect() {}
		
		protected var _target:DisplayObject
		public function set target(tgt:DisplayObject):void{
			_target = tgt;
		}
		
		
		public function set effectDescriptors(effDescriptors:Array):void{
			_effDescriptors = effDescriptors;
		}
		
		public function get effectDescriptors():Array{
			return _effDescriptors;
		}
		
		public var currentEffect:TweenMax;
		
		public function start():void{
			for each(var descriptor:EffectDescriptor in _effDescriptors){
				descriptor.properties.onComplete = function():void{
					dispatchEvent(new Event(Event.COMPLETE));
				}
				if(!isNaN(_startDelay)){
					descriptor.properties.delay = _startDelay;
				}
				
				dispatchEvent(new Event(STARTING));
				currentEffect = TweenMax.to(descriptor.target, descriptor.duration, descriptor.properties);
			}
		}
		
		public function pause():void{
			if(currentEffect){
				currentEffect.pause();
			}
		}
		
		public function resume():void{
			if(currentEffect && currentEffect.paused){
				currentEffect.resume();
			}
		}
		
		protected var _startDelay:Number = NaN
		public function set startDelay(delay:Number):void{
			_startDelay = delay;
		}
		
	}
}