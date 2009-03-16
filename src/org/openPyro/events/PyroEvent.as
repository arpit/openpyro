package org.openPyro.events
{
	import flash.events.Event;
	
	public class PyroEvent extends Event
	{
		public static const CREATION_COMPLETE:String = "creationComplete";
		public static const PROPERTY_CHANGE:String = "propertyChange";
		public static const PREINITIALIZE:String = "preInitialize";
		public static const INITIALIZE:String = "initialize";
		public static const SIZE_INVALIDATED:String = "sizeInvalidated";
		public static const SIZE_VALIDATED:String = "sizeValidated";
		public static const SIZE_CHANGED:String = "sizeChanged";
		public static const SCROLLBARS_CHANGED:String = "scrollBarsChanged"
		public static const UPDATE_COMPLETE:String="updateComplete";
		
		public static const ENTER:String = "enter"
		
		public function PyroEvent(type:String)
		{
			super(type);
		}

	}
}