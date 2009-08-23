package org.openPyro.controls
{
	import org.openPyro.collections.XMLCollection;
	import org.openPyro.collections.XMLNodeDescriptor;
	import org.openPyro.controls.events.TreeEvent;
	import org.openPyro.controls.treeClasses.DefaultTreeItemRenderer;
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.ObjectPool;
	import org.openPyro.layout.VLayout;
	import org.openPyro.painters.FillPainter;
	
	import flash.display.DisplayObject;
	import flash.profiler.showRedrawRegions;

	public class Tree extends List
	{
		public function Tree()
		{
			super();
			_labelFunction = function(data:XMLNodeDescriptor):String{
				if(data.node.nodeKind() == "element"){
					return String(data.node.@label)
				}
				return String(data.node);
			}
			this.backgroundPainter = new FillPainter(0xffffff);
		}
		
		/*override protected function createChildren():void
		{
			if(!this._rendererPool){
				var cf:ClassFactory = new ClassFactory(DefaultTreeItemRenderer);
				cf.properties = {percentWidth:100, height:25};
				_rendererPool = new ObjectPool(cf)
			}
			VLayout(this.layout).animationDuration = 0;
			
		}*/
		
		/*override protected function convertDataToCollection(dp:Object):void{
			super.convertDataToCollection(dp);
			if(!_showRoot){	
				XMLCollection(_dataProvider).normalizedArray.shift();
			}
		}*/
		
		protected var _showRoot:Boolean = true;
		public function set showRoot(value:Boolean):void {
			_showRoot = value;
		}
		
		public function get showRoot():Boolean{
			return _showRoot
		}
		
		/*override protected function setRendererData(renderer:DisplayObject, data:Object, index:int):void{
			super.setRendererData(renderer, data, index);
			renderer.addEventListener(TreeEvent.ROTATOR_CLICK, handleRotatorClick);
		}*/
		
		protected function handleRotatorClick(event:TreeEvent):void
		{
			
			var node:XMLNodeDescriptor = event.nodeDescriptor;
			if(node.isLeaf()) {
				return;
			}
			// for a non leaf node 
			if(node.open){
				closeNode(node);
			}
			else{
				openNode(node);
			}
		}
		
		public function closeNode(node:XMLNodeDescriptor):void{
			if(node.isLeaf()) {
				return;
			}
			node.open = false;
			var childNodesData:Array = XMLCollection(this.dataProvider).getOpenChildNodes(node)
			XMLCollection(this.dataProvider).removeItems(childNodesData);
		}
		
		public function openNode(node:XMLNodeDescriptor):void{
			if(node.isLeaf()) {
				return;
			}
			node.open = true;
			var childNodesData:Array = XMLCollection(this.dataProvider).getOpenChildNodes(node)
			XMLCollection(this.dataProvider).addItems(childNodesData, node);
		}
		
		public function getNodeByLabel(str:String):XMLNodeDescriptor{
			var normalizedArray:Array = _dataProvider.normalizedArray
			for(var i:int=0; i<normalizedArray.length; i++){
				var nodeDescriptor:XMLNodeDescriptor = normalizedArray[i] as XMLNodeDescriptor;
				if(_labelFunction(nodeDescriptor) == str){
					return nodeDescriptor;
				}
			}
			return null;
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight)
			//trace(" >> updateDl")
		}
		
		
	}
}