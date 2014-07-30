package vo
{
	import flash.utils.Dictionary;
	
	public class LogicalExpression
	{
		public static const Delimiter : String = " "; 
		public static const Syndetics : Array = ["", "И", "ИЛИ"];
		public static const Signs : Array = ["=", "≠", ">", "<", "≥", "≤"];
		
		[Bindable]
		public var syndetic : String;

		[Bindable]
		public var sign: String;
		[Bindable]
		public var value : int;
		[Bindable]
		public var tagId : int;

		public function LogicalExpression(arr : Array) {
			syndetic = arr[0];
			tagId = arr[1];
			sign = arr[2];
			value = arr[3];
		}
		
		public function toString() : String {
			return makeCondition(tagId.toString());
		}
		
		public function makeCondition(tagName : String) : String {
			return ["", syndetic, tagName, sign, value].join(Delimiter);
		}

		public static function createEmpty (conditionsLength : int) : LogicalExpression {
			return new LogicalExpression([conditionsLength ? Syndetics[1] : Syndetics[0], 0, Signs[0], 0]);
		}
	}
}