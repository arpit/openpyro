package org.openPyro.containers
{
	import flash.display.DisplayObject;
	
	import gs.easing.Quart;
	
	import org.openPyro.core.Direction;
	import org.openPyro.core.UIContainer;
	import org.openPyro.effects.Effect;
	import org.openPyro.effects.EffectDescriptor;
	
	public class SlidePane extends ViewStack
	{
		 protected var _transitionDirection:String = Direction.HORIZONTAL;
		 protected var transitionDirectionMultiplier:int = 1;
		 
		 protected var _previouslySelectedChild:UIContainer = null;
		 protected var _previouslySelectedIndex:int = -1;
		 
		 public function SlidePane()
		 {
		 	super()
		 }
		 
		 /**
		 * Sets the direction for the transition among the different
		 * children of the SlidePane. The acceptable values are
		 * either Direction.HORIZONTAL or Direction.VERTICAL
		 */ 
		 public function set transitionDirection(dir:String):void
		 {
			 _transitionDirection = dir;
		 }
		 public function get transitionDirection():String
		 {
		 	return _transitionDirection;
		 }
		 
		 protected var _transitionDuration:Number = 1;
		 
		 /**
		 * The number of seconds for which the transition animation will
		 * run. Default is 1 second
		 */ 
		 public function set transitionDuration(numSeconds:Number):void
		 {
		 	_transitionDuration = numSeconds;
		 }
		 
		 public function get transitionDuration():Number
		 {
		 	return _transitionDuration;
		 }
		
		 override public function set selectedIndex(idx:int):void
		 {
		 	_previouslySelectedChild = _selectedChild
		 	_previouslySelectedIndex = _selectedIndex
		 	super.selectedIndex = idx;
		 }
		 
		 private var trans:Number = -1;
	   	 public function set transitionAttitude(_trans:Number):void
		 {
			 trans = _trans;
		 }
		 public function get transitionAttitude():Number
		 {
		 	return trans;
		 }		
		 
		 override protected function showSelectedChild():void
		 {
		 	
		 	if(_previouslySelectedIndex == -1)
		 	{
		 		super.showSelectedChild();
		 	}
		 	
		 	for(var i:uint=0; i<viewChildren.length; i++)
		 	{
				var child:DisplayObject = DisplayObject(viewChildren[i]);
				if(i == _selectedIndex)
				{
					child.visible = true;
					if(_previouslySelectedIndex < 0) return;
					
					if(i > _previouslySelectedIndex)
					{
						transitionDirectionMultiplier = trans* -1 ;
					}
					else
					{
						transitionDirectionMultiplier = trans* +1
					}
					break;
				}
			}
			
		
			//animate
			
			var oldViewEffectDescriptor:EffectDescriptor = new EffectDescriptor(_previouslySelectedChild, 1)
			var newViewEffectDescriptor:EffectDescriptor = new EffectDescriptor(_selectedChild, 1)
			
			if(_transitionDirection == Direction.HORIZONTAL){
				_selectedChild.x = -1*transitionDirectionMultiplier*this.width;
				oldViewEffectDescriptor.properties = {x:transitionDirectionMultiplier*this.width, ease:Quart.easeOut}
				newViewEffectDescriptor.properties = {x:0, ease:Quart.easeOut}	
			}
			else if(_transitionDirection == Direction.VERTICAL)
			{
				_selectedChild.y = -1*transitionDirectionMultiplier*this.height;
				oldViewEffectDescriptor.properties = {y:transitionDirectionMultiplier*this.height, ease:Quart.easeOut}
				newViewEffectDescriptor.properties = {y:0, ease:Quart.easeOut}
			}
			Effect.play(oldViewEffectDescriptor);
			Effect.play(newViewEffectDescriptor);
		 }
		 
	}
}
