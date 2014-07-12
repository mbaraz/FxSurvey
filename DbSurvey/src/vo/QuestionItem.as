package vo
{
	public class QuestionItem
	{
		[Bindable]
		public var order : int;
		[Bindable]
		public var tagCondition : ConditionTag = new ConditionTag();
		
		protected var _questionText : String;

		public function get QuestionText() : String {
			return _questionText;
		}

		public function set QuestionText(value : String) : void {
			_questionText = value;
		}

		public var SurveyQuestionId : int;

		public function get hasBoundTag () : Boolean {
			return Boolean(BoundTagId);
		}
		
		private var _boundTagId : int;
		
		[Bindable]
		public function get BoundTagId() : int {
			return _boundTagId;
		}
		
		public function set BoundTagId(value : int) : void {
			_boundTagId = value;
/*			if (isSelected)
				AnswerVariant.hasBoundTag = Boolean(value);*/
		}
		protected function set ConditionString(value : String) : void {
			tagCondition.updateArrays(value);
		}

		public function QuestionItem(obj : Object) {
			if (obj)
				fill(obj);
		}

		public function get questionObject() : Object {
			var obj : Object = new Object();
			obj.SurveyQuestionId = SurveyQuestionId;
			obj.QuestionText = QuestionText;
			obj.BoundTagId = BoundTagId;
			obj.ConditionString = tagCondition.conditionString;
			return obj;
		}

		protected function fill(obj : Object) : void {
			SurveyQuestionId = obj.SurveyQuestionId;
			QuestionText = obj.QuestionText;
			BoundTagId = obj.BoundTagId;
			ConditionString = obj.ConditionString;
		}
	}
}