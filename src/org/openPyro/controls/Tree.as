package org.openPyro.controls
{
	import flash.display.DisplayObject;
	
	import org.openPyro.collections.TreeCollection;
	import org.openPyro.collections.XMLNodeDescriptor;
	import org.openPyro.controls.events.ScrollEvent;
	import org.openPyro.controls.events.TreeEvent;
	import org.openPyro.layout.TreeLayout;

	public class Tree extends List
	{
		
		public static const ITEM_OPENING:String = "treeItemOpening";
		public static const ITEM_CLOSING:String = "treeItemClosing";
		
		
		public function Tree()
		{
			if(_labelFunction == null){
				this._labelFunction = function(data:XMLNodeDescriptor):String{
					if(data && data.node && data.node.nodeKind() == "element"){
						return String(data.node.@label)
					}
					return "[Unparsed Object]";
				}
			}
			super();
			this.layout = new TreeLayout();
			
		}
		
		override protected function onVerticalScroll(event:ScrollEvent):void{
			this.treeState = "scrolling";
			super.onVerticalScroll(event);
		}
		
		override protected function convertDataToCollection(dp:Object):void{
			this._dataProviderCollection = new TreeCollection();
			TreeCollection(_dataProviderCollection).showRoot = _showRoot;
			TreeCollection(_dataProviderCollection).source = XML(dp);
		}
		
		override protected function createNewRenderer(newRendererUID:String,rowIndex:Number):DisplayObject{
			var renderer:DisplayObject = super.createNewRenderer(newRendererUID, rowIndex);
			renderer.addEventListener(TreeEvent.ROTATOR_CLICK, handleRotatorClick);
			return renderer;
		}
		
		public var treeState:String = "";
		
		protected function handleRotatorClick(event:TreeEvent):void{
			var nodeDescriptor:XMLNodeDescriptor = event.nodeDescriptor;
			if(nodeDescriptor.isLeaf()) {
				return;
			}
			if(nodeDescriptor.open){
				treeState = ITEM_CLOSING;
				TreeCollection(this.dataProviderCollection).closeNode(nodeDescriptor);
			}
			else{
				treeState = ITEM_OPENING;
				TreeCollection(this.dataProviderCollection).openNode(nodeDescriptor);
			}
			this.sizeInvalidated = true;
			this.forceInvalidateDisplayList = true;
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		private var _showRoot:Boolean = true;
		public function set showRoot(val:Boolean):void{
			_showRoot = val;
			if(_dataProviderCollection){
				TreeCollection(_dataProviderCollection).showRoot = val;
			}
		}
	}
}