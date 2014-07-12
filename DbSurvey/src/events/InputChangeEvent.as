package events
{
	import flash.events.Event;
	
	public class InputChangeEvent extends Event
	{
		public static const INPUT_CHANGHED:String = "inputChanghed";
		
		
		private var _itemIndex : int;
		
		public function get itemIndex() : int {
			return _itemIndex;
		}
		
		private var _newText : String;
		
		public function get newText() : String {
			return _newText;
		}
		
		public function InputChangeEvent(type : String, itemIndex : int, newText : String)
		{
			super(type, true);
			_itemIndex = itemIndex;
			_newText = newText;
		}
	}
}