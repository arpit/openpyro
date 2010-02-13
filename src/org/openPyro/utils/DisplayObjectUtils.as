package org.openPyro.utils
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	public class DisplayObjectUtils
	{
		public function DisplayObjectUtils(){
		}
		
		public static function center(tgt:DisplayObject, container:DisplayObject=null):void{
			if(container){
				tgt.x = (container.width - tgt.width)/2;
				tgt.y = (container.height - tgt.height)/2;
			}
			else{
				tgt.x = (tgt.stage.stageWidth - tgt.width)/2;
				tgt.y = (tgt.stage.stageHeight - tgt.height)/2;
			}
		}
		
		public static function bringToFrontRecursively(child:DisplayObject):void{
			child.parent.setChildIndex(child, child.parent.numChildren-1);
			if(child.parent == child.root) return;
			bringToFrontRecursively(child.parent);
		}
		
		public static function bringToFront(child:DisplayObject):void{
			child.parent.setChildIndex(child, child.parent.numChildren-1);
		}

	}
}