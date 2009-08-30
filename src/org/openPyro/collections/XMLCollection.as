package org.openPyro.collections{
	
	/**
	 * The XML Collection wraps the XML data into a ICollection
	 * that can be navigated using ICollection methods like 
	 * getItemAt or using IIterators
	 */ 
	public class XMLCollection extends ArrayCollection{
		public function XMLCollection(xml:XML=null){
			super();
			if(xml){
				sourceXML = xml;
			}		
		}
		
		/**
		 * Sets the source XML for the XMLCollection instance
		 */ 
		public function set sourceXML(xml:XML):void{
			var normalizedArray:Array = [xml];
			
			var parseFn:Function = function(xmlNode:XML):void{
				for(var i:int=0; i < xmlNode.elements("*").length(); i++){
					normalizedArray.push(xmlNode.elements("*")[i]);
					if(XML(xmlNode.elements("*")[i]).hasComplexContent()){
						parseFn(xmlNode.elements("*")[i]);
					}
				}	
			}
			parseFn(xml);
			this.source = normalizedArray;
			
		}

	}
}