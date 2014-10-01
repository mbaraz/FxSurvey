package vo
{
	[Bindable]
	public class AnswerVariant
	{
		public static const VARIANTS_DELIMITER : String = "*";

		public static var Type : QuestionTypes;
		public static var MultipleAnswerAllowed : Boolean;
		public static var MaxAnswers : int;
		public static var MinAnswers : int;
		public static var MaxRank : int;
		public static var MinRank : int;
		public static var hasBoundTag : Boolean;
		public static var isFiltered : Boolean;
		public static var AnswersOrderingIndex : int;
		public static var isStandartOrder : Boolean;

		public static function getEmptyVariant(order : int) : AnswerVariant {
			return new AnswerVariant({AnswerText: "", TagValue : order, AnswerOrder: order, IsOpenAnswer: Type.hasOpenAnswersOnly, IsNumeric: Type.hasNumericAnswersOnly});
		}
		
		public static function get IsCompositeQuestion() : Boolean {
			return Type.isCompositeType;
		}
		
		public static function get IsRankQuestion() : Boolean {
			return Type.isRanked;
		}
		
		public static function get IsRatingQuestion() : Boolean {
			return Type.isRated;
		}

		private var SurveyQuestionId : int;
		
		public var AnswerVariantId : int;
		public var AnswerText : String;
		public var IsOpenAnswer : Boolean;
		public var IsExcludingAnswer : Boolean;
		public var SymbolCount : int;
		public var IsNumeric : Boolean;
		public var IsUnmoved : Boolean;
		public var IsSelected : Boolean;
		public var TagValue : String;
		public var order : int;

		private var _value : String = "";
		
		public function get Value() : String {
			return _value;
		}
		
		public function set Value(value : String) : void {
			_value = value;
			IsSelected = Boolean(value);
		}
		
		public function get splitValue() : Array {
			return Value.split(VARIANTS_DELIMITER);
		}
		
		public function get response() : int {
			if (!IsSelected)
				return 0;
			return Type.hasSingleAnswer ? int(Value) : order;
		}
		
		public function get variantObject() : Object {
			var obj : Object = new Object();
			obj.AnswerVariantId = AnswerVariantId;
			obj.SurveyQuestionId = SurveyQuestionId;
			obj.AnswerText = AnswerText;
			obj.IsOpenAnswer = IsOpenAnswer;
			obj.IsExcludingAnswer = IsExcludingAnswer;
			obj.AnswerCode = order;
			obj.AnswerOrder = order;
			obj.SymbolCount = SymbolCount;
			obj.IsNumeric = IsNumeric;
			obj.IsUnmoved = IsUnmoved;
			obj.TagValue = TagValue;
			return obj;
		}
		
		public function AnswerVariant(obj : Object) {
			AnswerVariantId = obj.AnswerVariantId;
			SurveyQuestionId = obj.SurveyQuestionId;
			AnswerText = obj.AnswerText;
			IsOpenAnswer = obj.IsOpenAnswer;
			IsExcludingAnswer = obj.IsExcludingAnswer;
			order = obj.AnswerOrder;
//			AnswerCode = order;	//	obj.AnswerCode;
			SymbolCount = obj.SymbolCount;
			IsNumeric = obj.IsNumeric;
			IsUnmoved =  obj.IsUnmoved;
			TagValue = obj.TagValue;
		}
		
		public function updateByQuestionType(type : String) : void {
			if (Type.hasOpenAnswersOnly)
				IsOpenAnswer = true;
			else if (Type.hasCloseAnswersOnly) {
				IsOpenAnswer = false;
				IsNumeric = false;
			}
			
			if (Type.hasNumericAnswersOnly)
				IsNumeric = true;
			/*			
			switch(type) {
			case "Summed" : {
			IsOpenAnswer = true;
			return false;
			}
			case "Rating" :
			case "Ranking" :
			case "DragRank" :
			case "RadioRank" :
			case "SliderRank" :
			case "RadioGrid" :
			case "SliderGrid" : {
			IsOpenAnswer = false;
			return false;
			}
			default :
			return true;
			}*/
		}
		
		public function updateByPlurality(isAllowed : Boolean) : void {
			if (!isAllowed)
				IsExcludingAnswer = false;
		}
		
		public function updateResponse(responseObj : Object) : void {
			if (!IsSelected)
				return;
			
			responseObj.QuestionId = SurveyQuestionId;
			if (IsRankQuestion && Value) {
				addRanks(responseObj);
				return;
			}
			responseObj.Answers.push(response);
			if (IsOpenAnswer)
				responseObj.OpenAnswers.push([order, Value]);	//	AnswerCode
		}
		
		public static function SetQuestionParameters(obj : Object) : void {
			if (!obj)
				return;
			MultipleAnswerAllowed = obj.MultipleAnswerAllowed;
			Type = QuestionTypes.getTypeByName(obj.QuestionType);
			MinRank = obj.MinRank;
			MaxRank = obj.MaxRank;
			MaxAnswers = obj.MaxAnswers;
			MinAnswers = obj.MinAnswers;
			hasBoundTag = obj.hasBoundTag;
			isFiltered = Boolean(obj.FilterAnswersTagId);
			AnswersOrderingIndex = obj.answersOrderIndex;
			isStandartOrder = obj.isStandartOrder;
		}

		private function addRanks(response : Object) : void {
			var values : Array = Value.split(VARIANTS_DELIMITER);
			for each(var value : String in values) {
				var respArray : Array = makeKeyValueResponse(value);
				response.Rank.push(respArray);
				response.Answers.push(respArray[0]);
			}
		}

		private function makeKeyValueResponse(strng : String) : Array {
			return  Type.hasSingleAnswer ? [order, strng] : [strng, order];	//	AnswerCode
		}
	}
}