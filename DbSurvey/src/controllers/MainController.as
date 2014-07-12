package controllers
{
	import data.DataManager;
	import events.QuestionEvent;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class MainController
	{
		private var dataManager : DataManager;
		private var view : IEventDispatcher;
		
		public function MainController(main : IEventDispatcher, dataManager : DataManager) {
			view = main;
			this.dataManager = dataManager;
			init();
		}
		
		private function init() : void {
			configureListeners();
		}
		
		protected function configureListeners() : void {
			view.addEventListener(QuestionEvent.GET_ALL_QUESTIONS, getQuestionEventHandler);
			view.addEventListener(QuestionEvent.NEXT_QUESTION, nextQuestionEventHandler);
			view.addEventListener(QuestionEvent.PEVIOUS_QUESTION, previousQuestionEventHandler);
			view.addEventListener(QuestionEvent.SAVE_ALL_QUESTIONS, saveAllHandler);
			view.addEventListener(QuestionEvent.TEST_FROM_QUESTION, testHandler);
		}
		
		private function getQuestionEventHandler(event : QuestionEvent) : void {
			dataManager.getAllQuestions();
		}
		
		private function nextQuestionEventHandler(event : QuestionEvent) : void {
			dataManager.nextQuestion();
		}
		
		private function previousQuestionEventHandler(event : QuestionEvent) : void {
			dataManager.previousQuestion(event.questionOrder);
		}
		
		private function saveAllHandler(event : QuestionEvent) : void {
			dataManager.saveAll();
		}

		private function testHandler(event : QuestionEvent) : void {
			dataManager.test(event.questionOrder);
		}
	}
}