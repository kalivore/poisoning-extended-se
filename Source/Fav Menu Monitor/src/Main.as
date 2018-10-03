/**
 * ...
 * @author 
 */

import skyui.components.list.ScrollingList;

class Main 
{
	public static var poisonFavMenuMonitor:PoisonFavMenuMonitor;
	
	public static function main(swfRoot:MovieClip):Void 
	{
		var itemList:ScrollingList = swfRoot._parent.MenuHolder.Menu_mc.itemList;
		
		/*
		skse.Log("List members..");
		for (var obj in swfRoot._parent.MenuHolder.Menu_mc)
		{
			skse.Log("Found " + obj + ": " + swfRoot._parent.MenuHolder.Menu_mc[obj]);
		}
		*/
		
		poisonFavMenuMonitor = new PoisonFavMenuMonitor(itemList);
	}
	
	public function Main() 
	{
	}
}