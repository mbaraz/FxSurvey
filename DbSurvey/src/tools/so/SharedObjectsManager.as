package tools.so
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	
	public class SharedObjectsManager {
		private static const LOCAL_STORAGE : String = "localStorage";
		
		private static var instance : SharedObjectsManager = new SharedObjectsManager();
		
		private var sharedObject : SharedObject;
		
		private function get data() : Object {
			return sharedObject.data;
		}
		
		public function SharedObjectsManager() {
			if (instance) {
				throw new Error("SharedObjectsManager is Singleton. Singleton and can only be accessed through Singleton.getInstance()");
			}
			try {
				sharedObject = SharedObject.getLocal(LOCAL_STORAGE);
				sharedObject.addEventListener(NetStatusEvent.NET_STATUS, sharedObjectNetStatusHandler);
			} catch (e:Error) {
				trace("Error of SharedObject.getLocal " + e);
			}
		}
		
		public static function getInstance():SharedObjectsManager {
			return instance;
		}
		
		public function getData(id:String):Object {
			return data[id];
		}
		
		public function saveData(id:String, value:Object):void {
			data[id] = value;
			if (sharedObject.flush() != SharedObjectFlushStatus.FLUSHED) {
				trace("Error! Shared objects aren't saved correctly.");
			}
		}
		
		private function sharedObjectNetStatusHandler(event:NetStatusEvent):void {
			trace("Error! Shared objects aren't saved correctly.");
		}
	}
}