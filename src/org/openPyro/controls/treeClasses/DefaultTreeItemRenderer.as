package org.openPyro.controls.treeClasses
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import org.openPyro.collections.XMLNodeDescriptor;
	import org.openPyro.controls.events.TreeEvent;
	import org.openPyro.controls.listClasses.DefaultListRenderer;
	import org.openPyro.layout.HLayout;
	import org.openPyro.painters.FillPainter;
	import org.openPyro.painters.TrianglePainter;
	
	[Event(name="rotatorClick", type="org.openPyro.controls.events.TreeEvent")]

	public class DefaultTreeItemRenderer extends DefaultListRenderer
	{
		
		/*
		The Folder Symbol is embedded in the graphic_assets.swc 
		generated from the graphics_assets.fla	
		*/
		protected var folderIconClass:Class = folderSymbol;
		
		public function DefaultTreeItemRenderer()
		{
			super();
		}
		
		protected var icon:DisplayObject;
		protected var leafIcon:DisplayObject;
		protected var rotatorButton:Sprite;
		
		override protected function createChildren():void{
			super.createChildren()
		}
		
		override public function set data(value:Object):void{
			if(_data && _data is IEventDispatcher){
				IEventDispatcher(_data).removeEventListener(XMLNodeDescriptor.BRANCH_VISIBILITY_CHANGED, setRotatorDirection);
			}
			super.data = value;
			
			if(_data is IEventDispatcher){
				IEventDispatcher(_data).addEventListener(XMLNodeDescriptor.BRANCH_VISIBILITY_CHANGED, setRotatorDirection);
			}
			
			if(!XMLNodeDescriptor(value).isLeaf()){
				if(!icon){
					icon = new folderIconClass();
				}
				if(!icon.parent){
					addChild(icon);
				}
				if(!rotatorButton){
					rotatorButton = new Sprite();
					rotatorButton.tabEnabled=false;
					rotatorButton.graphics.beginFill(0x000000,0)
					rotatorButton.graphics.drawRect(0,0, 20,20);
					rotatorButton.graphics.endFill()
					
					
					var arrow:Sprite = new Sprite();
					arrow.name = "rotator_arrow";
					var trianglePainter:TrianglePainter = new TrianglePainter(TrianglePainter.CENTERED);
					trianglePainter.draw(arrow.graphics, 8,8)
					rotatorButton.addChild(arrow)
					arrow.x = 20/2
					arrow.y = 20/2
					arrow.cacheAsBitmap = true;
					
					rotatorButton.buttonMode = true;
					rotatorButton.useHandCursor = true
					
					rotatorButton.addEventListener(MouseEvent.CLICK, onRotatorClick)//,true,1,true)
					rotatorButton.mouseChildren=false;
				}
				if(!rotatorButton.parent){
					addChild(rotatorButton);
				}
			}
			else{
				if(icon && icon.parent){
					removeChild(icon);
					icon =  null;
				}
				if(rotatorButton && rotatorButton.parent){
					removeChild(rotatorButton);
					rotatorButton = null
				}
				if(arrow && arrow.parent){
					removeChild(arrow);
					arrow = null
				}
				
				
			}
			this.forceInvalidateDisplayList=true
			this.invalidateDisplayList()
		}
		
		protected function onRotatorClick(event:MouseEvent):void{
			//event.stopImmediatePropagation()
			//event.preventDefault();
			var treeEvent:TreeEvent = new TreeEvent(TreeEvent.ROTATOR_CLICK);
			treeEvent.nodeDescriptor = XMLNodeDescriptor(_data);
			dispatchEvent(treeEvent);
		}
		
		private function setRotatorDirection(event:Event=null):void{
			
			if(!rotatorButton || !rotatorButton.parent) return;
			if(XMLNodeDescriptor(_data).open){
				rotatorButton.getChildByName("rotator_arrow").rotation = 90
			}
			else{
				rotatorButton.getChildByName("rotator_arrow").rotation = 0
			}
		}
		
		private var rendererLayout:HLayout = new HLayout(5)
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(rotatorButton && rotatorButton.parent){
				rotatorButton.y = (unscaledHeight-rotatorButton.height)/2
			}
			
			setRotatorDirection()
			
			rendererLayout.initX = XMLNodeDescriptor(_data).depth*15+10
			rendererLayout.initY = 5;
			var children:Array = []
			if(rotatorButton && rotatorButton.parent){
				children.push(rotatorButton)
			}
			else{
				rendererLayout.initX+=10;
			}
			if(icon && icon.parent){
				children.push(icon)
			}
			else{
				rendererLayout.initX+=10
			}
			children.push(_labelField);
			rendererLayout.layout(children);
		}
	}
}