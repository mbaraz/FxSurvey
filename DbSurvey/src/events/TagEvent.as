package events
{
	import flash.events.Event;
	
	public class TagEvent extends Event
	{
		public static const TAG_ADDED : String = "tagAdded";
		public static const TAG_REMOVED : String = "tagRemoved";
		public static const TAG_CHANGED : String = "tagChanged";
		
		private var _questionOrder : int;
		
		public function get questionOrder() : int {
			return _questionOrder;
		}
		
		private var _oldOrder : int;
		
		public function get oldOrder() : int {
			return _oldOrder;
		}
		
		public function TagEvent(type : String, order : int = 0, old : int = 0)
		{
			super(type, true);
			_questionOrder = order;
			_oldOrder = old;
		}
		
		override public function clone() : Event {
			return new TagEvent(type, questionOrder, oldOrder);
		}
	}
}