package vo
{
	import mx.collections.ArrayCollection;

	public class SurveyQuestion extends QuestionItem
	{
		public static const Answers_Order_Types : Array = ["Стандартный", "Случайный", "Ротированный"];
		public static const Default_Min_Answers : int = 1;
		public static const Default_Max_Answers : int = 12;
		public static const Default_Min_Rank : int = 0;
		public static const Default_Max_Rank : int = 10;
		public static const PLURALITY_CHANGED_EVENT : String = "PluralityChanged";
		public static const TYPE_CHANGED_EVENT : String = "QuestionTypeChanged";
		public static const Default_Text_Delimiter : String = "#";
		
		private static const Default_Answer_Delimiter : String = "\n";

		private static var projectId : int;
		
		public static function set ProjectId(value : int) : void {
			projectId = value;
		}

		[Bindable]
		public var isSelected : Boolean;
		[Bindable]
		public var QuestionOrder : int;
		[Bindable]
		public var subitems : ArrayCollection; /* Of SubQuestion */
		[Bindable]
		public var subitemIndex : int = -1; // Начиная с 1
		
		private var _questionType : String;
		
		[Bindable]
		public function get QuestionType() : String {
			return _questionType;
		}

		public function set QuestionType(value : String) : void {
			_questionType = value;
			if (!isSelected)
				return;
			
			var type : QuestionTypes = QuestionTypes.getTypeByName(QuestionType);
			if (type.isPluralOnly)
				MultipleAnswerAllowed = true;
			else if (type.isSinglelOnly)
				MultipleAnswerAllowed = false;
			
			if (type.isNotRanked)
				setNoRanks();
			
			if (isGridQuestion) {
				if (!subitems.length)
					QuestionText += Default_Text_Delimiter;
				// TEMP			
				MaxRank = subitems.length;
				// TEMP				
			}
			/*
			switch(QuestionType) {
			case "Summed":
			setMaxAnswersCount();
			}
			*/
			AnswerVariant.QuestionType = QuestionType;
		}

		[Bindable]
		override public function set QuestionText(value : String) : void {
			_questionText = parseTextAndSubitems(value);
		}

		private var _filterAnswersTagId : int;
		
		[Bindable]
		public function get FilterAnswersTagId() : int {
			return _filterAnswersTagId;
		}
		
		public function set FilterAnswersTagId(value : int) : void {
			_filterAnswersTagId = value;
			if (isSelected)
				AnswerVariant.isFiltered = Boolean(_filterAnswersTagId);
		}

		public var IsRankQuestion : Boolean;

		public function get QuestionName() : String {
			return "Q" + order;
		}

		private var _multipleAnswerAllowed : Boolean;
		
		public function set MultipleAnswerAllowed(value : Boolean) : void {
			if (QuestionType == "Simple" && !MultipleAnswerAllowed && value)
				setSingleAnswersCount();

			_multipleAnswerAllowed = value;
			if (!isSelected)
				return;
			if (!_multipleAnswerAllowed)
				setSingleAnswersCount();
				
			AnswerVariant.MultipleAnswerAllowed = MultipleAnswerAllowed;
		}
		
		public function get MultipleAnswerAllowed() : Boolean {
			return _multipleAnswerAllowed;
		}
		
		private var _maxAnswers : int;
		
		public function set MaxAnswers(value : int) : void {
			_maxAnswers = value;
			if (isSelected)
				AnswerVariant.MaxAnswers = MaxAnswers;
		}
		
		public function get MaxAnswers() : int {
			return _maxAnswers;
		}
		
		private var _minAnswers : int;

		public function set MinAnswers(value : int) : void {
			_minAnswers = value;
			if (isSelected)
				AnswerVariant.MinAnswers = MinAnswers;
		}
		
		public function get MinAnswers() : int {
			return _minAnswers;
		}

		override public function set BoundTagId(value : int) : void {
			super.BoundTagId = value;
			if (isSelected)
				AnswerVariant.hasBoundTag = Boolean(value);
		}

		private var _answersOrdering : String;
		
		public function get AnswersOrdering() : String {
			return _answersOrdering;
		}
		
		public function set AnswersOrdering(value : String) : void {
			_answersOrdering = value;
			if (isSelected)
				AnswerVariant.isStandartOrder = isStandartOrder;
		}
		
		public function get answersOrderIndex() : int {
			return Answers_Order_Types.indexOf(AnswersOrdering);
		}
		
		internal function get isStandartOrder() : Boolean {
			return AnswersOrdering == Answers_Order_Types[0];
		}

		private var _maxRank : int;
		
		public function set MaxRank(value : int) : void {
			_maxRank = value;
			if (!isSelected)
				return
			IsRankQuestion = MaxRank > Default_Min_Rank;
			AnswerVariant.IsRankQuestion = IsRankQuestion;
			AnswerVariant.MaxRank = MaxRank;
		}
		
		public function get MaxRank() : int {
			return _maxRank;
		}

		private var _minRank : int;
		
		public function set MinRank(value : int) : void {
			_minRank = value;
			if (isSelected)
				AnswerVariant.MinRank = MinRank;
		}
		
		public function get MinRank() : int {
			return _minRank;
		}

		public function get selectedSubitem() : Object {
			return	subitemIndex > 0 ? subitems.getItemAt(subitemIndex - 1) : null;
		}
		
		public function get subTagIds() : Array {
			var result : Array = [];
			if (isGridQuestion)
				for (var i : int = Math.max(subitemIndex, 0); i < subitems.length; i++) {
					var subQuestion : SubQuestion = subitems.getItemAt(i) as SubQuestion;
					if (subQuestion.hasBoundTag)
						result.push(subQuestion.BoundTagId);
				}
			return result;
		}
		
		public function get isGridQuestion() : Boolean {
			var type : QuestionTypes = QuestionTypes.getTypeByName(QuestionType);
			return type.isGridType;
		}
		
		public function get isSubitemSelected() : Boolean {
			return isGridQuestion && subitemIndex > 0;
		}

		override public function get questionObject() : Object {
			var obj : Object = super.questionObject;
			obj.SurveyProjectId = projectId;
			obj.QuestionType = QuestionTypes.namesArray.indexOf(QuestionType);
			obj.MultipleAnswerAllowed = MultipleAnswerAllowed;
			obj.MaxAnswers = MaxAnswers;
			obj.MinAnswers = MinAnswers;
			obj.QuestionOrder = order;
			obj.QuestionName = QuestionName;
			obj.MaxRank = MaxRank;
			obj.MinRank = MinRank;
//			obj.IsRankQuestion  = IsRankQuestion;
/*
			obj.ConditionOnTagId = tagCondition.tagId;
			obj.ConditionOnTagValue = tagCondition.tagValue;
*/				
			obj.AnswerOrdering = Answers_Order_Types.indexOf(AnswersOrdering);
			obj.FilterAnswersTagId = FilterAnswersTagId;
			obj.subitems = makeSubitemObjects();
			return obj;
		}

		public function get noAnswersCodesArray() : Array {
			if (!hasNoAnswers)
				return null;
			var result : Array = [];
			for (var i : int = MinRank; i <= MaxRank; i++)
				result.push(i);
			
			return result;
		}

		public function SurveyQuestion(obj:Object) {
			super(obj);
		}
/*	LOOK
		public function filterSubitems(filterFunction : Function) : void {
			subitems.filterFunction = filterFunction;
			subitems.refresh();
		}
*/		
		public function addSubitem() : void {
			subitems.addItemAt(SubQuestion.getEmptySubQuestion(subitemIndex + 1, SurveyQuestionId), subitemIndex);
			subitemIndex++;
		}
		
		public function removeSubitem() : void {
			if (subitems.length == 1)
				return;
			subitemIndex--;
			subitems.removeItemAt(subitemIndex);
		}
		
		public function swapSubitems(isUp : Boolean) : void {
			var currentIndex : int = subitemIndex - 1;
			var index : int = isUp ? currentIndex - 1 : currentIndex + 1;
			if (index < 0 || index == subitems.length)
				return;
			
			var temp : SubQuestion = subitems.getItemAt(index) as SubQuestion;
			temp.order = subitemIndex;
			selectedSubitem.order = index + 1;
			subitems.setItemAt( selectedSubitem, index);
			subitems.setItemAt(temp, currentIndex);
			subitemIndex = index + 1;
		}
		
		public function findIndexBySuborder(suborder : int) : int {
			var max : int = subitems.length;
			var i : int = 0;
			while (i < max && suborder > subitems.getItemAt(i).order)
				i++;
			
			return i < max && suborder == subitems.getItemAt(i).order ? i : -1;
		}

		public function parseText(value : String) : Array {
			var arr : Array =  value.split(SurveyQuestion.Default_Answer_Delimiter);
			QuestionText = arr.shift();
			return arr;
		}

		public static function getEmptyQuestion() : SurveyQuestion {
			return new SurveyQuestion({QuestionText: "", QuestionType : "Simple"});
		}
		
		override protected function fill(obj : Object) : void {
			super.fill(obj);
			QuestionType = QuestionTypes.namesArray[int(obj.QuestionType)];
			
			QuestionOrder = obj.QuestionOrder;
			subitems = parseSubitems(obj.subitems);
			MultipleAnswerAllowed = obj.MultipleAnswerAllowed;
			MaxAnswers = obj.MaxAnswers == null ? Default_Min_Answers : obj.MaxAnswers;
			MinAnswers = obj.MinAnswers == null ? Default_Min_Answers : obj.MinAnswers;
			IsRankQuestion  = obj.IsRankQuestion;
 			MinRank = obj.MinRank;
			MaxRank = obj.MaxRank;

			if (obj.ConditionOnTagId)
				ConditionString = obj.ConditionOnTagId + " = " + obj.ConditionOnTagValue;
/*			else
				ConditionString = obj.ConditionString;*/

			AnswersOrdering = Answers_Order_Types[int(obj.AnswersOrdering)];	//	obj.AnswersOrdering ? obj.AnswersOrdering : Answers_Order_Types[0];
			FilterAnswersTagId = obj.FilterAnswersTagId;
		}

		private function parseTextAndSubitems(value : String) : String {
			var arr : Array =  value.split(Default_Text_Delimiter);
			var result : String = arr.shift();
			makeSubitems(arr);
			return result;
		}
		
		private function makeSubitems(arr : Array) : void {
			var resultArr : ArrayCollection = new ArrayCollection();
			for (var i : int = 0;  i < arr.length; i++)
				resultArr.addItem(new SubQuestion({QuestionText : arr[i], SubOrder : i + 1, SurveyQuestionId : order}));
			
			if (!subitems)
				subitems = resultArr;
			else
				subitems.addAllAt(resultArr, subitems.length);
		}

		private function parseSubitems(arr : Array) : ArrayCollection {
			for (var i : int =0; arr && i < arr.length; i++)
				arr[i] = new SubQuestion(arr[i]);
			
			return new ArrayCollection(arr);
		}
		
		private function makeSubitemObjects() : Array {
			var result : Array = [];
			for each (var subitem : SubQuestion in subitems)
				result.push(subitem.questionObject);

			return result;
		}
		
		private function setMaxAnswersCount() : void {
			MinAnswers = Default_Min_Answers;
			MaxAnswers = Default_Max_Answers;
		}
		
		private function setSingleAnswersCount() : void {
			MinAnswers = Default_Min_Answers;
			MaxAnswers = Default_Min_Answers;
		}
/*		
		private function setMaxRanksCount() : void {
			MinRank = Default_Min_Rank;
			MaxRank = Default_Max_Rank;
		}
*/		
		private function setNoRanks() : void {
			MinRank = Default_Min_Rank;
			MaxRank = Default_Min_Rank;
		}

		private function get hasNoAnswers() : Boolean {
			var type : QuestionTypes = QuestionTypes.getTypeByName(QuestionType);
			return type.hasNoAnswers;
		}
	}
}