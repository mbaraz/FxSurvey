package data.storages
{
	import flash.utils.Dictionary;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import vo.LogicalExpression;
	import vo.QuestionItem;
	import vo.SurveyQuestion;
	import vo.Tag;

	public class TagStorage
	{
		private var tagsCollection : ArrayCollection = new ArrayCollection(); 	/* of Tags */
		private var tagsDictionary : Dictionary = new Dictionary();
		private var unsavedCount : int = 0;

		internal function get deletedTagIds() : Array {
			var result : Array = [];
			for (var key : String in tagsDictionary) {
				var tagId : int = int(key);
				if (tagId > 0 && tagsDictionary[tagId] < 0)
					result.push(tagId);
			} 
			return result;
		}
		
		internal function addBoundedTag(question : QuestionItem, tagName : String) : void {
			if (question.hasBoundTag)
				addTag(tagName, question.BoundTagId);
		}

		internal function getTagNameById(tagId : int, order : int) : String {
			var tag : Tag = getTagById(tagId);
			return (tag && tag.canApply(order)) ? tag.TagName : "";
		}

		internal function getTagArray(max : int) : Array {	/* of SurveyQuestions and SubQuestion */
			var result : Array = [];
			for each (var tag : Tag in tagsCollection)
				if (tag && tag.canApply(max + 1))
					result.push(tag);

			return result.sortOn("boundedQuestionOrder", Array.NUMERIC);
		}

		internal function addTag(questionName : String, tagId : int = 0) : int {
			if (!tagId)
				tagId = --unsavedCount;
			
			var tag : Tag = new Tag(tagId, questionName);
			tagsDictionary[tag.TagId] = tagsCollection.length;
			tagsCollection.addItem(tag);
			return unsavedCount;
		}
		
		internal function removeTag(id : int) : void {
			var indx : int = tagsDictionary[id];
			tagsDictionary[id] = -1;
			tagsCollection.setItemAt(null, indx);
		}
		
		internal function updateNames(ids : Array, subTagIds : Array, isIncreased : Boolean) : void {
			for each (var id : int in ids)
				tagsCollection.getItemAt(tagsDictionary[id]).changeBoundedOrders(isIncreased);

			for each (id in subTagIds)
				tagsCollection.getItemAt(tagsDictionary[id]).changeBoundedQuestionOrder(isIncreased);
				
			tagsCollection.refresh();
		}

		internal function getTagById(id : int) : Tag {
			var tagIndx : int = tagsDictionary[id];
			return tagIndx < 0 ? null : tagsCollection.getItemAt(tagIndx) as Tag;
		}

		internal function addTagsChangeListener(handler : Function) : void {
			tagsCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE, handler);
		}

		internal function cleanTags() : void {
			tagsCollection = new ArrayCollection();
			tagsDictionary = new Dictionary();
			unsavedCount = 0;
		}
	}
}