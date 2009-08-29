package org.openPyro.collections
{
	import org.openPyro.collections.ICollection;
	
	public class CollectionHelpers
	{
		public static function sourceToCollection(src:Object):ICollection{
			if(src is Array){
				return new ArrayCollection(src as Array);
			}
			else if(src is XML){
				return new TreeCollection(src as XML)
			}
			else return ICollection(src);
			
		}
	}
}