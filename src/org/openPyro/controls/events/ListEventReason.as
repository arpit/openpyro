package org.openPyro.controls.events
{
	/**
	 * The ListEventReason class enumerates the causes for a ListEvent
	 * to be dispatched.
	 */ 
	public class ListEventReason
	{
		public static const USER_ACTION:String = "userAction";
		public static const DATAPROVIDER_UPDATED:String = "dataProviderUpdated";
		public static const OTHER:String = "other";
		
		public function ListEventReason()
		{
		}

	}
}