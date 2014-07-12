package components.validators
{
	import mx.validators.StringValidator;
	import mx.validators.ValidationResult;
	
	public class RankValidator extends StringValidator
	{
		private static var excludeSymbols : Array;
		public static var areSymbolsInvalid : Array;
		
		private static var _maxToRank : int;	// maxToRate < 10 !!!
		
		public  static function set maxToRank(value : int) : void {
			_maxToRank = value;
		}
		
		private static var _isRanked : Boolean;
		
		public static function set isRanked(value : Boolean) : void {
			_isRanked = value;
			excludeSymbols = [];
			areSymbolsInvalid = [];
		}
		
		private var _itemIndex : int;
		
		public function set itemIndex(value : int) : void {
			_itemIndex = value;
		}

		public static function get answersCount() : int {
			var result : int = 0;
			for (var i : int = 0; i < excludeSymbols.length; i++)
				if (excludeSymbols[i])
					result++;
			
			return result;
		}
		
		public static function get invalidAnswerNumber() : int {
			return areSymbolsInvalid.indexOf(true);
		}
		
		public static function get breachContinuity() : Boolean {
			var max : int = answersCount;
			for (var i : int = 0; i < excludeSymbols.length; i++)
				if (excludeSymbols[i] > max)
					return true;
			
			return false;
		}
		
		public static function reset(maxRank : int, isRank : Boolean) : void {
			maxToRank = maxRank;
			isRanked = isRank;	 // false - Рейтиг (rating) – то же, но оценки могут повторяться
		}
		
		public static function areSymbolValid(itemIndex : int) : Boolean {
			return !areSymbolsInvalid[itemIndex];
		}
		
		override protected function doValidation(value : Object) : Array {
			var results : Array = super.doValidation(value);
			excludeSymbols[_itemIndex] = null;
			areSymbolsInvalid[_itemIndex] = false;
			if (!value)
				return results;

			var message : String;
			var char : String = value.toString();
			if (isOutOfRank(char))
				message = "Недопустимый символ";
			else if (_isRanked && isDigitRepeated(char))
				message = "Попытка ввода уже существующего номера";

			if (message) {
				results.push(new ValidationResult(true, "", "requiredField", message));
				areSymbolsInvalid[_itemIndex] = true;
			} else
				excludeSymbols[_itemIndex] = char;

			return results;
		}
		
		private function isOutOfRank(char : String) : Boolean {
			var digit : int = int(char);
			return !digit || digit < 1 || digit > _maxToRank;
		}
		
		private function isDigitRepeated(char : String) : Boolean {
			var indx : int = excludeSymbols.indexOf(char);
			return indx > -1; 	//  && indx != _itemIndex;
		}
	}
}