package tools.utils
{
	import mx.resources.ResourceManager;
	
	public class LocaleUtils
	{
		public static function setLocale(isDefaultLocale : Boolean = true) : void {
			if (isDefaultLocale)
				currentLocale = "ru_RU";
			else
				currentLocale = "en_US";
		}

		private static function set currentLocale(locale : String) : void {
			trace("currentLocale: "+currentLocale+" locale: "+locale);
			if (currentLocale == locale)
				return;
			trace("setLocale1: "+ResourceManager.getInstance().localeChain[0]);
			if (isLocaleExist(locale))
				ResourceManager.getInstance().localeChain = [locale];
			trace(currentLocale+" currentLocale: "+ResourceManager.getInstance().localeChain[0]);
		}
		
		private static function get currentLocale() : String {
			return ResourceManager.getInstance().localeChain[0];
		}
		
		private static function isLocaleExist(locale : String) : Boolean {
			var existLocales : Array /* of String */ = ResourceManager.getInstance().getPreferredLocaleChain();
			if (existLocales.indexOf(locale) >= 0)
				return true;

			return false;
		}
	}
}