package org.openPyro.effects{
	import caurina.transitions.*;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.openPyro.core.MeasurableControl;

	public class Effect extends EventDispatcher{
		
		private var _target:DisplayObject;
		private var _effectQueue:Array;
		
		public function Effect(){
			_effectQueue = [];
		}
		
		public function get effectQueue():Array{
			return _effectQueue;
		}
		
		public function set target(tgt:DisplayObject):void{
			_target = tgt;
		}
		
		public function get target():DisplayObject{
			return _target;
		}
		
		private static var _currentlyAnimatingTargets:Dictionary = new Dictionary();
		
		/**
		 * Assigns the target on which the <code>Effect</code>
		 * will play
		 */ 
		public static function on(tgt:DisplayObject, parallel:Boolean=false):Effect{
			if(_currentlyAnimatingTargets[tgt] != null && !parallel){
				return Effect(_currentlyAnimatingTargets[tgt]);
			}
			var effect:Effect = new Effect();
			effect.target = tgt;
			_currentlyAnimatingTargets[tgt] = effect;
			return effect;
		}
		
		public static function isPlayingOn(ob:DisplayObject):Boolean{
			return _currentlyAnimatingTargets[ob] != null;
		}
		
		/**
		 * Cancels the currently playing effect defined in
		 * the <code>_currentEffectDescriptor</code>
		 */ 
		public function cancelCurrent():Effect{
			Tweener.removeTweens(this._target);
			_currentEffectDescriptor = null;
			_areEffectsPlaying = false;
			delete(_currentlyAnimatingTargets[this._target]);
			return this;
		}
		
		public static function cancelAll():void{
			Tweener.removeAllTweens();
		}
		
		/**
		 * Completes the current transition defined in the 
		 * <code>_currentEffectDescriptor</code>
		 */ 
		public function completeCurrent():Effect{
			Tweener.removeTweens(this._target);
			if(_currentEffectDescriptor){
				for(var a:String in this._currentEffectDescriptor.properties){
					if(!(_currentEffectDescriptor.properties[a] is Function) && a != "time"){
						this._target[a] = _currentEffectDescriptor.properties[a];
					}
				}
			}
			_currentEffectDescriptor = null;
			_areEffectsPlaying = false;
			delete(_currentlyAnimatingTargets[this._target]);
			dispatchEvent(new EffectEvent(EffectEvent.COMPLETE));
			return this;
		}
		
		private var _isWaiting:Boolean= false;
		public function wait(duration:Number = 1):Effect{
			var timer:Timer = new Timer(duration*1000,1);
			_isWaiting = true;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void{
				_isWaiting = false;
				invalidateEffectQueue();
			});
			timer.start();
			return this;
		}
		
		
		/**
		 * Convinience method to play any effectDescriptor
		 */ 
		public static function play(effectDescriptor:EffectDescriptor):Effect{
			var effect:Effect = new Effect();
			effect.target = effectDescriptor.target;
			effect.effectQueue.push(effectDescriptor);
			effect.invalidateEffectQueue();
			return effect;
		}
		
		private var _onComplete:Function;
		
		public function onComplete(fn:Function):void{
			this._onComplete = fn;	
		}
		
		public function moveY(value:Number, duration:Number=1):Effect{
			_effectQueue.push(new EffectDescriptor(this._target, duration, {y:value}));
			invalidateEffectQueue();
			return this;
		}
		
		public function moveYBy(value:Number, duration:Number=-1):Effect{
			return moveY(this._target.y+value, duration);
		}
		
		
		public function moveX(value:Number, duration:Number=1):Effect{
		    _effectQueue.push(new EffectDescriptor(this._target, duration, {x:value}));
		    invalidateEffectQueue();
		    return this;
		}
		
		public function moveXBy(value:Number, duration:Number=1):Effect{
			_effectQueue.push(new EffectDescriptor(this._target, duration, {x:_target.x+value}));
			invalidateEffectQueue();
			return this;
		}
		
		public function exec(fn:Function):Effect{
			var eff:EffectDescriptor = new EffectDescriptor(this._target, 0, {onComplete:fn});
			_effectQueue.push(eff);
			this.invalidateEffectQueue();
			return this;
		}
		
		public function animateProperty(propertyName:String, value:Number, duration:Number=1):Effect{
			
			var o:Object = {};
			o[propertyName] = value;
			
		    _effectQueue.push(new EffectDescriptor(this._target, duration, o));
		    invalidateEffectQueue();
		    return this;
		}
		
		
		public function fadeIn(duration:Number=1):Effect{
		    var hadFilters:Boolean = _target.filters.length > 0;
			_effectQueue.push(new EffectDescriptor(this._target, 
							
							duration, {alpha:1, visible:true, onComplete:function():void{
								if(!hadFilters){
									_target.filters = [];
								}	
							}},
							
							function():void{
								_target.alpha=0;
								if(_target.filters.length == 0){
								    /* force the displayobject to be cached as bitmap */
									_target.filters = [new DropShadowFilter(1,90,0,0)]
								}
							}
			));
			invalidateEffectQueue();
			return this;
		}
		
		public function fadeOut(duration:Number=1):Effect{
			_effectQueue.push(new EffectDescriptor(this._target, duration, {alpha:0}));
			invalidateEffectQueue();
			return this;	
		}
		
		public function slideDown(duration:Number=1):Effect{
			var originalY:Number = _target.y;
			var prepareSlideDown:Function = function():void{
				createEffectMask();
				_target.y = -(_target.height);
				
			}
			_effectQueue.push(new EffectDescriptor(this._target, duration, 
								{y:originalY, onComplete:removeEffectMask},prepareSlideDown));
			invalidateEffectQueue();
			return this;
		}
		
		public function slideUp(duration:Number=1):Effect{
			_effectQueue.push(new EffectDescriptor(this._target, duration, 
								{y:-this._target.height, onComplete:removeEffectMask},createEffectMask));
			invalidateEffectQueue();
			return this;
		}
		
		public function zoom(scale:Number, duration:Number=1):Effect{
			var xdiff:Number = _target.width*(_target.scaleX - scale)/2;
			var ydiff:Number = _target.height*(_target.scaleY - scale)/2;
			_effectQueue.push(new EffectDescriptor(this._target, duration, {scaleX:scale, scaleY:scale, x:_target.x+xdiff,y:_target.y+ydiff}));
			invalidateEffectQueue();
			return this;
		}
			
		public function wipeDown(duration:Number=1):Effect{
			/*
			 The effectDescriptor target is null because its populated
			 right before execution. Evaluating the mask right now would
			 set the target to a null value.
			 */
			var discriptor:EffectDescriptor = new EffectDescriptor(null, duration, 
								{height:_target.height, onComplete:removeEffectMask}, function():void{
									createEffectMask();
									discriptor.target = _effectMask;
									_effectMask.height = 0;
								})
			
			_effectQueue.push(discriptor);
			invalidateEffectQueue();
			return this;
		}
		
		public function wipeUp(duration:Number=1):Effect{
			/*
			 The effectDescriptor target is null because its populated
			 right before execution. Evaluating the mask right now would
			 set the target to a null value.
			 */
			var discriptor:EffectDescriptor = new EffectDescriptor(null, duration, 
								{height:0, onComplete:removeEffectMask}, function():void{
									createEffectMask();
									discriptor.target = _effectMask;
									_effectMask.height = _target.height;
								})
			
			_effectQueue.push(discriptor);
			invalidateEffectQueue();
			return this;
		}
		
		private var _effectMask:Shape;
		
		/**
		 * Creates a mask for effects requiring masks. The mask 
		 * created is added to the target's parent at a level
		 * one above the target
		 */ 
		private function createEffectMask():Shape{
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0xff0000);
			mask.graphics.drawRect(-5,-5,_target.width+10, _target.height+10);
			mask.graphics.endFill();
			
			if(_target.parent is MeasurableControl){
				var parent:MeasurableControl = MeasurableControl(_target.parent);
				parent.$addChildAt(mask,MeasurableControl(parent).getChildIndex(_target)+1);
			}
			else{
				_target.parent.addChildAt(mask,(DisplayObjectContainer(_target.parent).getChildIndex(_target)+1));
			}
			mask.x = _target.x;
			mask.y = _target.y;
			this._effectMask = mask;
			_target.mask = mask;
			return mask;
		}
		
		private function removeEffectMask():void{
			_target.mask = null;	
			_effectMask.parent.removeChild(_effectMask);
			_effectMask = null;					
		}
		
		
		private var _areEffectsPlaying:Boolean = false;
		
		private var currentlyConfigurableEffect:EffectDescriptor;
		
		
		/**
		 * Invalidates the effect queue. If an effect is playing,
		 * it doesnt do anything at all, but if none are playing
		 * it triggers the playNextEffect() function after waiting a frame.
		 * 
		 * The wait is to allow methods like withEasing() etc to modify
		 * the EffectDescriptors as needed.
		 * 
		 */ 
		public function invalidateEffectQueue():void{
			currentlyConfigurableEffect  = _effectQueue[_effectQueue.length-1];
			
			if(!_isWaiting){
				// There are no effects playing, so wait a frame for all properties to be set
				// before beginning 
				// This is needed for the setting of the withProperty() type instructions
				if(!_areEffectsPlaying){
					var self:Effect = this;
					this._target.addEventListener(Event.ENTER_FRAME, function(event:Event):void{
						_target.removeEventListener(Event.ENTER_FRAME, arguments.callee);
						_currentlyAnimatingTargets[_target] = self;
						playNextEffect();
					})
						
				}
				else{
					_currentlyAnimatingTargets[_target] = this;
					playNextEffect();
				}
				
			}
		}
		
		/**
		 * Takes an easing String to use as the easing on a previously declared
		 * Effect.
		 * 
		 * Usage: Effect.on(target).moveX(500).withEasing("linear");
		 * 
		 * @see http://hosted.zeh.com.br/tweener/docs/en-us/misc/transitions.html
		 */ 
		public function withEasing(easing:String):Effect{
			currentlyConfigurableEffect.setProperty("transition", easing);
			return this;
		}
		
		public function withProperty(propertyName:String, value:*):Effect{
			currentlyConfigurableEffect.setProperty(propertyName, value);
			return this;
		}
		
		private var _currentEffectDescriptor:EffectDescriptor;
		
		/**
		 * Plays the next effect in the effectQueue
		 */ 
		private function playNextEffect():void{
			var self:Effect = this;
			
			if(_effectQueue.length == 0){
				delete(_currentlyAnimatingTargets[this._target]);
				if(_onComplete != null){
					_onComplete(self);
				}
				_currentEffectDescriptor = null;
				dispatchEvent(new EffectEvent(EffectEvent.COMPLETE));
				_areEffectsPlaying = false;
				return;
			}
			
			_areEffectsPlaying = true;
			_currentEffectDescriptor = EffectDescriptor(_effectQueue.shift());
			
			
			
			var props:Object = _currentEffectDescriptor.properties;
			if(!props){
				props = {};
			}
			if(props.onComplete){
				var fn:Function = props.onComplete;
				props.onComplete = function():void{
					fn( self );
					if(_currentEffectDescriptor.onComplete != null){
						_currentEffectDescriptor.onComplete(self);
					}
					playNextEffect();
				}
			}
			else if(_currentEffectDescriptor.onComplete != null){
				props.onComplete = function():void{
					_currentEffectDescriptor.onComplete(self);
					playNextEffect();
				}
			}
			else{
				props.onComplete = playNextEffect;	
			}
			
			if(_currentEffectDescriptor.beforeStart != null){
				_currentEffectDescriptor.beforeStart();
			}
			
			props.time = _currentEffectDescriptor.duration;
			
			
			
			Tweener.addTween(_currentEffectDescriptor.target,props);
		}		
	}
}