package tools.so
{
	import flash.events.EventDispatcher;
	
	public class SOLocalStorage extends EventDispatcher {
		public function SOLocalStorage() {
		}
		
		public function hasSavedQuestions() : Boolean {
			var hasSavedData : Boolean = false;
			try {
				if (getSavedQuestions() is Array) {
					hasSavedData = true;
				}
			} catch (e:Error) {
				hasSavedData = false;
			}
			
			return hasSavedData;
		}
		
		public function getSavedQuestions() : Array {
			var saved : Object = SharedObjectsManager.getInstance().getData("questions");
			return saved as Array;
		}
		
		public function saveQuestions(value : Array):void {
			SharedObjectsManager.getInstance().saveData("questions", value);
		}
	}
}