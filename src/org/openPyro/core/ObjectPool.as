package org.openPyro.core{
	
	import org.openPyro.utils.ArrayUtil;
	
	/**
	 * ObjectPools are used to reuse created objects
	 * rather than create new one every time one is needed.
	 */ 
	public class ObjectPool{
		
		private var _availableObjects:Array;
		private var _populatedObjects:Array;
		private var _classFactory:ClassFactory;
		
		public function ObjectPool(classFactory:ClassFactory){
			_classFactory = classFactory;
			_availableObjects = new Array();
			_populatedObjects = new Array();
		}
		
		public function getObject():Object{
			var r:Object;
			if(_availableObjects.length > 0){
				r = _availableObjects.pop();
			}
			else{
				r = _classFactory.newInstance();
			}
			_populatedObjects.push(r);
			return r;
		}
		
		public function hasReusableObject():Boolean{
			return (_availableObjects.length > 0);
		}
		
		public function returnToPool(r:Object):void{
			ArrayUtil.removeItemAt(_populatedObjects, _populatedObjects.indexOf(r));
			this._availableObjects.push(r);
		}
		
		public function get availableObjects():Array{
			return _availableObjects;
		}
		
		public function get populatedObjects():Array{
			return _populatedObjects;
		}
		
		/**
		*	Emptys the arrays and passes each object to the
		*	defined destroyFunction. The default destroyFunction 
		*	just tries to null the objects but may not succeed
		*	if EventListeners are bound strongly and so may cause
		*	a memory leak.
		*	You can create a custom function to accept each object
		*	in the pool and customize the cleanup by setting that
		*	as the destroyFunction of this instance.
		*	
		*	@see #destroyFunction
		*/	
		public function clear():void{
			var ob:Object;
			while(_populatedObjects.length > 0){
				ob = _populatedObjects.pop();
				destroyFunction(ob);
			}
			while(_availableObjects.length > 0){
				ob = _availableObjects.pop();
				destroyFunction(ob);
			}
		}
		
		/**
		*	Sets the function to call to destroy objects managed 
		*	by the ObjectPool.
		*	
		*	@see #clear()	
		*/	
		public var destroyFunction:Function = destroy;
		
		/**
		*	The default destroy function that attempts to null
		*	the objects that are managed by the <code>ObjectPool</code>
		*	You can set a custom function to null objects by setting that
		*	as the value for the <code>destroyFunction</code> method
		*	
		*	@see #destroyFunction
		*	@see #clear()
		*/
		public function destroy(ob:Object):void{
			ob = null;
		}
	}
}