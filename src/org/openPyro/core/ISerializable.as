package org.openPyro.core{
	
	public interface ISerializable{
		
		/**
		 * Called by any component requiring the
		 * serialized (string) form of the Object
		 */ 
		function serialize():String;
		
		/**
		 * Probably not called by any external class
		 * but encapsulates the string to Object mapping
		 */ 
		function deserialize(str:String):void;
	}
}