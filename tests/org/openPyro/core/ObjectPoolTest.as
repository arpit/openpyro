package org.openPyro.core
{
	import flash.display.Sprite;
	
	import flexunit.framework.TestCase;

	public class ObjectPoolTest extends TestCase
	{
		// please note that all test methods should start with 'test' and should be public
		
		
		private var pool:ObjectPool;
		override public function setUp():void
		{
			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
		}
		
		public function testClear():void
		{
			pool = new ObjectPool(new ClassFactory(Sprite));
			var sprite1:Sprite = pool.getObject() as Sprite;
			var sprite2:Sprite = pool.getObject() as Sprite;
			assertTrue("Pool did not create exact number of objects needed",pool.populatedObjects.length == 2);
			pool.returnToPool(sprite2);
			assertTrue("Pool did not put returned object into free objects list",pool.populatedObjects.length == 1);
			assertTrue("Pool did not put returned object into free objects list",pool.availableObjects.length == 1);
			
			var numOfTimesDestroyCalled:int=0;
			var customDestroyFunction:Function = function(item:Object):void{
				numOfTimesDestroyCalled++;
				item = null;
			}
			pool.destroyFunction = customDestroyFunction;
			pool.clear();
			assertTrue("Pool clear did not work",pool.availableObjects.length == 0);
			assertTrue("Pool clear did not work",pool.populatedObjects.length == 0);
			assertTrue("Pool clear did not call custom destroy function correct number of times",numOfTimesDestroyCalled == 2);
			
				
		}
		
	}
}