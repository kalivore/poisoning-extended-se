/**
 * ...
 * @author 
 */

import skyui.components.list.TabularList;

class Main 
{
	public static var poisonMonitor:PoisonMonitor;
	
	public static function main(swfRoot:MovieClip):Void 
	{
		var itemList:TabularList = swfRoot._parent.Menu_mc.inventoryLists.itemList;
		var itemCard:Object = swfRoot._parent.Menu_mc.itemCard;
		var tabBar:Object = swfRoot._parent.Menu_mc.inventoryLists.tabBar;
		
		poisonMonitor = new PoisonMonitor(itemList, itemCard, tabBar);
	}
	
	public function Main() 
	{
	}
}