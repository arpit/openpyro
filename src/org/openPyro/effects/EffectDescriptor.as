package org.openPyro.effects
{
	import flash.display.DisplayObject;
	
	/**
	 * The EffectDescriptor class is an object that can be passed 
	 * to an Effect class to execute.Unlike Flex's effects which can 
	 * only operate on UIComponents and are therefore tied to
	 * them, OpenPyro effects are executed based on EffectDescriptors, 
	 * so are decoupled from the framework.
	 */ 
	
	public class EffectDescriptor
	{
		public var target:DisplayObject;
		public var duration:Number;
		public var properties:Object
		
		public function EffectDescriptor(target:DisplayObject = null, duration:Number = NaN, properties:Object = null )
		{
			this.target = target;
			this.duration = duration;
			this.properties = properties;
		}

	}
}