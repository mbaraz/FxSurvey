package data.storages
{
	public interface IStorage
	{
		[Bindable(event="propertyChange")]
		function get selectedItem() : Object;
		
		function set selectedItem(value : Object) : void;
		
		function get currentIndex() : int;
	}
}