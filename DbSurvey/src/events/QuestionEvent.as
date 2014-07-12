package events
{
	import flash.events.Event;
	
	public class QuestionEvent extends Event
	{
		public static const GET_ALL_QUESTIONS : String = "getAllQuestions";
		public static const SAVE_ALL_QUESTIONS : String = "saveAllQuestions";
		public static const NEXT_QUESTION : String = "nextQuestion";
		public static const PEVIOUS_QUESTION : String = "previousQuestion";
		public static const TEST_FROM_QUESTION : String = "testFromQuestion";
		
		private var _questionOrder : int;
		
		public function get questionOrder() : int {
			return _questionOrder;
		}
		
		public function QuestionEvent(type : String, order : int = 0)
		{
			super(type, true);
			_questionOrder = order;
		}
		
		override public function clone() : Event {
			return new QuestionEvent(type, questionOrder);
		}
	}
}