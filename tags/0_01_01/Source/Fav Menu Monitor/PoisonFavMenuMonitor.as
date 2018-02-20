
import gfx.io.GameDelegate;
import skyui.components.list.BasicList;
import skyui.components.TabBar;
import Shared.GlobalFunc;

class PoisonFavMenuMonitor
{
	private var _list:BasicList;
	
	private var _poisonData:TextField;
	private var _countFormat:TextFormat;
	
	public var Test:String;
	
	public function PoisonFavMenuMonitor(list:BasicList)
	{
		_list = list;
		
		// can actually just return here, since the list has no indication of whether items 
		// are poisoned are not, which makes item monitoring a bit redundant..
		return;
		
		
		
		
		if (_list) {
			_list.addEventListener("selectionChange", this, "onItemListSelectionChange");
			_list.addEventListener("itemPress", this, "onItemPress");
			_list.addEventListener("itemPressAux", this, "onItemPressAux");
		}
		
		this.constructTextFormat();
		// this.constructPoisonData();
		
		// skse.Log("PoisonFavMenuMonitor loaded in: " + _list);
		
		if (_list.selectedEntry != null)
		{
			this.updateSelected("Init");
		}
	}

	public function onItemListSelectionChange(event: Object): Void
	{
		var index = event.index;
		
		if (_list.selectedEntry != null)
		{
			this.updateSelected("Selx");
		}
	}
	
	public function onItemPress(event: Object): Void
	{
		var index = event.index;
		//skyui.util.Debug.dump("onItemPress", event);

		if (_list.selectedEntry != null)
		{
			this.updateSelected("Pres");
		}
	}
	
	public function onItemPressAux(event: Object): Void
	{
		var index = event.index;
		//skyui.util.Debug.dump("onItemPressAux", event);
		if (_list.selectedEntry != null)
		{
			this.updateSelected("Pres");
		}
	}
	
	public function updateSelected(source:String)
	{
/*
		skse.Log("List props..");
		for (var prop in _list.selectedEntry)
		{
			skse.Log(prop + ": " + _list.selectedEntry[prop]);
		}
*/
		_poisonData.text = "";
		_poisonData._visible = false;
		
		// no isPoisoned indication, boo :(
		if (_list.selectedEntry.formType == 41 && _list.selectedEntry.equipState > 1)
		{
			if (!_poisonData) {
				//this.constructPoisonData();	
			}
/*
			skse.Log("Selected weapon " + _list.selectedEntry.text + " (" + _list.selectedEntry.formId + "):- " +
					" of type: " + _list.selectedEntry.formType + 
					", is equipped: " + _list.selectedEntry.equipState > -1 + 
					", is poisoned: " + _list.selectedEntry.isPoisoned + 
					", in hand " + (_list.selectedEntry.equipState - 2));
*/
			skse.SendModEvent("_psx_selectionChanged", "weapon", (_list.selectedEntry.equipState - 2), _list.selectedEntry.formId);
			_poisonData._visible = true;
		}
	}

	public function getCurrentForm(keyCode:Number)
	{
		//skyui.util.Debug.dump("getCurrentForm", _list.selectedEntry);
		
		var isWeapon = _list.selectedEntry.formType == 41 && _list.selectedEntry.equipState > -1
		var isPotion = _list.selectedEntry.formType == 46
		if (isWeapon || isPotion)
		{
			skse.SendModEvent("_psx_requestedFormSent", isWeapon ? "weapon" : "potion", keyCode, _list.selectedEntry.formId);
		}
		else
		{
			skse.SendModEvent("_psx_requestedFormSent", "", -1);
		}
	}
	

	private function constructTextFormat() {
		_countFormat = new TextFormat();
		_countFormat.font = "$EverywhereFont";
		_countFormat.color = 0x00FF00;
		_countFormat.size = 60;
	}
	
	private function constructPoisonData() {
		
		//if (!_poisonInst) {
			//_poisonInst = ???.PoisonInstance;
		//}
		
		//_poisonData = _poisonInst.createTextField("_poisonData", 2, 190, -112, 1000, 100);
		_poisonData.setNewTextFormat(_countFormat);
		_poisonData.textAutoSize = "shrink";
		_poisonData.verticalAlign = "center";
		//_poisonData.background = true;
		//_poisonData.backgroundColor = 0xf984de;
		_poisonData._visible = false;
	}
}