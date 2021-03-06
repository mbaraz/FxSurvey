package vo
{
	import mx.collections.ArrayCollection;

	public class SurveyQuestion extends QuestionItem
	{
		public static const Answers_Order_Types : Array = ["Стандартный", "Случайный", "Ротированный"];
		public static const Default_Min_Answers : int = 1;
		public static const Default_Max_Answers : int = 99;
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
				AnswerVariant.Type = QuestionTypes.getTypeByName(QuestionType);
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

		public function get QuestionName() : String {
			return "Q" + order;
		}

		private var _multipleAnswerAllowed : Boolean;
		
		[Bindable]
		public function get MultipleAnswerAllowed() : Boolean {
			return _multipleAnswerAllowed;
		}
		
		public function set MultipleAnswerAllowed(value : Boolean) : void {
/*			if (QuestionType == "Simple" && !MultipleAnswerAllowed && value)
				setSingleAnswersCount();
*/
			_multipleAnswerAllowed = value;
			if (!isSelected)
				return;
			if (!_multipleAnswerAllowed)
				setSingleAnswersCount();
				
			AnswerVariant.MultipleAnswerAllowed = MultipleAnswerAllowed;
		}
		
		private var _maxAnswers : int;
		
		[Bindable]
		public function get MaxAnswers() : int {
			return _maxAnswers;
		}
		
		public function set MaxAnswers(value : int) : void {
			_maxAnswers = value;
			if (QuestionType && isAnswersNeeded) {
				MaxRank = value;
				MinRank = Default_Min_Answers;
			}
			if (isSelected)
				AnswerVariant.MaxAnswers = MaxAnswers;
		}
		
		private var _minAnswers : int;

		[Bindable]
		public function get MinAnswers() : int {
			return _minAnswers;
		}

		public function set MinAnswers(value : int) : void {
			_minAnswers = value;
			if (isSelected)
				AnswerVariant.MinAnswers = MinAnswers;
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
			if (isSelected) {
				AnswerVariant.isStandartOrder = isStandartOrder;
				AnswerVariant.AnswersOrderingIndex = Answers_Order_Types.indexOf(AnswersOrdering);
			}
		}
		
		internal function get answersOrderIndex() : int {
			return Answers_Order_Types.indexOf(AnswersOrdering);
		}
		
		internal function get isStandartOrder() : Boolean {
			return AnswersOrdering == Answers_Order_Types[0];
		}

		private var _maxRank : int;
		
		public function set MaxRank(value : int) : void {
			_maxRank = value;
			if (isSelected)
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
			if (isCompositeQuestion)
				for (var i : int = Math.max(subitemIndex, 0); i < subitems.length; i++) {
					var subQuestion : SubQuestion = subitems.getItemAt(i) as SubQuestion;
					if (subQuestion.hasBoundTag)
						result.push(subQuestion.BoundTagId);
				}
			return result;
		}
		
		public function get isAnswersNeeded() : Boolean {
			var type : QuestionTypes = QuestionTypes.getTypeByName(QuestionType);
			return type.isAnswersAbsent;
		}
		
		public function get isGridQuestion() : Boolean {
			var type : QuestionTypes = QuestionTypes.getTypeByName(QuestionType);
			return type.isGridType;
		}
		
		public function get isCompositeQuestion() : Boolean {
			var type : QuestionTypes = QuestionTypes.getTypeByName(QuestionType);
			return type.isCompositeType;
		}
		
		public function get isRanked() : Boolean {
			var type : QuestionTypes = QuestionTypes.getTypeByName(QuestionType);
			return type.isRanked;
		}
		
		public function get isSubitemSelected() : Boolean {
			return isCompositeQuestion && subitemIndex > 0;
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

		public function addSubitem() : void {
			subitems.addItemAt(SubQuestion.getEmptySubQuestion(subitemIndex + 1, SurveyQuestionId), subitemIndex);
			subitemIndex++;
		}
		
		public function removeSelectedSubitem() : Boolean {
			if (subitems.length == 1)
				return false;
			subitemIndex--;
			subitems.removeItemAt(subitemIndex);
			return true;
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
			QuestionOrder = obj.QuestionOrder;
			subitems = parseSubitems(obj.subitems);
			MultipleAnswerAllowed = obj.MultipleAnswerAllowed;
			QuestionType = QuestionTypes.namesArray[int(obj.QuestionType)];
			MinRank = obj.MinRank;
			MaxRank = obj.MaxRank;
			MaxAnswers = obj.MaxAnswers == null ? Default_Min_Answers : obj.MaxAnswers;
			MinAnswers = obj.MinAnswers == null ? Default_Min_Answers : obj.MinAnswers;
			if (obj.ConditionOnTagId)
				ConditionString = obj.ConditionOnTagId + " = " + obj.ConditionOnTagValue;

			AnswersOrdering = Answers_Order_Types[int(obj.AnswerOrdering)];	//	obj.AnswersOrdering ? obj.AnswersOrdering : Answers_Order_Types[0];
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
			var subitemsCount : int = subitems ? subitems.length + 1 : 1;
			for (var i : int = 0;  i < arr.length; i++)
				resultArr.addItem(new SubQuestion({QuestionText : arr[i], SubOrder : i + subitemsCount, SurveyQuestionId : order}));
			
			if (!subitems)
				subitems = resultArr;
			else
				subitems.addAllAt(resultArr, subitemsCount - 1);
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
		
		private function setSingleAnswersCount() : void {
			MinAnswers = MaxAnswers = Default_Min_Answers;
		}

		private function get hasNoAnswers() : Boolean {
			var type : QuestionTypes = QuestionTypes.getTypeByName(QuestionType);
			return type.hasSingleAnswer || type.isAnswersAbsent;
		}
	}
}