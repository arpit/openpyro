package org.openPyro.controls.skins
{
	import org.openPyro.skins.ISkin;
	
	public interface IComboBoxSkin extends ISkin
	{
		function get buttonSkin():ISkin;
		function get listSkin():ISkin;
	}
}