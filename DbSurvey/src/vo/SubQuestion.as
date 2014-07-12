package vo
{
	public class SubQuestion extends QuestionItem
	{
		public static const Delimiter : String = ".";
		public var SubQuestionId : int;

		public function SubQuestion(obj : Object) {
			if (obj)
				super(obj);
		}
		
		internal static function getEmptySubQuestion(order : int, parentId : int) : SubQuestion {
			return new SubQuestion({QuestionText : "", SubOrder : order, SurveyQuestionId : parentId});
		}
		
		override protected function fill(obj : Object) : void {
			super.fill(obj);
			SubQuestionId = obj.SubQuestionId;
			order = obj.SubOrder;
		}

		override public function get questionObject() : Object {
			var obj : Object = super.questionObject;
			obj.SubQuestionId = SubQuestionId;
//			obj.QuestionName = "Q" + SurveyQuestionId + Delimiter + order;	//	QuestionName;
			obj.SubOrder = order;
			return obj;
		}
	}
}