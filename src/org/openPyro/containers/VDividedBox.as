package org.openPyro.containers
{
	import org.openPyro.core.ClassFactory;
	import org.openPyro.core.MeasurableControl;
	import org.openPyro.core.UIControl;
	import org.openPyro.layout.ILayout;
	import org.openPyro.layout.VLayout;
	import org.openPyro.managers.DragManager;
	import org.openPyro.managers.events.DragEvent;
	import org.openPyro.painters.GradientFillPainter;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import flash.geom.Point;
	
	/**
	 * 
	 */ 
	public class VDividedBox extends DividedBox
	{
		/**
		 * Constructor
		 */ 
		public function VDividedBox(){
			super();
			_styleName = "VDividedBox";
		}
		
		override public function initialize():void{
			super.layout = new VLayout();
			super.initialize();
		}
		
		override protected function get defaultDividerFactory():ClassFactory{
			var df:ClassFactory = new ClassFactory(UIControl);
			df.properties = {percentWidth:100, height:6, backgroundPainter:new GradientFillPainter([0x999999, 0x666666])}
			return df;	
		}
		
		override protected function onDividerMouseDown(event:MouseEvent):void{
			this.addEventListener(DragEvent.DRAG_DROP, onDividerDragComplete);
			var dragManager:DragManager = DragManager.getInstance();
			var point:Point = new Point(0, 0);
			point = this.localToGlobal(point);
			
			dragManager.makeDraggable(DisplayObject(event.currentTarget), 
													new Rectangle(point.x,point.y,0,this.height-DisplayObject(event.currentTarget).height));
		}
		
		
		protected function onDividerDragComplete(event:DragEvent):void{
			/* 
			If the divider moves up, delta is -ve, otherwise +ve
			*/
			var delta:Number = event.mouseYDelta//point.y - event.dragInitiator.y 
		
			var topUIC:MeasurableControl
			var bottomUIC:MeasurableControl
			
			for(var i:int=0; i<contentPane.numChildren; i++){
				var child:DisplayObject = contentPane.getChildAt(i)
				if(child == event.dragInitiator){
					topUIC = MeasurableControl(contentPane.getChildAt(i-1));
					bottomUIC = MeasurableControl(contentPane.getChildAt(i+1));
					break;
				}
				
			}
			
			var unallocatedHeight:Number = (this.height - this.explicitlyAllocatedHeight);
			var newUnallocatedHeight:Number = unallocatedHeight;
			
			if(isNaN(topUIC.explicitHeight) && isNaN(bottomUIC.explicitHeight)){
				
				/*
				* The change in dimensions can be compensated by recalculating the 
				* two percents. 
				*/
				var newTopH:Number = topUIC.height + delta;
				var newBottomH:Number = bottomUIC.height - delta;
				topUIC.percentUnusedHeight = newTopH*100/unallocatedHeight;
				bottomUIC.percentUnusedHeight = newBottomH*100/unallocatedHeight
			}
			
			
			else if(!isNaN(topUIC.explicitHeight) && !isNaN(bottomUIC.explicitHeight)){
				
				/*
				 * The dimension changes can be safely calculated 
				 */
				topUIC.height+=delta
				bottomUIC.height-=delta;
			}
			
			
			else if(!isNaN(topUIC.explicitHeight)) {
				
				/*
				 * Left child is explicitly sized , right is percent sized
				 */ 
				
				topUIC.height+=delta;
				newUnallocatedHeight = unallocatedHeight-delta;
				for(var j:int=0; j<contentPane.numChildren; j++){
					var currChildL:MeasurableControl = contentPane.getChildAt(j) as MeasurableControl;
					if(dividers.indexOf(currChildL) != -1) continue;
					if(currChildL == topUIC) continue;
					if(currChildL == bottomUIC){
						var newH:Number = currChildL.height-delta;
						bottomUIC.percentUnusedHeight = newH*100/newUnallocatedHeight
					}
					else if(!isNaN(currChildL.percentUnusedHeight)){
						currChildL.percentUnusedHeight = currChildL.percentUnusedHeight*unallocatedHeight/newUnallocatedHeight;
						
					}
				}				
			}
			else{
				/*
				 * Right child is explicitly sized , left is percent sized
				 */ 
				bottomUIC.height-=delta;
				newUnallocatedHeight = unallocatedHeight+delta;
				
				for(var k:int=0; k<contentPane.numChildren; k++){
					var currChild:MeasurableControl = contentPane.getChildAt(k) as MeasurableControl;
					if(dividers.indexOf(currChild) != -1) continue;
					if(currChild == bottomUIC) continue;
					if(currChild == topUIC){
						var newLH:Number = currChild.height+delta;
						topUIC.percentUnusedHeight = newLH*100/newUnallocatedHeight
					}
					else if(!isNaN(currChild.percentUnusedHeight)){
						currChild.percentUnusedHeight = currChild.percentUnusedHeight*unallocatedHeight/newUnallocatedHeight;
					}
				}
			}	
		}
		
		override public function set layout(l:ILayout):void{
			throw new Error(getQualifiedClassName(this)+" cannot have layouts applied to it")
		}
		
	}
}