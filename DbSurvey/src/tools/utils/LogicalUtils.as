package tools.utils
{
	public class LogicalUtils
	{
		private static const Signs : Array = ["=", "≠", ">", "<", "≥", "≤"];
		private static const Syndetics : Array = ["", "И", "ИЛИ"];

		public static function checkInequality(sign : String, codesArray : Array, value : int) : Boolean {
			var signIndex : int = Signs.indexOf(sign);
			var result : Boolean;
			switch (signIndex) {
				case 0 :
					result = checkET(codesArray, value);
					break;
				case 1 :
					result = checkNET(codesArray, value);
					break;
				case 2 :
					result = checkGT(codesArray, value);
					break;
				case 3 :
					result = checkLT(codesArray, value);
					break;
				case 4 :
					result = checkNLT(codesArray, value);
					break;
				case 5 :
					result = checkNGT(codesArray, value);
			}
			return result;
		}
		
		public static function checkSyndetic(syndetic : String, result : Boolean, value : Boolean) : Boolean {
			var syndeticIndex : int = Syndetics.indexOf(syndetic);
			switch (syndeticIndex) {
				case 0 :
					result = value;
					break;
				case 1 :
					result &&= value;
					break;
				case 2 :
					result ||= value;
			}
			return result;
		}
		
		public static function checkGT(arr : Array, value : int) : Boolean {
			return !arr.length || arr[arr.length - 1] > value;
		}
		
		public static function checkNLT(arr : Array, value : int) : Boolean {
			return !arr.length || arr[arr.length - 1] >= value;
		}
		
		public static function checkLT(arr : Array, value : int) : Boolean {
			return !arr.length || arr[0] < value;
		}
		
		public static function checkNGT(arr : Array, value : int) : Boolean {
			return !arr.length || arr[0] <= value;
		}
		
		public static function checkET(arr : Array, value : int) : Boolean {
			var result : Boolean = false;
			for (var i : int = 0; i < arr.length && !result; i++) {
				if (value < arr[i])
					break;
				result = arr[i] == value;
			}
			return !arr.length || result;
		}
		
		public static function checkNET(arr : Array, value : int) : Boolean {
			return !arr.length || !checkET(arr, value);
		}
		
		private function findIndex(arr : Array, value : String) : int {
			var result : int = 0;
			while (arr[result] != value)
				result++;
			return result;
		}
	}
}