package org.openPyro.core
{
	public interface IStateFulClient
	{
		function changeState(fromState:String, toState:String):void;
	}
}