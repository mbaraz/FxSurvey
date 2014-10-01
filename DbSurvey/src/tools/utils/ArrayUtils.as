package tools.utils
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import vo.AnswerVariant;
	
	public class ArrayUtils
	{
/*		public static function orderAnswers(ac : IList, index : int) : IList {
			var result : IList;
			switch (index) {
				case 0 :
					result = ac;
					break;
				case 1 :
					result = riffle(ac);
					break;
				case 2 :
					result = riffle(ac, true);
			}
			return result;
		}
		
		private static function riffle(ac : IList, isShifted : Boolean = false) : IList {
			var resultArray : Array = new Array(ac.length);
			var riffleArray : Array = [];
			for (var i : int = 0; i < ac.length; i++) {
				var variant : AnswerVariant = ac.getItemAt(i) as AnswerVariant;
				if (variant.IsUnmoved)
					resultArray[i] = variant;
				else
					riffleArray.push(variant);
			}
			if (isShifted)
				shift(riffleArray);
			else
				shuffle(riffleArray);
			
			i = 0;
			for (var j : int = 0; j < ac.length; j++)
				if (!resultArray[j])
					resultArray[j] = riffleArray[i++];
			
			return new ArrayCollection(resultArray);
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
			var l : int = Math.floor(Math.random() * array.length);			//	(array.length - 1)) + 1;
			for (var i : int = 0; i < l; i++) {
				var temp : AnswerVariant = array.pop();
				array.unshift(temp);
			}
		}*/
	}
}