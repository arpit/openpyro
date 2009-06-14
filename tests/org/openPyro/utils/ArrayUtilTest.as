package org.openPyro.utils
{
	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;
	

	public class ArrayUtilTest extends TestCase
	{
		// Reference declaration for class to test
		private var classToTestRef : org.openPyro.utils.ArrayUtil;
		
		private var testArray:Array;
		public function ArrayUtilTest(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			super.setUp();
			testArray = ["zero","one","two","three","four","five","six","seven","eight"];
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			testArray = null;
		}
		
		
		public function testInsertAt():void{
			ArrayUtil.insertAt(testArray, 1, "between_0_and_1");
			assertTrue("Array value at 1 was unexpected "+testArray[1],testArray[1] == "between_0_and_1");
			assertTrue("Array length was incorrect "+testArray.length,testArray.length == 10);
			ArrayUtil.insertAt(testArray, 9, "after_8");
			assertTrue("Array value at 9 was unexpected "+testArray[9], testArray[9]=="after_8");
			var newArray:Array = new Array();
			ArrayUtil.insertAt(newArray, 0, "new_zero");
			assertTrue("Array value at 0 was unexpected "+newArray[0], newArray[0]=="new_zero");
		}
		
		public function testSwap():void{
			ArrayUtil.swapByValue(testArray, "zero", "one");
			assertTrue("Array value at 0 was unexpected "+testArray[0], testArray[0]=="one");
			assertTrue("Array value at 1 was unexpected "+testArray[1], testArray[1]=="zero");
		}
		
		public function testRemove():void{
			ArrayUtil.remove(testArray, "zero");
			assertTrue("Array value at 0 was unexpected "+testArray[0], testArray[0]=="one");
			assertTrue("Array length did not reduce after remove", testArray.length == 8);
		}
		
		public function testRemoveDuplicates():void{
			testArray = ["zero","one","zero","two","three","one"];
			ArrayUtil.removeDuplicates(testArray);
			assertTrue("Remove Duplicates failed ",testArray.length == 4);
			assertTrue("Remove Duplicates failed ",testArray[0] == "zero");
			assertTrue("Remove Duplicates order changed",testArray[2] == "two");
			
			// testing complex objects
			
			var duplicate:Object = {label:'label1', data:"d2"};
			
			var t2:Array = [duplicate,
			{label:'label2', data:"d2"},
			duplicate]
			ArrayUtil.removeDuplicates(t2);
			
			assertTrue("Remove Duplicates failed ",t2.length == 2);
		}	
		
	}
}