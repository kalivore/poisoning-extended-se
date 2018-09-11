
import gfx.io.GameDelegate;
import skyui.components.list.BasicList;
import skyui.components.TabBar;
import Shared.GlobalFunc;

class PoisonMonitor
{
	private var _list:BasicList;
	private var _itemCard:Object;
	private var _tabBar:Object;
	
	private var _poisonInst:MovieClip;
	private var _poisonData:TextField;
	private var _countFormat:TextFormat;
	
	public var Test:String;
	
	public function PoisonMonitor(list:BasicList, itemCard:Object, tabBar:Object)
	{
		_list = list;
		_itemCard = itemCard;
		_tabBar = tabBar;
		
		if (_list) {
			_list.addEventListener("selectionChange", this, "onItemListSelectionChange");
			_list.addEventListener("itemPress", this, "onItemPress");
			_list.addEventListener("itemPressAux", this, "onItemPressAux");
		}
		
		if (_tabBar) {
			_tabBar.addEventListener("tabPress", this, "onTabPress");
		}
		
		this.constructTextFormat();
		this.constructPoisonData();
		
		if (_list.selectedEntry != null)
		{
			this.updateSelected("Init");
		}
		
		Test = "PoisonMonitor Test";
		//skse.Log("PoisonMonitor loaded in: " + _list + ", attach to " + _itemCard);
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
	
	public function onTabPress(event: Object): Void
	{
		var index = event.index;
		//skse.Log("Now showing tab " + index);
		skse.SendModEvent("_psx_tabChanged", "", index);
	}
	
	public function updateSelected(source:String)
	{
		_poisonData.text = "";
		_poisonData._visible = false;

		// use _poisonInst._currentframe == "2" rather than _list.selectedEntry.isPoisoned, as the latter doesn't update immediately
		if (_list.selectedEntry.formType == 41 && _list.selectedEntry.isEquipped && _poisonInst._currentframe == "2")
		{
			if (!_poisonData) {
				this.constructPoisonData();	
			}
			//skse.Log("Selected weapon " + _list.selectedEntry.formId + ": " + _list.selectedEntry.text + ", in hand " + (_list.selectedEntry.equipState - 2))
			skse.SendModEvent("_psx_selectionChanged", "weapon", (_list.selectedEntry.equipState - 2), _list.selectedEntry.formId);
			_poisonData._visible = true;
		}
	}

	public function getCurrentForm(keyCode:Number)
	{
		//skyui.util.Debug.dump("getCurrentForm", _list.selectedEntry);
		
		var isWeapon = _list.selectedEntry.formType == 41 && _list.selectedEntry.isEquipped
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
		
		if (!_poisonInst) {
			_poisonInst = _itemCard.PoisonInstance;
		}
		
		_poisonData = _poisonInst.createTextField("_poisonData", 2, 190, -112, 1000, 100);
		_poisonData.setNewTextFormat(_countFormat);
		_poisonData.textAutoSize = "shrink";
		_poisonData.verticalAlign = "center";
		//_poisonData.background = true;
		//_poisonData.backgroundColor = 0xf984de;
		_poisonData._visible = false;
	}
}