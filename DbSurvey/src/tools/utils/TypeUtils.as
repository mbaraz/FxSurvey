package tools.utils
{
	import vo.QuestionTypes;
	import vo.SurveyQuestion;

	public class TypeUtils
	{
		public static function changeType(question : SurveyQuestion, previousQuestionType : String) : void {
			var type : QuestionTypes = QuestionTypes.getTypeByName(question.QuestionType);
			if (type.isPluralOnly)
				question.MultipleAnswerAllowed = true;
			else if (type.isSinglelOnly)
				question.MultipleAnswerAllowed = false;
//				setSingleAnswersCount(question);
			
			if (question.isCompositeQuestion) {
				if (!question.subitems.length)
					question.QuestionText += SurveyQuestion.Default_Text_Delimiter;
				
				if (question.isAnswersNeeded) {
					question.MaxAnswers = question.subitems.length;
					question.MinAnswers = Math.max(question.MinAnswers, SurveyQuestion.Default_Min_Answers);
//					question.MaxRank = question.MaxAnswers;
//					question.MinRank = SurveyQuestion.Default_Min_Answers;	//	question.MinAnswers;
				}
			}
			if (question.isRanked) {
				question.AnswersOrdering = SurveyQuestion.Answers_Order_Types[0];
				question.FilterAnswersTagId = 0;
				if (!question.isCompositeQuestion)
					question.MaxRank = Math.max(question.MaxRank, SurveyQuestion.Default_Min_Answers);
			}
/*
			if (question.isCompositeQuestion) {
				if (!question.subitems.length)
					question.QuestionText += SurveyQuestion.Default_Text_Delimiter;
// TEMP			
				question.MaxAnswers = question.subitems.length;
				question.MaxRank = question.subitems.length;
// TEMP	
			}
*/
			if (question.isGridQuestion || type == QuestionTypes.Simple || type == QuestionTypes.Summed) {
				setNoRanks(question);
				
				if (type == QuestionTypes.Summed)
					setMaxAnswersCount(question);
			}
		}

		private static function setMaxAnswersCount(question : SurveyQuestion) : void {
			question.MinAnswers = SurveyQuestion.Default_Min_Answers;
			question.MaxAnswers = SurveyQuestion.Default_Max_Answers;
		}
/*		
		private static function setSingleAnswersCount(question : SurveyQuestion) : void {
			question.MinAnswers = SurveyQuestion.Default_Min_Answers;
			question.MaxAnswers = SurveyQuestion.Default_Min_Answers;
		}
		
		private function setMaxRanksCount() : void {
			MinRank = Default_Min_Rank;
			MaxRank = Default_Max_Rank;
		}
*/		
		private static function setNoRanks(question : SurveyQuestion) : void {
			question.MinRank = SurveyQuestion.Default_Min_Rank;
			question.MaxRank = SurveyQuestion.Default_Min_Rank;
		}
	}
}