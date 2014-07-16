package vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class QuestionModel
	{
		public static var deletedAnswerIds : Array = [];

		private var isRusty : Boolean;
		
		public var question : SurveyQuestion;
		public var answerVariants : ArrayCollection = new ArrayCollection();
		
		public function QuestionModel(obj : Object) {
			fill(obj);
		}

		public function correctOldVariants() : void {
			if (!isRusty)
				return;
			
			var cnt : int = 0;
			for each (var variant : AnswerVariant in answerVariants) {
				variant.AnswerCode = 0;
				variant.order = ++cnt;
			}
		}
		
		private function fill(obj : Object) : void {
			correctOldQuestion(obj);
			question =  obj && obj.Question ? new SurveyQuestion(obj.Question) : null;
			question.subitems = obj && obj.SubQuestions ? new ArrayCollection(convertToSubQuestions(obj.SubQuestions)) : null;;
			answerVariants = obj && obj.AnswerVariants ? new ArrayCollection(convertToVariants(obj.AnswerVariants)) : null;
		}
		
		private function convertToSubQuestions(arr : Array) : Array {
			for (var i : int = 0; i < arr.length; i++)
				arr[i] = new SubQuestion(arr[i]);
			return arr;
		}

		private function convertToVariants(arr : Array) : Array {
/* ?????????????????
			if (!arr.length)
				arr.push({SurveyQuestionId: question.SurveyQuestionId, AnswerText : AnswerVariant.GRID_VARIANT_DELIMITER, AnswerCode : 1, AnswerOrder : 1});
*/
			for (var i : int = 0; i < arr.length; i++)
				arr[i] = new AnswerVariant(arr[i]);
			return arr;
		}

		private function correctOldQuestion(obj : Object) : void {
			var question : Object = obj.Question;
			if (question.QuestionType)
				return;

			isRusty = true;
			if (question.MultipleAnswerAllowed && question.IsRankQuestion) {
//				question.QuestionType = QuestionTypes.RadioGrid.name;
				if (question.IsGridQuestion) {
					question.QuestionType = Math.random() < 1.1 ? 8 : 7;	//	QuestionTypes.SliderGrid.name : QuestionTypes.RadioGrid.name;
					return;
				}
				question.QuestionType = 7;	//	QuestionTypes.RadioGrid.name;
				question.subitems = makeSubitems(obj.AnswerVariants); 
				obj.AnswerVariants = makeVariants(question.MaxRank, question.SurveyQuestionId)
				return;
			}
			if (question.MultipleAnswerAllowed && !question.MaxAnswers)
				question.MaxAnswers = obj.AnswerVariants.length;
			
			question.QuestionType = 0;	//	QuestionTypes.Simple.name;
		}
		
		private function makeSubitems(answerVariants : Object) : Array{
			var result : Array = [];
			for each (var variant : Object in answerVariants) {
				deletedAnswerIds.push(variant.AnswerVariantId);
				result.push({QuestionText : variant.AnswerText, SubOrder : variant.AnswerCode, SurveyQuestionId : variant.SurveyQuestionId});
			}
			return result;
		}

		private function makeVariants(maxRank : int, questionId : int) : Array {
			var result : Array = [];
			for (var i : int = 1; i <= maxRank; i++)
				result.push({SurveyQuestionId: questionId, AnswerText : i, AnswerCode : i, AnswerOrder : i});
			
			result.push({SurveyQuestionId: questionId, AnswerText : "Затрудняюсь ответить", AnswerCode : -1, AnswerOrder : maxRank + 1});
			return result;
		}
	}
}