package data.storages
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import tools.utils.LocaleUtils;
	import vo.AnswerVariant;
	import vo.QuestionItem;
	import vo.SubQuestion;
	import vo.SurveyQuestion;
	import vo.Tag;
	
	public class QuestionStorage extends EventDispatcher implements IStorage
	{
		
		private var tagStorage : TagStorage;
		private var _currentQuestion : SurveyQuestion;
		
		[Bindable]
		public var questions : ArrayCollection; /* of SurveyQuestion */
		[Bindable]
		public var isStopped : Boolean;

		[Bindable]
		public function get currentQuestion() : SurveyQuestion {
			AnswerVariant.SetQuestionParameters(_currentQuestion);
			return _currentQuestion;
		}

		public function set currentQuestion(value : SurveyQuestion) : void {
			if (_currentQuestion)
				_currentQuestion.isSelected = false;
			
			_currentQuestion = value;
			if (_currentQuestion)
				_currentQuestion.isSelected = true;
			
			dispatchEvent(new Event("currentQuestionChange"));
		}
		
		[Bindable(event="currentQuestionChange")]
		public function get isPreviousExist() : Boolean {
			return currentIndex > 0;
		}
		
		[Bindable(event="currentQuestionChange")]
		public function get selectedItem() : Object {
			return currentQuestion;
		}

		public function get currentIndex() : int {
			return questions.getItemIndex(currentQuestion);
		}
		
		public function get isLast() : Boolean {
			return currentIndex == questions.length - 1;
		}
		
		public function set selectedItem(value : Object) : void {
			currentQuestion = value as SurveyQuestion;
			LocaleUtils.setLocale(!isEnglishQuestionText);
		}

		public function get questionObjects() : Array {
			var result : Array = [];
			for each (var question : SurveyQuestion in questions)
				result.push(question.questionObject);
				
			return result;
		}

		public function get currentOrder() : int {
			return _currentQuestion ? _currentQuestion.order : 0;
		}
/*
		public function get currentAnswerOrderIndex() : int {
			return _currentQuestion.answersOrderIndex;
		}
*/		
		public function set projectId(value : int) : void {
			SurveyQuestion.ProjectId = value;
		}
		
		public function get deletedTagIds() : Array {
			return tagStorage.deletedTagIds;
		}
		
		public function get selectedSubItemName() : String {
			return currentQuestion.QuestionName + SubQuestion.Delimiter + currentQuestion.selectedSubitem.order;
		}
		
		private function get isEnglishQuestionText() : Boolean {
			if (!_currentQuestion)
				return false;
			
			var questionText : String = _currentQuestion.QuestionText.toLowerCase();
			return questionText.indexOf("о") == -1 && questionText.indexOf("е") == -1 && questionText.indexOf("а") == -1
				&& questionText.indexOf("и") == -1 && questionText.indexOf("т") == -1 && questionText.indexOf("н") == -1
				&& questionText.indexOf("р") == -1 && questionText.indexOf("с") == -1;
		}
		
		private function get nextQuestionOrder() : int {
			return currentIndex + 1 < questions.length ? questions.getItemAt(currentIndex + 1).order : 0;
		}

		public function QuestionStorage() {
			questions = new ArrayCollection();
			tagStorage = new TagStorage();
		}
/* FOR SURVEY */
		public function haveToInsert(newOrder : int) : Boolean {
			return nextQuestionOrder > newOrder;
		}
		
		public function haveToSet(newOrder : int) : Boolean {
			return nextQuestionOrder <= newOrder;
		}
		
		public function insertQuestion(question : SurveyQuestion) : void {
			questions.addItemAt(question, currentIndex + 1);
		}
		
		public function setQuestion(question : SurveyQuestion) : void {
			questions.setItemAt(question, currentIndex + 1);
		}

		public function goToPrevious() : void {
			selectedItem = questions.getItemAt(currentIndex - 1);
		}
		
		public function goToNext() : void {
			selectedItem = questions.getItemAt(currentIndex + 1);
		}
/*		LOOK
		public function replaceOrderByIndex(order : String) : Array {
			if (order == null)
				return [-1];
			var result : Array = order.split(SubQuestion.Delimiter);
			result[0] = findIndexByOrder(result[0]);
			if (result.length > 1 && result[0] != -1)
				result[1] = questions.getItemAt(result[0]).findIndexBySuborder(result[1]);
			return result;
		}
*/		
		private function findIndexByOrder(order : int) : int {
			var max : int = currentIndex;;
			var i : int = 0;
			while (i <= max && order > questions.getItemAt(i).order)
				i++;
			
			return i <= max && order == questions.getItemAt(i).order ? i : -1;
		}

/* FOR BOTH */
		public function addQuestion(question : SurveyQuestion, isDesigner : Boolean = false) : void {
			questions.addItem(question);
			question.order = questions.length;
			if (isDesigner) {
				tagStorage.addBoundedTag(question, question.QuestionName);
				addSubBoundedTag(question);
			}
		}
		
/* FOR DESIGNER */
		public function addNew() : int {
			if (currentQuestion && currentQuestion.isSubitemSelected) {
				currentQuestion.addSubitem();
				changeCurrentSubOrders(currentQuestion.subitemIndex);
				return -1;
			}
			var insertIndex : int;
			var question : SurveyQuestion = SurveyQuestion.getEmptyQuestion();
			if (currentIndex > -1) {
				insertIndex = currentIndex + 1;
				question.order = insertIndex + 1;
				questions.addItemAt(question, insertIndex);
				changeOrders(insertIndex + 1);
			} else {
				insertIndex = questions.length;
				addQuestion(question);
			}
			return insertIndex;
		}
		
		public function removeCurrent() : Boolean {
			if (currentQuestion && currentQuestion.isSubitemSelected) {
				currentQuestion.removeSubitem();
				changeCurrentSubOrders(currentQuestion.subitemIndex, false);
				return false;
			}
			currentQuestion.order = 0;
			var selectedIndex : int = currentIndex;
			if (currentQuestion.hasBoundTag)
				tagStorage.removeTag(currentQuestion.BoundTagId);
			
			questions.removeItemAt(selectedIndex);
			changeOrders(selectedIndex, false);
			if (selectedIndex == questions.length)
				selectedIndex--;
			
			selectedItem =  selectedIndex > -1 ? questions.getItemAt(selectedIndex) : null;
			return true;
		}
		
		public function swap(isUp : Boolean) : Boolean {
			if (currentQuestion && currentQuestion.isSubitemSelected) {
				currentQuestion.swapSubitems(isUp);
				return false;
			}
			var selectedIndex : int = currentIndex;
			var index : int = isUp ? selectedIndex - 1 : selectedIndex + 1;
			var temp : Object = questions.getItemAt(index);
			var selectedItem : Object = questions.getItemAt(selectedIndex);
			temp.order = selectedIndex + 1;
			tagStorage.updateNames(temp.hasBoundTag ? [temp.BoundTagId] : [], temp.subTagIds, isUp);

			selectedItem.order = index + 1;
			tagStorage.updateNames(selectedItem.hasBoundTag ? [selectedItem.BoundTagId] : [], selectedItem.subTagIds, !isUp);
			
			questions.disableAutoUpdate();
			questions.setItemAt(selectedItem, index);
			questions.setItemAt(temp, selectedIndex);
			questions.enableAutoUpdate();
			currentQuestion = selectedItem as SurveyQuestion;
			questions.refresh();
			return true;
		}

		public function tryMakeCodesArray(obj : Object) : Array {
			if (!(obj is SurveyQuestion))
				return null;
			return (obj as SurveyQuestion).noAnswersCodesArray;
		}
		
		public function tryMakeCodesArrayByIndex(index : int) : Array {
			if (index >= questions.length)
				return null;
			return tryMakeCodesArray(questions.getItemAt(index));
		}
		
		public function getTagArray(max : int) : Array {	/* of SurveyQuestions and SubQuestion */
			return tagStorage.getTagArray(max);
		}
		
		public function addTag() : void {
			if (currentQuestion.selectedSubitem)
				currentQuestion.selectedSubitem.BoundTagId = tagStorage.addTag(selectedSubItemName);
			else
				currentQuestion.BoundTagId = tagStorage.addTag(currentQuestion.QuestionName);
		}
		
		public function removeTag() : void {
			if (currentQuestion.selectedSubitem) {
				tagStorage.removeTag(currentQuestion.selectedSubitem.BoundTagId);
				currentQuestion.selectedSubitem.BoundTagId = 0;
			} else {
				tagStorage.removeTag(currentQuestion.BoundTagId);
				currentQuestion.BoundTagId = 0;
			}
		}

		public function makeConditionText(question : SurveyQuestion) : String {
			var result : String = "";
			var item : QuestionItem = question.selectedSubitem ? question.selectedSubitem as QuestionItem : question;
			var i : int = 0;
			while (i < item.tagCondition.expressionsArray.length) {
				var expressionsArray : Array = item.tagCondition.expressionsArray;
				var tagName : String = tagStorage.getTagNameById(expressionsArray[i].tagId, question.order);
				if (!tagName)
					expressionsArray.splice(i,1);	//	item.tagCondition.expressionsArray.splice(i,1);
				else 
					result += expressionsArray[i++].makeCondition(tagName);	//	item.tagCondition.expressionsArray[i++].makeCondition(tagName);
			}
			return result.substring(2);
		}
		
		public function makeFilterText(question : SurveyQuestion) : String {
			var tagName : String = tagStorage.getTagNameById(question.FilterAnswersTagId, question.order);
			if (!tagName)
				question.FilterAnswersTagId = 0;
			
			return tagName;
		}
		
		public function addTagsChangeListener(handler : Function) : void {
			tagStorage.addTagsChangeListener(handler);
		}
		
		public function getTagById(id : int) :Tag {
			return tagStorage.getTagById(id);
		}

		public function cleanTags() : void {
			tagStorage.cleanTags();
		}
		
		private function changeOrders(satrtIndex : int , isIncreased : Boolean = true) : void {
			var tagIds : Array = [];
			var subTagIds : Array = [];
			for (var i : int = satrtIndex; i < questions.length; i++) {
				var question : SurveyQuestion = questions.getItemAt(i) as SurveyQuestion;
				if (isIncreased)
					question.order++;
				else
					question.order--;
				
				if (question.hasBoundTag)
					tagIds.push(question.BoundTagId);
				
				subTagIds = subTagIds.concat(question.subTagIds);
			}
			tagStorage.updateNames(tagIds, subTagIds, isIncreased);
		}

		private function changeCurrentSubOrders(satrtIndex : int , isIncreased : Boolean = true) : void {
			var tagIds : Array = [];
			for (var i : int = satrtIndex; i < currentQuestion.subitems.length; i++) {
				var subQuestion : SubQuestion = currentQuestion.subitems.getItemAt(i) as SubQuestion;
				if (isIncreased)
					subQuestion.order++;
				else
					subQuestion.order--;
				
				if (subQuestion.hasBoundTag)
					tagIds.push(subQuestion.BoundTagId);
			}
			tagStorage.updateNames(tagIds, [], isIncreased);
		}
		
		private function addSubBoundedTag(question : SurveyQuestion) : void {
			for each (var subQuestion : SubQuestion in question.subitems)
				tagStorage.addBoundedTag(subQuestion, question.QuestionName + SubQuestion.Delimiter + subQuestion.order);
		}
	}
}