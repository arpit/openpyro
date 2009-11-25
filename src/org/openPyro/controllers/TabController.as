package org.openPyro.controllers
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import org.openPyro.containers.ViewStack;
	import org.openPyro.core.UIContainer;

	/**
	 * The TabController class handles tabbing between different
	 * "tabs". A tab is a pair of button and an associated view.
	 */ 
	public class TabController
	{
		
		protected var tabs:Array;
		protected var _selectedTabViewPair:TabViewPair;
		
		public function TabController()
		{
			tabs = [];
		}
		
		protected var _viewStack:ViewStack;
		public function set viewStack(v:ViewStack):void{
			_viewStack = v;
		}
		
		public function addTab(tab:DisplayObject, view:DisplayObject):void{
			tabs.push(new TabViewPair(tab, view));
			tab.addEventListener(MouseEvent.CLICK, onTabClicked);
		}
		
		protected function onTabClicked(event:MouseEvent):void{
			var idx:int = indexOf(event.currentTarget as DisplayObject);
			if(idx == -1) return;
			
			if(_viewStack){
				_selectedTabViewPair = TabViewPair(tabs[idx]);
				_viewStack.selectedChild = UIContainer(_selectedTabViewPair.view);
			}
			else{
				if(_selectedTabViewPair){
					_selectedTabViewPair.view.visible = false;
				}
				
				_selectedTabViewPair = TabViewPair(tabs[idx]);
				_selectedTabViewPair.view.visible = true;
			}
		}
		
		/**
		 * Returns the index of a tab in the set of managed TabViewPair objects
		 */ 
		public function indexOf(tab:DisplayObject):int{
			for(var i:int=0; i<tabs.length; i++){
				if(tabs[i].button == tab){
					return i;
				}
			}
			return -1;
		}
	}
}
import flash.display.DisplayObject;

class TabViewPair{
	
	public var button:DisplayObject;
	public var view:DisplayObject;
	
	public function TabViewPair(button:DisplayObject, view:DisplayObject):void{
		this.button = button;
		this.view = view;
	}
}