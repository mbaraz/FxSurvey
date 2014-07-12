package components
{
	import mx.collections.IList;
	import mx.core.IVisualElement;

	public interface IAnswer extends IVisualElement
	{
		function set variants(value : IList) : void;
		
		[Bindable(event="propertyChange")]
		function get instruction() : String;
		
		function trySaveAnswers() : Boolean;
	}
}