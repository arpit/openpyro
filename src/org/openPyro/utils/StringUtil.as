package org.openPyro.utils{
	import flash.text.TextField;
	
	/**
	 * A collection of Utility methods for working with Strings
	 */
	public class StringUtil{
		/** 
		 * Check to see if the String is an empty string with one or more 
		 * whitespace characters or null. 
		 * Checks even for \n and \t values
		 */
		public static function isEmptyOrNull(str:String):Boolean{
			var pattern:RegExp = /^\s+$/;
	      	return pattern.test(str) == true ? true : str == "" || str == null;
	      }
	      
	 	public static function padLeading(s:String, n:Number, char:String = " "):String{
			var returnStr:String="";
			var diff:Number = n-s.length;
			
			for(var i:Number=0;i<diff; i++){
				returnStr += char
			} 
			returnStr+=s;
			return returnStr;
		}
	   
	   public static function padTrailing(s:String, n:Number, char:String = " "):String{
			var diff:Number = n-s.length;
			for(var i:Number=0;i<diff; i++){
				s += char
			} 
			return s;
		}
		
		public static function trim(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+|\s+$/g, '');
		}
		
		
		public static function toStringLabel(val:*):String{
			if(val is String){
				return val;
			}
			if(val is Number){
				return String(val);
			}
			
			var s:String
			try{
				s = val["label"];
			}
			catch(e:Error){
				s = "[Object]"
			}
			return s;
		}
		
		public static function omitWordsToFit(tf:TextField, indicator:String="..."):void
		{
			// truncate
	        var originalText:String = tf.text;

	        var h:Number = tf.height;
	        var w:Number = tf.width;
        	 
        	var theight:Number = tf.textHeight;
        	var twidth:Number = tf.textWidth; 
        	var s:String;     		
			
			/* added in a check against wordWrap, will omit words until fitting width*/
	        if(!tf.multiline && !tf.wordWrap){
	        	s = originalText.slice(0, Math.floor((w / tf.textWidth ) * originalText.length));
					
	            while (s && s.length > 1 && tf.textWidth > w)
	            {
	                s = s.slice(0, s.lastIndexOf(" "));
	                tf.text = s + indicator;
	            }
	        }
	        
	        // check against textWidth and textHeight, include styles
	        if(tf.textHeight > h)
	        {
	            // get close
	            s = originalText.slice(0, Math.floor((h / tf.textHeight ) * originalText.length));
					
	            while (s && s.length > 1 && tf.textHeight > h)
	            {
	                s = s.slice(0, s.lastIndexOf(" "));
	                tf.text = s + indicator;
	            }
	        }
		}
 	}
}