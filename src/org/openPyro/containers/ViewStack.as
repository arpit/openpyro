package org.openPyro.containers
{
	import flash.display.DisplayObject;
	
	import org.openPyro.controls.scrollBarClasses.ScrollPolicy;
	import org.openPyro.core.UIContainer;
	import org.openPyro.layout.ILayout;
	import org.openPyro.utils.ArrayUtil;

	public class ViewStack extends UIContainer{
		
		[ArrayElementType("org.openPyro.core.UIContainer")]
		protected var viewChildren:Array;
		
		/**
		 * The viewstack manages multiple the visibility of
		 * multiple UIContainers that are added to it.
		 */ 
		public function ViewStack(){
			super();
			this._horizontalScrollPolicy = ScrollPolicy.OFF
			this._verticalScrollPolicy = ScrollPolicy.OFF;
			viewChildren = new Array();
		}
		
		private var viewsChanged:Boolean = true;
		
		protected var _selectedIndex:int = -1;
		public function set selectedIndex(idx:int):void
		{
			if(_selectedIndex == idx) return;
			_selectedIndex = idx;
			this._selectedChild = viewChildren[_selectedIndex];
			viewsChanged = true;
			if(this.initialized){
				forceInvalidateDisplayList=true;
				invalidateDisplayList();
			}
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(!(child is UIContainer))
			{
				throw new Error("ViewStacks can only hold UIContainers");
				return;
			}
			return addChildAt(child, this.contentPane.numChildren);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(!(child is UIContainer))
			{
				throw new Error("ViewStacks can only hold UIContainers");
				return;
			}
			ArrayUtil.insertAt(viewChildren, index, child);
			_selectedChild = viewChildren[viewChildren.length-1];
			_selectedIndex = viewChildren.length -1;
			viewsChanged = true;
			for(var i:int=0; i<viewChildren.length; i++){
				viewChildren[i].visible = false;
			}
			_selectedChild.visible = true;
			return super.addChildAt(child, index);
		}
		
		protected var _selectedChild:UIContainer = null;
		public function set selectedChild(child:UIContainer):void
		{
			if(_selectedChild == child) return;
			
			for(var i:uint=0; i<viewChildren.length; i++)
			{
				var container:UIContainer = viewChildren[i];
				if(container == child)
				{
					this.selectedIndex = i;
				}
			}
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if(viewChildren.indexOf(child) != -1){
				ArrayUtil.remove(viewChildren, child);
			}
			if(_selectedChild == child){
				// set the topmost child as the visible child
				selectedIndex = viewChildren.length-1;	
			}
			return super.removeChild(child);
		}
		
		public function get selectedChild():UIContainer
		{
			return _selectedChild;
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth-padding.left- padding.right, unscaledHeight-padding.top - padding.bottom);
			for each(var ch:DisplayObject in this.layoutChildren){
				ch.y = padding.top;
				ch.x = padding.right;
			}
			if(viewsChanged){
				viewsChanged = false;
				showSelectedChild()
			}
		}
		
		protected function showSelectedChild():void
		{
			for(var i:uint=0; i<viewChildren.length; i++){
				var child:DisplayObject = DisplayObject(viewChildren[i]);
				child.visible = (i == _selectedIndex)?true:false;
			}
		}
		
	}
}
