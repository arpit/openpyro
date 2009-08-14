package org.openPyro.collections
{
	import flexunit.framework.TestCase;
	
	import org.openPyro.collections.events.CollectionEvent;
	import org.openPyro.collections.events.CollectionEventKind;

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
			var changeEvent:CollectionEvent;
			_collection.addEventListener(CollectionEvent.COLLECTION_CHANGED, function(event:CollectionEvent):void{
				eventFired = true;
				 changeEvent = event;
			});
			_collection.removeItems([4]);
			assertTrue("ArrayCollection.removeItems did not remove the item correctly",_collection.getItemIndex(4)==-1)	
			assertTrue("Collection Change event delta was incorrect", changeEvent.delta[0] == 4);
			assertTrue("Collection Change event kind was incorrect", changeEvent.kind ==CollectionEventKind.REMOVE);
			assertTrue("ArrayCollection change event did not fire", eventFired);
		}
		
		public function testIterator():void{
			var itemsFromIterator:Array = [];
			var iterator:ArrayIterator = _collection.iterator as ArrayIterator;
			while(iterator.hasNext()){
				var item:Number = iterator.getNext() as Number;
				itemsFromIterator.push(item);
			}
			assertTrue("Iterator returned incorrect length", itemsFromIterator.length == 5)
			
		}
		
	}
}