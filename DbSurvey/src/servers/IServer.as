package servers
{
	public interface IServer
	{
		function get projectId() : int;
		function getAllQuestion() : void;
		function getQuestion(currentQuestionOrder : int) : Object;
		function sendAndLoad(answers : Object) : void;
		function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void;
		function saveAll(deletedQuestionIds : Array, deletedAnswerIds : Array, models : Array, deletedSubQuestionIds : Array = null, deletedTagIds : Array = null) : void;
		function testFromOrder(order : int) : void;
	}
}