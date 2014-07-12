package components.temp
{
	import vo.AnswerVariant;
	import vo.SurveyQuestion;
	
	public class SelectedQuestion extends SurveyQuestion
	{
		public function SelectedQuestion(obj:Object)
		{
			super(obj);
		}
		
		override public function set QuestionType(value : String) : void {
			super.QuestionType = value;
			switch(value) {
				case "Summed": {
					MultipleAnswerAllowed = true;
					MinAnswers = 1;
					MaxAnswers = 12;
					break;
				}
				case "RadioGrid" :
				case "SliderGrid" :
				case "RadioRank" :
				case "SliderRank" : {
					MultipleAnswerAllowed = false;
					break;
				}
				case "Rating": 
				case "DragRank": {
					MultipleAnswerAllowed = true;
					break;
				}
			}
			AnswerVariant.QuestionType = QuestionType;
		}
		
		override public function set MultipleAnswerAllowed(value : Boolean) : void {
			super.MultipleAnswerAllowed = value;
			if (!MultipleAnswerAllowed) {
				MaxAnswers = 1;
				MinAnswers = 1;
			}
			AnswerVariant.MultipleAnswerAllowed = MultipleAnswerAllowed;
		}
	}
}