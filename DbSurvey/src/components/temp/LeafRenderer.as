package components.temp
{
	import components.editor.ButtonRow;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.*;
	import mx.controls.treeClasses.*;
	
	public class LeafRenderer extends TreeItemRenderer {
		private var btnRow : ButtonRow;
		
		public function LeafRenderer() {
		}
/*		
		private function helpEvent(event:Event):void {
			var e:FormatHelpEvent = new FormatHelpEvent("formatHelp");
			dispatchEvent(e);
		}
*/		
		override protected function createChildren() : void {
			super.createChildren();
			btnRow = new ButtonRow();
//			btnRow.addEventListener(MouseEvent.CLICK,helpEvent,true);
			addChild(btnRow);
		}
		
		override protected function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void {
			var treeListData : TreeListData=TreeListData(listData);
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(treeListData.hasChildren) {
				setStyle("fontWeight", "bold");
//				this.label.text = this.label.text.toUpperCase();
				btnRow.visible = true;
			} else {
				setStyle("fontWeight", "normal");
				icon.visible=true;
				btnRow.width=20;
				btnRow.height=20;
				btnRow.visible = true;
				btnRow.x = label.textWidth + label.x + 5;
			}
		}
	}
}