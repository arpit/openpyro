package org.openPyro.effects
{
	import flash.events.Event;
	
	public class EffectEvent extends Event
	{
		
		public static const COMPLETE:String="complete";
		
		public function EffectEvent(type:String)
		{
			super(type);
		}

	}
}