package vo
{
	import flash.utils.Dictionary;
	
	public class LogicalExpression
	{
		public static const Delimiter : String = " "; 
		public static const Syndetics : Array = ["", "И", "ИЛИ"];
		public static const Signs : Array = ["=", "≠", ">", "<", "≥", "≤"];
		
//		public static var tagsDictionary : Dictionary = new Dictionary();
		
		[Bindable]
		public var syndetic : String;

		[Bindable]
		public var sign: String;
		[Bindable]
		public var value : int;
/*		[Bindable]
		public var tag : Tag;*/
		[Bindable]
		public var tagId : int;
/*		public var questionOrder : int;
		
		public function get questionName(): String {
			return tag.TagName;
		}
*/
		public function LogicalExpression(arr : Array) {
			syndetic = arr[0];
//			tag = tagsDictionary[arr[1]];
			tagId = arr[1];
//			questionName = tagId ? TagStorage.boundedTags[tagId] : "";
//			questionOrder = int(questionName.substring(1));
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