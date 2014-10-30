package data
{
	import data.storages.AnswerStorage;
	import data.storages.QuestionStorage;
	
	import mx.collections.ArrayCollection;
	
	import vo.AnswerVariant;
	import vo.QuestionModel;
	
	public class DataStorage
	{
		internal function get currentOrder() : int {
			var order : int = questionStorage.currentOrder;
			return order ? order : 0;
		}

		private var _questionStorage : QuestionStorage;

		public function get questionStorage() : QuestionStorage {
			return _questionStorage;
		}
		
		private var _answerStorage : AnswerStorage;

		public function get answerStorage() : AnswerStorage {
			return _answerStorage;
		}

		public function get modelsArray() : Array {
			var result : Array = [];
			for (var i : int = 0 ; i < questionStorage.questions.length; i++)
				result.push({Question: questionStorage.questionObjects[i], AnswerVariants: questionStorage.questions[i].isAnswersNeeded ? [] : answerStorage.answerObjects[i]});
			
			return result;
		}

		public function get responseObject() : Object {
			return answerStorage.responseObject; 
		}
		
		public function set projectId(value : int) : void {
			questionStorage.projectId = value;
		}

		public function get deletedQuestionIds() : Array {
			return questionStorage.deletedQuestionIds;
		}

		public function get deletedSubQuestionIds() : Array {
			return questionStorage.deletedSubQuestionIds;
		}

		public function get deletedAnswerIds() : Array {
			return answerStorage.deletedAnswerIds.concat(QuestionModel.deletedAnswerIds);
		}
		
		public function get deletedTagIds() : Array {
			return _questionStorage.deletedTagIds;
		}
		
		public function DataStorage() {
			_questionStorage = new QuestionStorage();
			_answerStorage = new AnswerStorage();
		}
/* FOR DESIGNER */	
		public function addNewQuestion() : void {
			var indx : int = questionStorage.addNew();
			if (indx > -1)
				answerStorage.addNewVariants(indx);
		}
		
		public function addNewVariant() : void {
			answerStorage.addNewVariant();
		}
		
		public function removeCurrentQuestionItem() : void {
			if (questionStorage.isSubitemSelected) {
				questionStorage.removeCurrentSubitem();
				return;
			}
			answerStorage.removeCurrentVariants();
			questionStorage.removeCurrentQuestion();
		}

		public function removeCurrentVariant() : void {
			answerStorage.removeSelectedVariant();
		}

		public function swapQuestions(isUp : Boolean) : Boolean {
			var result : Boolean = questionStorage.swap(isUp);
			if (result)
				answerStorage.swapVariants(isUp);
			
			return result;
		}
		
		public function swapVariants(isUp : Boolean) : void {
			answerStorage.swap(isUp);
		}

		public function getCodesArrayByTags(tags : Array) : Array {	/* of int */
			var result : Array = [];
			for (var i : int = 0; i < tags.length; i++)
				result.push(makeCodesArrayByQuestionOrder(tags[i].boundedQuestionOrder));
			
			return result;
		}
		
		public function getCodesArrayByTagId(tagId : int) : Array {	/* of int */
			if (!tagId)
				return [];
			
			return makeCodesArrayByQuestionOrder(_questionStorage.getTagById(tagId).boundedQuestionOrder);
		}
		
		public function getTagArray(max : int) : Array {	/* of SurveyQuestions and SubQuestion */
			return questionStorage.getTagArray(max);
		}
		
		public function updateByQuestionType() : void {
			var previousQuestionType : String = questionStorage.previousQuestionType;
			questionStorage.updateByQuestionType();
/*			if (!AnswerVariant.Type.isCompositeType)
				questionStorage.removeCurrentSubitems();*/
			if (AnswerVariant.Type.isContradictory(previousQuestionType))
				answerStorage.emptyCurrentVariants();
			else
				answerStorage.updateVariantsByQuestionType(questionStorage.currentQuestion.QuestionType);
		}
		
		internal function addAllQuestionsHandler(jsonArray : Array) : void {
			for each (var jsonModel : Object in jsonArray)
				addQuestionModel(new QuestionModel(jsonModel), true);
		}

		internal function saveAllQuestionsHandler() : void {
			QuestionModel.deletedAnswerIds = [];
			questionStorage.reset();
			answerStorage.reset();
		}

		private function makeCodesArrayByQuestionOrder(questionOrder : int) : Array {	/* of int */
			var index : int = questionOrder - 1;
			var codesArray : Array = questionStorage.tryMakeCodesArrayByIndex(index);
			if (codesArray != null)
				return codesArray;
			
			return answerStorage.getCodesArray(index);
		}

/* FOR SURVEY */
		internal function goToNext(jsonModel : Object) : void {
			if (!jsonModel) {
				questionStorage.isStopped = true;
				return;
			}
			updateCurrentModel(jsonModel);
		}
	
		internal function goToPrevious() : void {
			questionStorage.goToPrevious();
			answerStorage.setCurrentVariantsByIndex(questionStorage.currentIndex);
		}
		
		private function updateCurrentModel(jsonModel : Object) : void {
			var modelQuestion : QuestionModel = new QuestionModel(jsonModel);
			var newOrder : int = modelQuestion.question.order;
			if (questionStorage.isLast)
				addQuestionModel(modelQuestion);
			else if (questionStorage.haveToInsert(newOrder))
				insertQuestionModel(modelQuestion);
			else if (questionStorage.haveToSet(newOrder))
				setQuestionModel(modelQuestion);
			
// LOOK			modelQuestion.question.filterSubitems(checkConditionOnTag);
			questionStorage.goToNext();
			answerStorage.setCurrentVariantsByIndex(questionStorage.currentIndex);
		}
		
		private function addQuestionModel(modelQuestion : QuestionModel, isDesigner : Boolean = false) : void {
			questionStorage.addQuestion(modelQuestion.question, isDesigner);
			if (isDesigner)
				modelQuestion.correctOldVariants();
			
			answerStorage.addVariants(modelQuestion.answerVariants);
		}
		
		private function insertQuestionModel(modelQuestion : QuestionModel) : void {
			questionStorage.insertQuestion(modelQuestion.question);
			answerStorage.insertVariants(modelQuestion.answerVariants);
		}

		private function setQuestionModel(modelQuestion : QuestionModel) : void {
			questionStorage.setQuestion(modelQuestion.question);
			answerStorage.setVariants(modelQuestion.answerVariants);
		}
/*
		private function addToDeleted(id : int, isQuestion : Boolean = true, isSubQuestion : Boolean = false) : void {
			if (!id)
				return;
			if (isQuestion)
				_deletedQuestionIds.push(id);
			else if (isSubQuestion)
				_deletedSubQuestionIds.push(id);
			else
				_deletedAnswerIds.push(id);
		}*/
	}
}