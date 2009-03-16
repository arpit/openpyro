package org.openPyro.storage
{
	import org.openPyro.core.ISerializable;
	
	import flash.utils.Dictionary;
	
	/**
	 * @example The following code shows how to use StorageDictionary
	 * 
	 * <listing version="3.0" > 
	 * 		var kv:StorageDictionary = new StorageDictionary()
	 * 		kv.setKeyValuePair("one", "1");
	 * 		kv.setKeyValuePair("two", "2");
	 * 		kv.separator = "&"
	 * 		var serializedString:String = kv.serialize();
	 * </listing>
	 */ 
	public class StorageDictionary implements ISerializable
	{
		
		private var keyValueString:String = "";
		
		private var data:Dictionary = new Dictionary()
		
		protected var _separator:String = "|"
		
		public function StorageDictionary() {
			
		}
		
		public function set separator(separatorCharacter:String):void{
			_separator = separatorCharacter
		}
		
		public function get separator():String{
			return _separator;
		}
		
		
		public function setKeyValuePair(key:String, value:String):void
		{
			data[key] = value;
		}
		
		public function getValueForKey(key:String):String
		{
			return data[key];
		}
		
		public function serialize():String
		{
			for(var key:String in data){
				
				keyValueString+=key+":"+data[key]+_separator;
				
			}
			return keyValueString;
		}
		
		/**
		 * Reconsitutes a key value pair based dictionary
		 * from a serialized string.
		 */ 
		public function deserialize(str:String):void
		{
			var keyValArray:Array = str.split(this._separator);
			for(var i:int=0; i<keyValArray.length; i++)
			{
				var key:String = String(String(keyValArray[i]).split(":")[0])
				var value:String = String(String(keyValArray[i]).split(":")[1])
				if(data.hasOwnProperty(key))
				{
					//TODO: Storage handle conflict
				}
				data[key] = value;
			}
		}

	}
}