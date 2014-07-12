package events
{
	import flash.events.Event;
	
	public class QuestionServerEvent extends Event
	{
		public static const ADD_QUESTION : String = "addQuestion";
		public static const ADD_ALL_QUESTIONS : String = "addAllQuestions";
		public static const SAVE_ALL_QUESTIONS : String = "saveAllQuestions";

		private var _jsonArray : Array; /* of Object (jsonQuestion) */
		
		public function get jsonArray() : Array {
			return _jsonArray;
		}
		
		public function QuestionServerEvent(type : String, jsonArray : Array = null)
		{
			super(type);
			_jsonArray = jsonArray;
		}
	}
}