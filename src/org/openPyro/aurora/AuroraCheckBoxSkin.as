package org.openPyro.aurora
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.openPyro.controls.Button;
	import org.openPyro.controls.events.ButtonEvent;
	import org.openPyro.core.UIControl;
	import org.openPyro.events.PyroEvent;
	import org.openPyro.painters.GradientFillPainter;
	import org.openPyro.painters.Stroke;
	
	public class AuroraCheckBoxSkin extends AuroraPainterButtonSkin
	{
		
		/*
		The Folder Symbol is embedded in the graphic_assets.swc 
		generated from the graphics_assets.fla	
		*/
		private var TickGraphic:Class = checkIconSymbol;
		
		public function AuroraCheckBoxSkin()
		{
		}
		
		private var _checkIcon:DisplayObject
		
		public var cornerRadius:Number = 0
		public var boxLabelGap:Number = 10;
		
		public function set checkIcon(icon:DisplayObject):void{
			_checkIcon = icon
		}
		
		private var _uncheckIcon:DisplayObject
		public function set uncheckIcon(icon:DisplayObject):void{
			_uncheckIcon = icon;
		}
		
		override public function set skinnedControl(uic:UIControl):void
		{
			super.skinnedControl = uic
			if(creationCompleteFired){
				checkSelectedStatus()
			}
		}
		
		override protected function onSkinnedControlPropertyChange(event:PyroEvent):void{
			super.onSkinnedControlPropertyChange(event);
			checkSelectedStatus()
		}
		
		override protected function createChildren():void{
			super.createChildren();
			if(!_checkIcon){
				_checkIcon = createDefaultCheckIcon()
			}
			if(!_uncheckIcon){
				_uncheckIcon = createDefaultUnCheckIcon()	
			}
			checkSelectedStatus();
		}
		
		override public function changeState(fromState:String, toState:String):void
		{
			if(toState==ButtonEvent.UP)
			{
				this.backgroundPainter = upPainter;
			}
			
			else if(toState==ButtonEvent.OVER)
			{
				this.backgroundPainter = overPainter;
			}
			
			else if(toState == ButtonEvent.DOWN)
			{
				this.backgroundPainter = downPainter;
				if(_skinnedControl is Button){
					var b:Button = _skinnedControl as Button;
					checkSelectedStatus()
				}
			}
			else
			{
				this.backgroundPainter = upPainter;
			}
		}
		
		protected function checkSelectedStatus():void{
			if(Button(_skinnedControl).toggle){
				if(Button(_skinnedControl).selected){
					_checkIcon.visible = true
					_uncheckIcon.visible = false;
				}
				else {
					_uncheckIcon.visible = true
					_checkIcon.visible=false
				}
			}
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(!label){
				_checkIcon.x = (unscaledWidth-_checkIcon.width)/2;
				_uncheckIcon.x = 	(unscaledWidth-_uncheckIcon.width)/2
			}
			else{
				_checkIcon.x = _skinnedControl.padding.left;
				_checkIcon.y = (unscaledHeight-_checkIcon.height)/2;
				_uncheckIcon.x =  _skinnedControl.padding.left;;
				_uncheckIcon.y = (unscaledHeight-_uncheckIcon.height)/2;
				
				var checkIconW:Number = _checkIcon ? _checkIcon.width:0
				var uncheckIconW:Number = _uncheckIcon?_uncheckIcon.width:0
				label.x = Math.max(checkIconW, uncheckIconW)+boxLabelGap;
			}
		}
		
		protected function createDefaultUnCheckIcon():Sprite{
			var sp:Sprite = new Sprite()
			var gr:GradientFillPainter = new GradientFillPainter([0xffffff, 0xdddddd])
			gr.stroke = new Stroke(1,0x666666,1,true)
			gr.rotation = Math.PI/2
			gr.cornerRadius = cornerRadius
			gr.draw(sp.graphics, 15,15)
			addChild(sp)
			sp.cacheAsBitmap = true;
			return sp
		}
		
		protected function createDefaultCheckIcon():Sprite{
			var sp:Sprite = new Sprite()
			var gr:GradientFillPainter = new GradientFillPainter([0xffffff, 0xdddddd])
			gr.stroke = new Stroke(1,0x666666,1,true)
			gr.rotation = Math.PI/2
			gr.cornerRadius = cornerRadius
			gr.draw(sp.graphics, 15,15)
			addChild(sp)
			sp.cacheAsBitmap = true;
			var tick:DisplayObject = new TickGraphic()
			sp.addChild(tick)
			sp.mouseChildren=false;
			return sp
		}
	}
}