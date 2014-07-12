package vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ConditionTag extends EventDispatcher
	{
		[Bindable]
		public var expressionsArray : Array = [];	/*	Of LogicalExpressions	*/
		
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
				expressionsArray.push(new LogicalExpression(tmp));
			}
		}
	}
}