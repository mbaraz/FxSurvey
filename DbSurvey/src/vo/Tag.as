package vo
{
	public class Tag
	{
		public var TagId : int;

		public function set TagName(value : String) : void {
			var delimIndx : int = value.indexOf(SubQuestion.Delimiter);
			if (delimIndx == -1) {
				_boundedQuestionOrder = int(value.substring(1));
				boundedSubOrder = 0;
			} else {
				_boundedQuestionOrder = int(value.substring(1, delimIndx));
				boundedSubOrder = int(value.substring(delimIndx + 1));
			}
		}

		public function get TagName() : String {
			return "Q" + boundedQuestionOrder + subSuffix;
		}
		
		private var _boundedQuestionOrder : int;
		
		public function get boundedQuestionOrder() : int {
			return _boundedQuestionOrder;
		}

		private var boundedSubOrder : int;
		
		private function get subSuffix() : String {
			return boundedSubOrder ? "." + boundedSubOrder : "";
		}
		
		public function Tag(tagId : int, tagName : String) {
			TagId = tagId;
			TagName = tagName;
		}

		public function changeBoundedOrders(isIncreased : Boolean) : void {
			if (boundedSubOrder)
				boundedSubOrder = isIncreased ? boundedSubOrder + 1 : boundedSubOrder - 1;
			else
				_boundedQuestionOrder = isIncreased ? _boundedQuestionOrder + 1 : _boundedQuestionOrder - 1;
		}

		public function changeBoundedQuestionOrder(isIncreased : Boolean) : void {
				_boundedQuestionOrder = isIncreased ? _boundedQuestionOrder + 1 : _boundedQuestionOrder - 1;
		}
		
		public function canApply(order : int) : Boolean {
			return boundedQuestionOrder < order;
		}
	}
}