package vo
{
	import tools.utils.LogicalUtils;

	public class TagCondition
	{
		private static const Delimiter : String = " "; 

		private var index : int = 0;
		private var condition : String;
		private var conditionsArray : Array;
		
		private var _questionOrders : Array;
		
		public function get questionOrders() : Array {
			return _questionOrders;
		}

		private var _logicalResult : Boolean;
		
		public function get logicalResult() : Boolean {
			return _logicalResult;
		}
		
		private function get syndetic() : String {
			return getConditionByIndex(index)[0];
		}
		
		private function get sign() : String {
			return getConditionByIndex(index)[2];
		}
		
		private function get value() : int {
			return getConditionByIndex(index)[3];
		}

		public function TagCondition(conditionOnTag : String) {
			condition = conditionOnTag;
			makeConditionsAndOrdersArrays(condition.split(Delimiter));
		}
/* FOR SURVEY EMULATOR */
		public function checkCondition(codesArray : Array) : void {
			var result : Boolean = LogicalUtils.checkInequality(sign, codesArray, value);
			_logicalResult = LogicalUtils.checkSyndetic(syndetic, _logicalResult, result);
			index++;
		}

		private function getQuestionByIndex(indx : int) : String {
			var questionName : String = getConditionByIndex(indx)[1];
			return questionName.substring(1);
		}

		private function getConditionByIndex(indx : int) : Array {
			return conditionsArray[indx];
		}

		private function makeConditionsAndOrdersArrays(arr : Array) : void {
			conditionsArray = [];
			_questionOrders = [];
			if (!arr.length)
				return;
			
			arr.unshift(LogicalExpression.Syndetics[0]);
			for (var i : int = 0; i < arr.length; i += 4) {
				var tmp : Array = arr.slice(i, i + 4);
				conditionsArray.push(tmp);
				_questionOrders.push(tmp[1].substring(1));
			}
		}
	}
}