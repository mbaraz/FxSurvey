package vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ConditionTag extends EventDispatcher
	{
		 private var _expressionsArray : Array = [];	/*	Of LogicalExpressions	*/
		 
		[Bindable]
		public function get expressionsArray() : Array {
			if (_expressionsArray.length)
				_expressionsArray[0].syndetic = LogicalExpression.Syndetics[0];
			
			return _expressionsArray;
		}
		
		public function set expressionsArray(value : Array) : void {
			_expressionsArray = value;
		}
		
		internal function get tagId() : int {
			return !expressionsArray.length ? 0 : (expressionsArray[0] as LogicalExpression).tagId;
		}
		
		internal function get tagValue() : int {
			return !expressionsArray.length ? 0 : (expressionsArray[0] as LogicalExpression).value;
		}

		public function get conditionString() : String {
			var result : String = "";
			for each (var expr : LogicalExpression in expressionsArray)
				result += expr.toString();
				
			return result.substring(2);
		}

		public function updateArrays(conditionOnTag : String) : void {
			if (!conditionOnTag)
				return;
			
			makeExpressionsArray(conditionOnTag.split(LogicalExpression.Delimiter));
		}

		private function makeExpressionsArray(arr : Array) : void {
			if (!arr.length)
				return;
			
			arr.unshift(LogicalExpression.Syndetics[0]);
			for (var i : int = 0; i < arr.length; i += 4) {
				var tmp : Array = arr.slice(i, i + 4);
				_expressionsArray.push(new LogicalExpression(tmp));
			}
		}
	}
}