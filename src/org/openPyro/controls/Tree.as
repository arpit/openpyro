package org.openPyro.controls
{
	import flash.display.DisplayObject;
	
	import org.openPyro.collections.TreeCollection;
	import org.openPyro.collections.XMLNodeDescriptor;
	import org.openPyro.controls.events.TreeEvent;
	
	public class Tree extends List
	{
		public function Tree()
		{
		}
		
		override protected function createNewRenderer(newRendererUID:String,rowIndex:Number):DisplayObject{
			var renderer:DisplayObject = super.createNewRenderer(newRendererUID, rowIndex);
			renderer.addEventListener(TreeEvent.ROTATOR_CLICK, handleRotatorClick);
			return renderer;
		}
		
		protected function handleRotatorClick(event:TreeEvent):void{
			var nodeDescriptor:XMLNodeDescriptor = event.nodeDescriptor;
			if(nodeDescriptor.isLeaf()) {
				return;
			}
			if(nodeDescriptor.open){
				TreeCollection(this.dataProviderCollection).closeNode(nodeDescriptor);
			}
			else{
				TreeCollection(this.dataProviderCollection).openNode(nodeDescriptor);
			}
		}
	}
}