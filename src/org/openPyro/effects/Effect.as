package org.openPyro.effects{
	import caurina.transitions.*;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.UIContainer;
	
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
		
		public static function on(tgt:DisplayObject):Effect{
			var effect:Effect = new Effect();
			effect.target = tgt;
			return effect;
		}
		
		private var _onComplete:Function;
		
		public function onComplete(fn:Function):void{
			this._onComplete = fn;	
		}
		
		public static function play(effectDescriptor:EffectDescriptor):Effect{
			var effect:Effect = new Effect();
			effect.target = effectDescriptor.target;
			effect.effectQueue.push(effectDescriptor);
			effect.triggerQueue();
			return effect;
		}
		
		public function fadeIn(duration:Number=1):Effect{
			_effectQueue.push(new EffectDescriptor(this._target, duration, {alpha:1},function():void{
				_target.alpha=0;
			}));
			triggerQueue();
			return this;
		}
		
		public function fadeOut(duration:Number=1):Effect{
			_effectQueue.push(new EffectDescriptor(this._target, duration, {alpha:0}));
			triggerQueue();
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
			triggerQueue();
			return this;
		}
		
		public function slideUp(duration:Number=1):Effect{
			_effectQueue.push(new EffectDescriptor(this._target, duration, 
								{y:-this._target.height, onComplete:removeEffectMask},createEffectMask));
			triggerQueue();
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
			triggerQueue();
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
			triggerQueue();
			return this;
		}
		
		private var _effectMask:Shape;
		
		
		private function createEffectMask():Shape{
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0xff0000);
			mask.graphics.drawRect(0,0,_target.width, _target.height);
			mask.graphics.endFill();
				trace("create mask: "+getQualifiedClassName(_target.parent))
			
			if(_target.parent is MeasurableControl){
				var parent:MeasurableControl = MeasurableControl(_target.parent);
				if(parent is UIContainer){
					parent.$addChildAt(mask,UIContainer(parent).contentPane.getChildIndex(_target)+1);
				}
				else{
					trace("addchild")
					parent.$addChildAt(mask,MeasurableControl(parent).getChildIndex(_target));
				}
				
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
		
		public function triggerQueue():void{
			if(!_areEffectsPlaying){
				playNextEffect();
			}
		}
		
		
	
		private function playNextEffect():void{
			if(_effectQueue.length == 0){
				if(_onComplete != null){
					_onComplete();
				}
				dispatchEvent(new EffectEvent(EffectEvent.COMPLETE));
				_areEffectsPlaying = false;
				return;
			}
			_areEffectsPlaying = true;
			var nextEff:EffectDescriptor = EffectDescriptor(_effectQueue.shift());
			var props:Object = nextEff.properties;
			if(props.onComplete){
				var fn:Function = props.onComplete;
				props.onComplete = function():void{
					fn();
					playNextEffect();
				}
			}
			else{
				props.onComplete = playNextEffect;	
			}
			
			if(nextEff.beforeStart != null){
				nextEff.beforeStart();
			}
			
			props.time = nextEff.duration;
			
			Tweener.addTween(nextEff.target,props);
		}		
	}
}