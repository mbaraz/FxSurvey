package tools.utils
{
	import mx.collections.ArrayCollection;
	
	import vo.AnswerVariant;
	
	public class ArrayUtils
	{
/*		public static function riffle(ac : ArrayCollection, isShifted : Boolean = false) : void {
			var src : Array = [];
			for each (var variant : AnswerVariant in ac)
				if (!variant.IsUnmoved)
					src.push(variant);
			if (isShifted)
				shift(src);
			else
				shuffle(src);
			var i : int = 0;
			for (var j : int = 0; j < ac.length; j++)
				if (!ac.getItemAt(j).IsUnmoved)
					ac.setItemAt(src[i++], j);
			ac.refresh();
		}
		
		private static function shuffle(array : Array) : void {
			var m : int = array.length;
			var i : int;
			var t : *;
			while (m) {
				i = Math.floor(Math.random() * m--);
				t = array[m];
				array[m] = array[i];
				array[i] = t;
			}
		}
		
		private static function shift(array : Array) : void {
			var l : int = Math.floor(Math.random() * (array.length - 1)) + 1;
			for (var i : int = 0; i < l; i++) {
				var temp : AnswerVariant = array.pop();
				array.unshift(temp);
			}
		}*/
	}
}