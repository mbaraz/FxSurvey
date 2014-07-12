package servers
{
	import com.adobe.serialization.json.*;
	import flash.events.*;
	import flash.net.*;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.utils.URLUtil;
	
	import events.QuestionServerEvent;
	
	public class MvcServer extends EventDispatcher implements IServer
	{
		private const URL_PREFIX : String = "http://";
		private const CONTROLLER_NAME : String = "/FlexData/";
		private const GET_ALL_QUESTIONS_URL : String = "GetAllQuestions";
		private const SEND_ALL_QUESTIONS_URL : String = "ReceiveAllQuestions";
		private const SEND_AND_LOAD_URL : String = "ReceiveAnswers";
		private const TEST_FROM_QUESTION_URL : String = "TestFromQuestion";
		
		private var _serverAddress : String;
		private var _startOrder : int;
		
		private var _projectId : int;
		
		public function get projectId() : int {
			return _projectId;
		}

		public function MvcServer(url : String, projectId : int, startOrder : int){
			_serverAddress = makeServerAddress(url);
			_projectId = projectId ? projectId : 1;
			_startOrder = startOrder;
		}
		
		public function getAllQuestion() : void {
			var variables : URLVariables = new URLVariables();
			variables.surveyProjectId = _projectId;
			
			var request : URLRequest = new URLRequest(URL_PREFIX + _serverAddress + CONTROLLER_NAME + GET_ALL_QUESTIONS_URL);
			request.method = URLRequestMethod.POST;
			request.data = variables;
			var loader : URLLoader = new URLLoader(request);
			
			loader.addEventListener(Event.COMPLETE, getAllQuestionComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, serverErrorHandler);
		}
		
		public function getQuestion(currentQuestionOrder : int) : Object {
			return null;
		}

		public function sendAndLoad(answers : Object) : void {
			var variables : URLVariables = new URLVariables();
			variables.surveyId = _projectId;
			variables.answers = com.adobe.serialization.json.JSON.encode(answers);
			variables.startOrder = _startOrder;
			
			var request : URLRequest = new URLRequest(URL_PREFIX + _serverAddress + CONTROLLER_NAME + SEND_AND_LOAD_URL);
			request.method = URLRequestMethod.POST;
			request.data = variables;
			var loader : URLLoader = new URLLoader(request);
			
			loader.addEventListener(Event.COMPLETE, sendAndLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, serverErrorHandler);
		}
		
		public function saveAll(models : Array, deletedQuestionIds : Array, deletedAnswerIds : Array, deletedSubQuestionIds : Array = null, deletedTagIds : Array = null) : void {
			var variables : URLVariables = new URLVariables();
			variables.surveyId = _projectId;
			variables.models = com.adobe.serialization.json.JSON.encode(models);
			variables.deletedQuestionIds = com.adobe.serialization.json.JSON.encode(deletedQuestionIds);
			variables.deletedSubQuestionIds = com.adobe.serialization.json.JSON.encode(deletedSubQuestionIds);
			variables.deletedAnswerIds = com.adobe.serialization.json.JSON.encode(deletedAnswerIds);
			variables.deletedTagIds = com.adobe.serialization.json.JSON.encode(deletedTagIds);

			var request : URLRequest = new URLRequest(URL_PREFIX + _serverAddress + CONTROLLER_NAME + SEND_ALL_QUESTIONS_URL);
			request.method = URLRequestMethod.POST;
			request.data = variables;
			var loader : URLLoader = new URLLoader(request);
			
			loader.addEventListener(Event.COMPLETE, sendAllComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, serverErrorHandler);
		}
		
		public function testFromOrder(order : int) : void {
			var url:String = URL_PREFIX + _serverAddress + CONTROLLER_NAME + TEST_FROM_QUESTION_URL;
			var variables : URLVariables = new URLVariables();
			variables.questionOrder = order;
			variables.surveyProjectId = _projectId;
			var request : URLRequest = new URLRequest(url);
			request.data = variables;
			navigateToURL(request, "Anketa");
		}
		
		private function makeServerAddress(url : String) : String {
			var serverName : String = URLUtil.getServerNameWithPort(url);
			var token : String = url.split(serverName + "/")[1].split("/")[0];
			var address : String = token != "Content" ? serverName + "/" + token : serverName;
			return address != "/" ? address : "localhost:56773";	//	"opros.spbu.ru";	//	"localhost:50784";
		}

		private function sendAndLoadComplete(event : Event) : void {
			var jsonModel : Object = null;
			try {
				jsonModel = com.adobe.serialization.json.JSON.decode(event.target.data);
			} catch(e : JSONParseError) {
				showMessage(e.text);
			}
			dispatchEvent(new QuestionServerEvent(QuestionServerEvent.ADD_QUESTION, [jsonModel]));
		}
		
		private function getAllQuestionComplete(event : Event) : void {
			var jsonQuestionArray : Array = [];
			try {
				jsonQuestionArray = com.adobe.serialization.json.JSON.decode(event.target.data);
			} catch(e : JSONParseError) {
				showMessage(e.text);
			}
			dispatchEvent(new QuestionServerEvent(QuestionServerEvent.ADD_ALL_QUESTIONS, jsonQuestionArray));
		}
		
		private function sendAllComplete(event : Event) : void {
			var msg : String = event.target.data;
			if (msg)
				showMessage(msg);
			else
				dispatchEvent(new QuestionServerEvent(QuestionServerEvent.SAVE_ALL_QUESTIONS));
		}
		
		private function serverErrorHandler(event : IOErrorEvent) : void {
			showAlert(ResourceManager.getInstance().getString('Main', 'server_failed', [_serverAddress]) + event.text + ResourceManager.getInstance().getString('Main', 'server_support'), ResourceManager.getInstance().getString('Main', 'server_connection'));
		}

		private function showMessage(message : String) : void {
			message += ": ";
			if (message.indexOf("Answer is not accepted") > -1)
				showAlert(ResourceManager.getInstance().getString('Main', 'server_noanswer'), ResourceManager.getInstance().getString('Main', 'server_error'));
			else if (message.indexOf("No project") > -1)
				showAlert(ResourceManager.getInstance().getString('Main', 'project_not_exist'), ResourceManager.getInstance().getString('Main', 'project_error'));
			else if (message.indexOf("No edit") > -1)
				showAlert(ResourceManager.getInstance().getString('Main', 'project_not_test_inerview'), ResourceManager.getInstance().getString('Main', 'project_error'));
			else if (message.indexOf("System error") > -1)
				showAlert(message + ResourceManager.getInstance().getString('Main', 'server_support'), ResourceManager.getInstance().getString('Main', 'server_error'));
			else if (message.indexOf("Can't save all") > -1)
				showAlert(message + ResourceManager.getInstance().getString('Main', 'server_not_saved_all'), ResourceManager.getInstance().getString('Main', 'server_error'));
			else if (message.indexOf("No interview") > -1)
				showAlert(message + ResourceManager.getInstance().getString('Main', 'project_no_interview'), ResourceManager.getInstance().getString('Main', 'project_error'));
			else if (message.indexOf("No question") > -1)
				showAlert(message + ResourceManager.getInstance().getString('Main', 'project_no_question'), ResourceManager.getInstance().getString('Main', 'project_error'));
			else if (message.indexOf("No answers") > -1)
				showAlert(message + ResourceManager.getInstance().getString('Main', 'project_no_answers'), ResourceManager.getInstance().getString('Main', 'project_error'));
			else if (message.indexOf("By") == -1)
				showAlert(ResourceManager.getInstance().getString('Main', 'server_unavailable', [_serverAddress]), ResourceManager.getInstance().getString('Main', 'server_connection'));
		}
		
		private function showAlert(text : String, title : String) : void {
			Alert.show(text, title);
		}
	}
}