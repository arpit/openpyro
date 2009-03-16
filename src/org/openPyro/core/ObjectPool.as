package org.openPyro.core{
	
	import org.openPyro.core.ClassFactory;
	import org.openPyro.utils.ArrayUtil;
	
	/**
	 * ObjectPools are used to reuse created objects
	 * rather than create new one every time one is needed.
	 */ 
	public class ObjectPool{
		
		private var availableObjects:Array;
		private var populatedObjects:Array;
		private var _classFactory:ClassFactory;
		
		public function ObjectPool(classFactory:ClassFactory){
			_classFactory = classFactory;
			availableObjects = new Array();
			populatedObjects = new Array();
		}
		
		public function getObject():Object{
			var r:Object;
			if(availableObjects.length > 0){
				r = availableObjects.pop();
			}
			else{
				r = _classFactory.newInstance();
			}
			populatedObjects.push(r);
			return r;
		}
		
		public function hasReusableObject():Boolean{
			return (availableObjects.length > 0);
		}
		
		public function returnToPool(r:Object):void{
			ArrayUtil.removeItemAt(populatedObjects, populatedObjects.indexOf(r));
			this.availableObjects.push(r);
		}
	}
}