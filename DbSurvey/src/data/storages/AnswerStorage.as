package data.storages
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import vo.AnswerVariant;

	public class AnswerStorage extends EventDispatcher implements IStorage
	{
		public var answersCollection : ArrayCollection; /* of ArrayCollection of AnswerVariant */

		private var _currentVariants : ArrayCollection; /* of AnswerVariant */;
		
		[Bindable(event="propertyChange")]
		public function get currentVariants() : ArrayCollection {
			return _currentVariants;
		}

		public function get currentIndex() : int {
			return answersCollection.getItemIndex(currentVariants);
		}

		private function get selectedIndex() : int {
			return currentVariants.getItemIndex(_selectedVariant);
		}
		
		private var _selectedVariant : AnswerVariant;
	
		[Bindable(event="propertyChange")]
		public function get selectedItem() : Object{
			return _selectedVariant;
		}
		
		public function set selectedItem(value : Object) : void {
			_selectedVariant = value as AnswerVariant;
		}

		public function get answerObjects() : Array {
			var result : Array = [];
			for each (var variants : ArrayCollection in answersCollection) {
				var objects : Array = [];
				for each (var variant : AnswerVariant in variants)
					objects.push(variant.variantObject);
					
				result.push(objects);
			}
			return result;
		}

		public function get responseObject() : Object {
			if (!currentVariants)
				return null;
			
			var result : Object = {QuestionId : 0, Answers : [], OpenAnswers : [], Rank : []};
			for each (var variant : AnswerVariant in currentVariants)
				variant.updateResponse(result);
				
			return result;
		}

		public function AnswerStorage() {
			answersCollection = new ArrayCollection();
		}
/* FOR DESIGNER */
		public function selectVariant(indx : int) : void {
			_selectedVariant = currentVariants.getItemAt(indx) as AnswerVariant;
			dispatchEvent(new Event("propertyChange"));
		}

		public function addNewVariants(indx : int) : void {
			answersCollection.addItemAt(new ArrayCollection(), indx);
//			setCurrentVariantsByIndex(indx);
		}

		public function addNewVariant() : void {
			var variant : AnswerVariant;
			if (selectedIndex > -1) {
				variant = AnswerVariant.getEmptyVariant(selectedIndex + 2);
				currentVariants.addItemAt(variant, selectedIndex + 1);
				for (var i : int = selectedIndex + 2; i < currentVariants.length; i++)
					currentVariants.getItemAt(i).order++;
			} else {
				variant = AnswerVariant.getEmptyVariant(currentVariants.length + 1);
				currentVariants.addItem(variant);
			}
			_selectedVariant = variant;
			dispatchEvent(new Event("propertyChange"));
		}
		
		public function removeSelectedVariant() : void {
			var indx : int = selectedIndex;
			currentVariants.removeItemAt(indx);
			for (var i : int = indx; i < currentVariants.length; i++)
				currentVariants.getItemAt(i).order--;
			if (indx == currentVariants.length) indx--;
			_selectedVariant = indx > -1 ? currentVariants.getItemAt(indx) as AnswerVariant : null;
//			dispatchEvent(new Event("propertyChange"));
		}
		
		public function removeCurrentVariants() : void {
			var indx : int = currentIndex;
			answersCollection.removeItemAt(indx);
			setCurrentVariantsByIndex(indx < answersCollection.length ? indx : indx - 1);
		}

		public function swap(isUp : Boolean) : void {
			var slctdIndx: int = selectedIndex;
			var index : int = isUp ? slctdIndx - 1 : slctdIndx + 1;
			var temp : Object = currentVariants.getItemAt(index);
			var selectedItem : Object = currentVariants.getItemAt(slctdIndx);
			temp.order = slctdIndx + 1;
			selectedItem.order = index + 1;
			currentVariants.disableAutoUpdate();
			currentVariants.setItemAt(selectedItem, index);
			currentVariants.setItemAt(temp, slctdIndx);
			currentVariants.enableAutoUpdate();
			selectVariant(index);
//			_collection.refresh();
		}
		
		public function swapVariants(isUp : Boolean) : void {
			var selectedIndex : int = currentIndex;
			var index : int = isUp ? selectedIndex - 1 : selectedIndex + 1;
			var temp : Object = answersCollection.getItemAt(index);
			var selectedItem : Object = answersCollection.getItemAt(selectedIndex);
			answersCollection.setItemAt(selectedItem, index);
			answersCollection.setItemAt(temp, selectedIndex);
		}
		
		public function addVariants(variants : ArrayCollection) : void {
			answersCollection.addItem(variants);
		}
		
		public function addVariantsAt(variants : Array, indx : int) : void {
			var selectedVariants : ArrayCollection = answersCollection.getItemAt(indx) as ArrayCollection;
			selectedVariants.addAll(makeVariantsList(variants, selectedVariants.length + 1));
		}
		
		public function getCodesArray(indx : int) : Array {
			var result : Array = [];
			var variants : Array = answersCollection.getItemAt(indx).source;
			for each (var variant : AnswerVariant in variants)
				if (result.indexOf(variant.AnswerCode) == -1)
					result.push(variant.AnswerCode);
				
			return result;
		}
		
		public function updateVariantsByQuestionType(type : String) : void {
			for each (var variant : AnswerVariant in currentVariants)
				variant.updateByQuestionType(type);
		}

		public function updateVariantsByPlurality(isAllowed : Boolean) : void {
			for each (var variant : AnswerVariant in currentVariants)
				variant.updateByPlurality(isAllowed);
		}
		
		private function makeVariantsList(variants : Array, startIndex : int) : ArrayList {
			var result : ArrayList = new ArrayList();
			for (var i : int = 0; i < variants.length; i++) {
				var str : String = variants[i];
				if (!str)
					continue;
				result.addItem(new AnswerVariant({SurveyQuestionId : 40107, AnswerText : str, AnswerOrder : startIndex + i}));
			}
			return result;
		}

/* FOR BOTH */		
		public function setCurrentVariantsByIndex(indx : int) : void {
			_currentVariants = indx > -1 ? answersCollection.getItemAt(indx) as ArrayCollection : null;
			dispatchEvent(new Event("propertyChange"));
		}
/* FOR SURVEY */			
		public function insertVariants(variants : ArrayCollection) : void {
			answersCollection.addItemAt(variants, currentIndex + 1);
		}
		
		public function setVariants(variants : ArrayCollection) : void {
			answersCollection.setItemAt(variants, currentIndex + 1);
		}
/* FOR SURVEY EMULATOR */		
		public function filterVariants(filterTagArray : Array) : void {
			var isFilterPresent : Boolean = filterTagArray[0] > -1;
			var responses : Array = isFilterPresent ? getResponseByIndex(filterTagArray) : null;
			_currentVariants.filterFunction = isFilterPresent ? filterFunction : null;
			_currentVariants.refresh();
			
			function filterFunction(item : Object) : Boolean {
				return item.TagValue == "Нет" || responses.indexOf(int(item.TagValue)) > -1;
			}
		}
		
		public function getResponseByIndex(indexes : Array) : Array {
			var result : Array = [];
			var index : int = int(indexes[0]);
			var subIndex : int = indexes.length > 1 ? indexes[1] : -1;
			if (index < 0)
				return result;
			var variants : ArrayCollection = answersCollection.getItemAt(index) as ArrayCollection;
			for each (var variant : AnswerVariant in variants) {
				var answerCode : int = variant.Response;
				if (!answerCode)
					continue;
				if (subIndex == -1)
					result.push(answerCode);
				else {
					var subOrders : Array = variant.Value.split(",");
					if (subOrders.indexOf(subIndex.toString()) > -1)
						result.push(answerCode);
				}
			}
			return result.sort(Array.NUMERIC);
		}
/*		LOOK
		public function riffleVariants(index : int) : void {
			switch (index) {
				case 0 :
					return;
				case 1 :
					ArrayUtils.riffle(_currentVariants);
					break;
				case 2 :
					ArrayUtils.riffle(_currentVariants, true);
			}
		}*/
	}
}