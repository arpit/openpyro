package org.openPyro.effects
{
	import org.openPyro.collections.ArrayCollection;
	
	import flash.events.Event;
	
	public class EffectSequence extends PyroEffect
	{
		private var effects:ArrayCollection
		public function EffectSequence()
		{
			effects = new ArrayCollection();
		}
		
		public function addEffect(effect:PyroEffect):void{
			effects.addItem(effect);
		}
		
		protected var currentlyPlayingEffectIndex:int = -1;
		protected var currentlyPlayingEffect:PyroEffect;
		
		override public function start():void{
			for(var i:int=0; i<effects.length-1; i++){
				var eff:PyroEffect = effects.getItemAt(i);
				eff.addEventListener(Event.COMPLETE, function(event:Event):void{
					currentlyPlayingEffectIndex++;
					currentlyPlayingEffect = effects.getItemAt(currentlyPlayingEffectIndex);
					currentlyPlayingEffect.start();	
				});
			}
			effects.getItemAt(effects.length-1).addEventListener(Event.COMPLETE, function(event:Event):void{
				dispatchEvent(new Event(Event.COMPLETE));
			})
			currentlyPlayingEffectIndex=0;
			currentlyPlayingEffect = PyroEffect(effects.getItemAt(0));
			currentlyPlayingEffect.start();
		}
		
		override public function pause():void{
			currentlyPlayingEffect.pause()
		}
		
		override public function resume():void{
			currentlyPlayingEffect.resume();
		}


	}
}