package data
{
	import events.QuestionServerEvent;
	import servers.IServer;

	public class DataManager
	{
		private var dataStorage : DataStorage;
		private var server : IServer;
		private var isEmulated : Boolean;

		public function DataManager(storage : DataStorage, server :IServer,	isEmulated : Boolean) {
			dataStorage = storage;
			this.server = server;
			dataStorage.projectId = server.projectId;
			this.isEmulated = isEmulated;
			configureServerListeners();
		}

		public function getAllQuestions() : void {
			server.getAllQuestion();
		}
		
		public function nextQuestion() : void {
			server.sendAndLoad(dataStorage.responseObject);
/*			if (isEmulated)
				getEmulatorQuestion();*/
		}
		
		public function previousQuestion(order : int) : void {
			dataStorage.goToPrevious();
		}
		
		public function saveAll() : void {
			var modelsArray : Array = dataStorage.modelsArray;
			var deletedQuestionIds : Array = dataStorage.deletedQuestionIds;
			var deletedSubQuestionIds : Array = dataStorage.deletedSubQuestionIds;
			var deletedAnswerIds : Array = dataStorage.deletedAnswerIds;
			var deletedTagIds : Array = dataStorage.deletedTagIds;
			server.saveAll(modelsArray, deletedQuestionIds, deletedAnswerIds, deletedSubQuestionIds, deletedTagIds);
		}
		
		public function test(order : int) : void {
			server.testFromOrder(order);
		}

		private function configureServerListeners() : void {
			server.addEventListener(QuestionServerEvent.ADD_QUESTION, addQuestionHandler);
			server.addEventListener(QuestionServerEvent.ADD_ALL_QUESTIONS, addAllQuestionsHandler);
			server.addEventListener(QuestionServerEvent.SAVE_ALL_QUESTIONS, saveAllQuestionsHandler);
		}
		
		private function addQuestionHandler(event : QuestionServerEvent) : void {
			dataStorage.goToNext(event.jsonArray[0]);
		}

		private function addAllQuestionsHandler(event : QuestionServerEvent) : void {
			dataStorage.addAllQuestionsHandler(event.jsonArray);
		}

		private function saveAllQuestionsHandler(event : QuestionServerEvent) : void {
			dataStorage.saveAllQuestionsHandler();	//	addAllQuestionsHandler(event.jsonArray);
			getAllQuestions(); // ???
		}
// EMULATOR	 LOOK
/*		private function getEmulatorQuestion() : void {
			var currentOrder : int = dataStorage.currentOrder;
			var jsonQuestion : Object = server.getQuestion(currentOrder++);
			while (jsonQuestion && !dataStorage.checkConditionOnTag(jsonQuestion.Question))	// !dataStorage.checkConditionOnTag(jsonQuestion.Question)
				jsonQuestion = server.getQuestion(currentOrder++);
			
			dataStorage.goToNext(jsonQuestion);
		}*/
	}
}