package org.openPyro.charts
{
	import org.openPyro.controls.List;
	
	import flash.display.DisplayObject;
	
	public class HBarChart extends List
	{
		
	public function HBarChart(){
			super();
			
			//this.layout = new VLayout();
		}
		
		private var _yField:String = "value";
		public function set yField(fieldName:String):void
		{
			_yField = fieldName;
		}
		
		private var maxYValue:Number = 0;
		override public function set dataProvider(dpObject:Object):void
		{	
			
			var dp:Array = dpObject as Array;
			for(var i:uint=0; i<dp.length; i++)
			{
				var object:Object = dp[i];
				try
				{
					var yfValue:Number = Number(object[_yField])
					if(yfValue > maxYValue){
						maxYValue = yfValue;
					}
				}
				catch(e:Error)
				{
					continue;	
				}
			}
			super.dataProvider = dp;
		}
		
		override protected function setRendererData(renderer:DisplayObject, data:Object, index:int):void
		{
			super.setRendererData(renderer, data, index);
			if(renderer is IVerticalChartItemRenderer)
			{
				IVerticalChartItemRenderer(renderer).maxYValue = this.maxYValue;
			}
		}

	}
}