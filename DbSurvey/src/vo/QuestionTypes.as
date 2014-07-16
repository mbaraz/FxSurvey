package vo
{
	import tools.enums.Enum;

	public class QuestionTypes extends Enum {
		public static const Simple : QuestionTypes = new QuestionTypes(true, false, false, true);
		public static const Summed : QuestionTypes = new QuestionTypes(false, true, false);
		public static const Rating : QuestionTypes = new QuestionTypes(false, true, false);
		public static const Ranking : QuestionTypes = new QuestionTypes(false, true, false);
		public static const RadioRank : QuestionTypes = new QuestionTypes(false, false, true);
		public static const SliderRank : QuestionTypes = new QuestionTypes(false, false, true);
		public static const DragRank : QuestionTypes = new QuestionTypes(false, true, false);
		public static const RadioGrid : QuestionTypes = new QuestionTypes(false, false, true);
		public static const SliderGrid : QuestionTypes = new QuestionTypes(false, false, true);

		private var _isPluralityEnabled : Boolean;
		
		public function get isPluralityEnabled() : Boolean {
			return _isPluralityEnabled;
		}
		
		private var _isPluralOnly : Boolean;
		
		public function get isPluralOnly() : Boolean {
			return _isPluralOnly;
		}
		
		private var _isSinglelOnly : Boolean;
		
		public function get isSinglelOnly() : Boolean {
			return _isSinglelOnly;
		}
		
		private var _canHaveExclude : Boolean;
		
		public function get canHaveExclude() : Boolean {
			return _canHaveExclude;
		}

		public function get isRanked() : Boolean {
			return this != Simple && this != Summed && !hasSingleAnswer;
		}
		
		public function get isRated() : Boolean {
			return this == Rating || this == DragRank;
		}
/*		
		public function get isNotRanked() : Boolean {
			return this == Simple || this == Summed;
		}
*/
		public function get hasOpenAnswersOnly() : Boolean {
			return this == Summed || this == Rating || this == Ranking;
		}
		
		public function get hasCloseAnswersOnly() : Boolean {
			return this != Simple && this != Summed;
		}
		
		public function get hasNumericAnswersOnly() : Boolean {
			return this == Summed || this == Rating || this == Ranking;
		}

		public function get hasSingleAnswer() : Boolean {
			return this == RadioRank || this == SliderRank;
		}

		public function get isGridType() : Boolean {
			return this == RadioGrid || this == SliderGrid;
		}
		
		public function QuestionTypes(isPluralityEnabled : Boolean, isPluralOnly : Boolean, isSinglelOnly : Boolean, canHaveExclude : Boolean = false) {
			super();
			_isPluralityEnabled = isPluralityEnabled;
			_isPluralOnly = isPluralOnly;
			_isSinglelOnly = isSinglelOnly;
			_canHaveExclude = canHaveExclude;
		}
/*		
		public static function getValues() : Array {
			return Enum.getValues(QuestionTypes)
		}
*/		
		public static function get namesArray() : Array {
			return [Simple.name, Summed.name, Rating.name, Ranking.name, RadioRank.name, SliderRank.name, DragRank.name, RadioGrid.name, SliderGrid.name];
		}
		
		internal static function getTypeByName(name : String) : QuestionTypes {
			return Enum.valueOf(QuestionTypes, name);
		}
	}
}