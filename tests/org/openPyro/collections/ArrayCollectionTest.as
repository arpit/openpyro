package org.openPyro.collections
{
	import flexunit.framework.TestCase;
	
	import org.openPyro.collections.events.CollectionEvent;

	public class ArrayCollectionTest extends TestCase
	{
		// please note that all test methods should start with 'test' and should be public
		
		
		private var _collection:ArrayCollection;
		
		override public function setUp():void
		{
			super.setUp();
			_collection = new ArrayCollection([0,1,2,3,4]);
		}
		
		override public function tearDown():void
		{
			super.tearDown();
		}
		
		public function testRemoveItems():void
		{
			var eventFired:Boolean = false;
			_collection.addEventListener(CollectionEvent.COLLECTION_CHANGED, function(event:CollectionEvent):void{
				eventFired = true;
			});
			_collection.removeItems([4]);
			assertTrue("ArrayCollection.removeItems did not remove the item correctly",_collection.getItemIndex(4)==-1)	
			assertTrue("ArrayCollection change event did not fire", eventFired);
		}
		
	}
}