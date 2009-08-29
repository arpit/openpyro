package org.openPyro.collections
{
	public class XMLCollection extends ArrayCollection
	{
		public function XMLCollection(xml:XML=null)
		{
			super();
			if(xml){
				sourceXML = xml;
			}
					
		}
		
		public function set sourceXML(xml:XML):void{
			var normalizedArray:Array = [];
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