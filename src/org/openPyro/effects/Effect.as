package org.openPyro.effects{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	import gs.TweenMax;
	
	import org.openPyro.core.MeasurableControl;
	
	public class Effect{
		
		private var _target:DisplayObject;
		private var _effectQueue:Array;
		
		public function Effect(){
			_effectQueue = [];
		}
		
		public function set target(tgt:DisplayObject):void{
			_target = tgt;
		}
		
		public static function on(tgt:DisplayObject):Effect{
			var effect:Effect = new Effect();
			effect.target = tgt;
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
			
		private var areEffectsPlaying:Boolean = false;
		private function triggerQueue():void{
			if(!areEffectsPlaying){
				playNextEffect();
			}
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
			
			
			if(_target.parent is MeasurableControl){
				MeasurableControl(_target.parent).$addChild(mask);
			}
			else{
				_target.parent.addChild(mask);
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
	
		private function playNextEffect():void{
			if(_effectQueue.length == 0){
				/*
				 * TODO
				 */ 
				//dispatchEvent()
				areEffectsPlaying = false;
				return;
			}
			areEffectsPlaying = true;
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
			
			TweenMax.to(nextEff.target, nextEff.duration, props);
		}		
	}
}