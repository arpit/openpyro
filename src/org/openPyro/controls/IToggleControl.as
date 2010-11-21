package org.openPyro.controls{
	
	import flash.events.IEventDispatcher;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * A toggle control is a control like a CheckBox or a ToggleButton 
	 * that has a "selected" state and dispatches an event when the 
	 * state changes 
	 */ 
	public interface IToggleControl extends IEventDispatcher{
		function set selected(b:Boolean):void;
		function get selected():Boolean;
	}
}