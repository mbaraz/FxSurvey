package vo
{
	[Bindable]
	public class AnswerVariant
	{
		public static const GRID_VARIANT_DELIMITER : String = ",";
		
		public static var QuestionType : String;
		public static var MultipleAnswerAllowed : Boolean;
		public static var MaxAnswers : int;
		public static var MinAnswers : int;
		public static var IsRankQuestion : Boolean;
		public static var MaxRank : int;
		public static var MinRank : int;
		public static var hasBoundTag : Boolean;
		public static var isFiltered : Boolean;
		public static var isStandartOrder : Boolean;

		public var AnswerVariantId : int;
		public var SurveyQuestionId : int;
		public var AnswerText : String;
		public var IsOpenAnswer : Boolean;
		public var IsExcludingAnswer : Boolean;
		public var SymbolCount : int;
		public var IsNumeric : Boolean;
		public var IsUnmoved : Boolean;
		public var IsSelected : Boolean;
		public var TagValue : String;
		public var order : int;
		
		private var _answerCode : int;
		
		public function set AnswerCode(value : int) : void {
			_answerCode = value;
		}
		
		public function get AnswerCode() : int {
			return _answerCode ? _answerCode : order;
		}

		private var _value : String = "";
		
		public function get Value() : String {
			return _value;
		}
		
		public function set Value(value : String) : void {
			_value = value;
			IsSelected = Boolean(value);
		}
		
		public function get variantObject() : Object {
			var obj : Object = new Object();
			obj.AnswerVariantId = AnswerVariantId;
			obj.SurveyQuestionId = SurveyQuestionId;
			obj.AnswerText = AnswerText;
			obj.IsOpenAnswer = IsOpenAnswer;
			obj.IsExcludingAnswer = IsExcludingAnswer;
			obj.AnswerCode = AnswerCode;
			obj.AnswerOrder = order;
			obj.SymbolCount = SymbolCount;
			obj.IsNumeric = IsNumeric;
			obj.IsUnmoved = IsUnmoved;
			obj.TagValue = TagValue;	// AnswerCode;	//	TagValue == "Нет" ? null : ;	??????
			return obj;
		}

		public function AnswerVariant(obj : Object) {
			AnswerVariantId = obj.AnswerVariantId;
			SurveyQuestionId = obj.SurveyQuestionId;
			AnswerText = obj.AnswerText;
			IsOpenAnswer = obj.IsOpenAnswer;
			IsExcludingAnswer = obj.IsExcludingAnswer;
			order = obj.AnswerOrder;
			AnswerCode = obj.AnswerCode;
			SymbolCount = obj.SymbolCount;
			IsNumeric = obj.IsNumeric;
			IsUnmoved =  obj.IsUnmoved;
			TagValue = obj.TagValue;	// !obj.TagValue ? "Нет" : obj.TagValue;
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
		
		public function get Response() : int {
			if (!IsSelected)
				return 0;
			return Type.hasNoAnswers ? int(Value) : AnswerCode;
		}
		
		public function updateResponse(response : Object) : void {
			if (!IsSelected)
				return;
			
			response.QuestionId = SurveyQuestionId;
			if (AnswerVariant.IsRankQuestion && Value) {
				addRanks(response);
				return;
			}
			response.Answers.push(AnswerCode);
			if (IsOpenAnswer)
				response.OpenAnswers.push([AnswerCode, Value]);
		}
		
		public static function SetQuestionParameters(obj : Object) : void {
			if (!obj)
				return;
			MultipleAnswerAllowed = obj.MultipleAnswerAllowed;
			QuestionType = obj.QuestionType;
			IsRankQuestion  = obj.IsRankQuestion;
			MinRank = obj.MinRank;
			MaxRank = obj.MaxRank;
			MaxAnswers = obj.MaxAnswers;
			MinAnswers = obj.MinAnswers;
			hasBoundTag = obj.hasBoundTag;
			isFiltered = Boolean(obj.FilterAnswersTagId);
			isStandartOrder = obj.isStandartOrder;
		}
		
		public static function get Type() : QuestionTypes {
			return QuestionTypes.getTypeByName(QuestionType);
		}
		
		public static function getEmptyVariant(order : int) : AnswerVariant {
			return new AnswerVariant({AnswerText: "", TagValue : order, AnswerOrder: order, IsOpenAnswer: Type.hasOpenAnswersOnly, IsNumeric: Type.hasNumericAnswersOnly});
		}
		
		private function addRanks(response : Object) : void {
			var values : Array = Value.split(GRID_VARIANT_DELIMITER);
			for each(var value : String in values) {
				response.Rank.push([value, AnswerCode]);
				response.Answers.push(value);
			}
		}
	}
}