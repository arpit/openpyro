package org.openPyro.charts
{
	import org.openPyro.controls.List;
	
	import flash.display.DisplayObject;
	
	public class VBarChart extends List
	{
		
	public function VBarChart(){
			super();
			
			//this.layout = new VLayout();
		}
		
		private var _xField:String = "value";
		public function set xField(fieldName:String):void
		{
			_xField = fieldName;
		}
		
		private var maxXValue:Number = 0;
		override public function set dataProvider(dpObject:Object):void
		{	
			
			var dp:Array = dpObject as Array;
			for(var i:uint=0; i<dp.length; i++)
			{
				var object:Object = dp[i];
				try
				{
					var xfValue:Number = Number(object[_xField])
					if(xfValue > maxXValue){
						maxXValue = xfValue;
					}
				}
				catch(e:Error)
				{
					trace("Could not find xValue value")
					continue;	
				}
			}
			super.dataProvider = dp;
		}
		
		override protected function setRendererData(renderer:DisplayObject, data:Object, index:int):void
		{
			super.setRendererData(renderer, data, index);
			if(renderer is IHorizontalChartItemRenderer)
			{
				IHorizontalChartItemRenderer(renderer).maxXValue = this.maxXValue;
			}
		}

	}
}