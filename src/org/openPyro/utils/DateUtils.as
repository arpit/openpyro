package org.openPyro.utils{
	public class DateUtils{
		
		public static var shortMonthNames:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
		
		public static var monthNames:Array = ["January","Febuary","March","April","May","June","July","August","September","October","November","December"]
		
		public static var dayShortNames:Array = ["Sun","Mon", "Tue","Wed","Thurs","Fri","Sat"]
		
		public static function getShortMonthName(monthIndex:int):String{
			return shortMonthNames[monthIndex];
		}
		
		public static function getShortDayName(dayIndex:int):String{
		    return dayShortNames[dayIndex]
		}

	}
}