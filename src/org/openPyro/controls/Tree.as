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
				closeNode(nodeDescriptor);
			}
			else{
				openNode(nodeDescriptor);
			}
		}
		
		protected function closeNode(nodeDescriptor:XMLNodeDescriptor):void{
			var items:Array = [];
			nodeDescriptor.open = false;
			items = getChildNodesArray(nodeDescriptor.node, items);
			TreeCollection(this._dataProviderCollection).removeItems(items);
		}
		
		
		protected function getChildNodesArray(node:XML, arr:Array):Array{
			for(var i:int=0; i<node.elements("*").length(); i++){
				arr.push(node.elements("*")[i]);
				if(node.hasComplexContent()){
					getChildNodesArray(node.elements("*")[i], arr);
				}
			}
			return arr;
		}
		
		protected function openNode(nodeDescriptor:XMLNodeDescriptor):void{
			TreeCollection(this.dataProviderCollection).openNode(nodeDescriptor);
		}

	}
}