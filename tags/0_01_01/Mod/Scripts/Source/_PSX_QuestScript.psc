Scriptname _PSX_QuestScript extends Quest  

float Property CurrentVersion = 0.0101 AutoReadonly
float previousVersion

string Property ModName = "Poisoning Extended SE" AutoReadonly
string Property LogName = "PoisoningExtended" AutoReadonly

int Property C_CONFIRM_POISON_NEVER = 0 AutoReadonly
int Property C_CONFIRM_POISON_BENEFICIAL = 1 AutoReadonly
int Property C_CONFIRM_POISON_NEWPOISON = 2 AutoReadonly
int Property C_CONFIRM_POISON_ALWAYS = 3 AutoReadonly

int Property C_CONFIRM_CLEAN_NEVER = 0 AutoReadonly
int Property C_CONFIRM_CLEAN_ALWAYS = 1 AutoReadonly

GlobalVariable Property _PSX_ConfirmPoison Auto
int priConfirmPoison
int Property ConfirmPoison
	int function get()
		return priConfirmPoison
	endFunction
	function set(int val)
		_PSX_ConfirmPoison.SetValue(val as int)
		priConfirmPoison = val
	endFunction
endProperty

GlobalVariable Property _PSX_ConfirmClean Auto
int priConfirmClean
int Property ConfirmClean
	int function get()
		return priConfirmClean
	endFunction
	function set(int val)
		_PSX_ConfirmClean.SetValue(val as int)
		priConfirmClean = val
	endFunction
endProperty

GlobalVariable Property _PSX_KeycodePoisonLeft  Auto
int priKeycodePoisonLeft
int Property KeycodePoisonLeft
	int function get()
		return priKeycodePoisonLeft
	endFunction
	function set(int val)
		_PSX_KeycodePoisonLeft.SetValue(val as int)
		priKeycodePoisonLeft = val
	endFunction
endProperty

GlobalVariable Property _PSX_KeycodePoisonRght  Auto
int priKeycodePoisonRght
int Property KeycodePoisonRght
	int function get()
		return priKeycodePoisonRght
	endFunction
	function set(int val)
		_PSX_KeycodePoisonRght.SetValue(val as int)
		priKeycodePoisonRght = val
	endFunction
endProperty

GlobalVariable Property _PSX_ChargesPerPoisonVial  Auto
int priChargesPerPoisonVial
int Property ChargesPerPoisonVial
	int function get()
		return priChargesPerPoisonVial
	endFunction
	function set(int val)
		_PSX_ChargesPerPoisonVial.SetValue(val as int)
		priChargesPerPoisonVial = val
	endFunction
endProperty

GlobalVariable Property _PSX_ChargeMultiplier  Auto
int priChargeMultiplier
int Property ChargeMultiplier
	int function get()
		return priChargeMultiplier
	endFunction
	function set(int val)
		_PSX_ChargeMultiplier.SetValue(val as int)
		priChargeMultiplier = val
	endFunction
endProperty

GlobalVariable Property _PSX_ShowWidgets Auto
bool priShowWidgets
bool Property ShowWidgets
	bool function get()
		return priShowWidgets
	endFunction
	function set(bool val)
		_PSX_ShowWidgets.SetValue(val as int)
		priShowWidgets = val
		UpdatePoisonWidgets()
	endFunction
endProperty

GlobalVariable Property _PSX_DebugToFile Auto
bool priDebugToFile
bool Property DebugToFile
	bool function get()
		return priDebugToFile
	endFunction
	function set(bool val)
		_PSX_DebugToFile.SetValue(val as int)
		priDebugToFile = val
	endFunction
endProperty

Perk Property ConcentratedPoison  Auto

Perk Property _KLV_StashRefPerk  Auto
Sound Property _PSX_PoisonUse Auto
Sound Property _PSX_PoisonRemove  Auto
Message Property _PSX_ConfirmPoisonMsg  Auto
Message Property _PSX_ConfirmCleanMsg  Auto
Message Property _PSX_ConfirmPoisonBeneficialMsg  Auto
Message Property _PSX_ConfirmPoisonTopupMsg  Auto

ObjectReference Property TargetRef Auto
Actor Property PlayerRef Auto


Actor WornObjectSubject
string currentMenu
bool handlingKeypress
Potion lastUsedLeft
Potion lastUsedRght



event OnInit()

	Update()

endEvent

function Update()

	; floating-point math is hard..  let's go shopping!
	int iPreviousVersion = (PreviousVersion * 10000) as int
	int iCurrentVersion = (CurrentVersion * 10000) as int

	if (iCurrentVersion != iPreviousVersion)

		;;;;;;;;;;;;;;;;;;;;;;;;;;
		; version-specific updates
		;;;;;;;;;;;;;;;;;;;;;;;;;;

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		; end version-specific updates
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; notify current version
		string msg = ModName
		if (PreviousVersion > 0)
			msg += " updated from v" + GetVersionAsString(PreviousVersion) + " to "
		else
			msg += " running "
		endIf
		msg += "v" + GetVersionAsString(CurrentVersion)
		DebugStuff(msg, msg, true)

		PreviousVersion = CurrentVersion
	endIf

	Maintenance()

endFunction

Function Maintenance()

	Debug.OpenUserLog(LogName)

	ConfirmPoison = _PSX_ConfirmPoison.GetValue() as int
	ConfirmClean = _PSX_ConfirmClean.GetValue() as int
	KeycodePoisonLeft = _PSX_KeycodePoisonLeft.GetValue() as int
	KeycodePoisonRght = _PSX_KeycodePoisonRght.GetValue() as int
	ChargesPerPoisonVial = _PSX_ChargesPerPoisonVial.GetValue() as int
	ChargeMultiplier = _PSX_ChargeMultiplier.GetValue() as int
	if (ChargeMultiplier == 1)
		ChargeMultiplier = GetDefaultChargeMultiplier()
	endIf
	ShowWidgets = _PSX_ShowWidgets.GetValue() as bool
	DebugToFile = _PSX_DebugToFile.GetValue() as bool

	RegisterForMenu("InventoryMenu")
	RegisterForMenu("ContainerMenu")
	RegisterForMenu("FavoritesMenu")

	RegisterForModEvent("_KLV_ContainerActivated", "OnContainerActivated")

	if (!PlayerRef.HasPerk(_KLV_StashRefPerk))
		PlayerRef.AddPerk(_KLV_StashRefPerk)
	endIf

	handlingKeypress = false

	UpdatePoisonWidgets()

endFunction


event OnContainerActivated(Form akTargetRef)
	string msg
	TargetRef = akTargetRef as ObjectReference
	if (!TargetRef)
		msg = "OnContainerActivated - could not set TargetRef"
		DebugStuff(msg)
		return
	else
		Actor tActor = TargetRef as Actor
		if (tActor)
			msg = "TargetRef set to " + tActor.GetLeveledActorBase().GetName()
		else
			msg = "TargetRef set to " + TargetRef.GetBaseObject().GetName()
		endIf
	endIf
	DebugStuff(msg)
endEvent

event OnMenuOpen(string a_MenuName)

	currentMenu = a_MenuName
	string msg = "Opened " + currentMenu
	if (currentMenu == "InventoryMenu" || currentMenu == "FavoritesMenu")
		WornObjectSubject = PlayerRef
	elseIf (currentMenu == "ContainerMenu")
		; sometimes the container opens before the activate script has run
		; give the script 1s to settle
		int i = 10
		while (!TargetRef && i)
			Utility.WaitMenuMode(0.1)
			i -= 1
		endWhile
	
		if (!TargetRef)
			msg = "Can't find target for " + currentMenu + " - can't continue"
			DebugStuff(msg, "Can't resolve target - extended functions will not be available", true)
			return
		endIf
	
		if (TargetRef.GetType() == 28) ; Container is type 28
			WornObjectSubject = None
		else
			WornObjectSubject = TargetRef as Actor
		endIf
	endIf

	if (WornObjectSubject)
		msg += " of " + WornObjectSubject.GetLeveledActorBase().GetName()
	elseIf (TargetRef)
		msg += " of " + TargetRef.GetBaseObject().GetName()
	else
		msg += " (of nothing)"
	endIf
	DebugStuff(msg)

	string[] args = new string[2]
	args[0] = "poisonMonitorContainer"
	args[1] = "5"

	UI.InvokeStringA(currentMenu, "_root.createEmptyMovieClip", args)
	if (currentMenu == "FavoritesMenu")
		UI.InvokeString(currentMenu, "_root.poisonMonitorContainer.loadMovie", "PoisonFavMenuMonitor.swf")
	else
		UI.InvokeString(currentMenu, "_root.poisonMonitorContainer.loadMovie", "PoisonMonitor.swf")
	endIf

	handlingKeypress = false
	lastUsedLeft = None
	lastUsedRght = None
	RegisterForKey(KeycodePoisonLeft) ; direct LH poison
	RegisterForKey(KeycodePoisonRght) ; direct RH poison
	
	RegisterForModEvent("_psx_selectionChanged", "OnItemSelectionChange")
	RegisterForModEvent("_psx_tabChanged", "OnTabChange")
	RegisterForModEvent("_psx_requestedFormSent", "OnRequestedFormSent")

endEvent

event OnTabChange(string asEventName, string asStrArg, float afNumArg, Form akSender)
	string msg = "Showing tab " + afNumArg
	if (afNumArg == 1)
		WornObjectSubject = PlayerRef
	else
		WornObjectSubject = TargetRef as Actor
	endIf
	if (WornObjectSubject)
		msg += " (" + WornObjectSubject.GetLeveledActorBase().GetName() + ")"
	elseIf(TargetRef)
		msg += " (" + TargetRef.GetBaseObject().GetName() + ")"
	endIf
	DebugStuff(msg)
endEvent

event OnItemSelectionChange(string asEventName, string asStrArg, float afNumArg, Form akSender)

	if (!WornObjectSubject || asStrArg != "weapon")
		return
	endIf

	int currentEquipSlot = afNumArg as int
	if (currentEquipSlot == 2)
		; bows are UI state 2, but count as slot 1 for WornObject
		currentEquipSlot = 1
	endIf

	Potion currentPoison = _Q2C_Functions.WornGetPoison(WornObjectSubject, currentEquipSlot)
	if (!currentPoison)
		return
	endIf

	string msg = currentPoison.GetName()
	int currentCharges = _Q2C_Functions.WornGetPoisonCharges(WornObjectSubject, currentEquipSlot)
	if (currentCharges > 1)
		msg += " (" + currentCharges + ")"
	endIf
	UI.SetString(currentMenu, "_root.Menu_mc.itemCard.PoisonInstance._poisonData.text", msg)

	; DebugStuff("OnItemSelectionChange (" + currentMenu + ") - item " + asStrArg + " in slot " + currentEquipSlot + " is " + akSender.GetName() + ", has " + msg)
	
endEvent

event OnKeyDown(int aiKeyCode)

	if (handlingKeypress)
		return
	endIf

	handlingKeypress = true
	
	if (!WornObjectSubject || currentMenu == "")
		;DebugStuff("Not a person's inventory", "Not a person's inventory")
		handlingKeypress = false
		return
	endIf

	if (WornObjectSubject != PlayerRef && !WornObjectSubject.IsPlayerTeammate())
		DebugStuff("Can't command non-teammates!", "Can't command non-teammates!")
		handlingKeypress = false
		return
	endIf

	if (aiKeyCode == KeycodePoisonLeft || aiKeyCode == KeycodePoisonRght)
		if (currentMenu == "FavoritesMenu")
			UI.InvokeInt(currentMenu, "_global.Main.poisonFavMenuMonitor.getCurrentForm", aiKeyCode)
		else
			UI.InvokeInt(currentMenu, "_global.Main.poisonMonitor.getCurrentForm", aiKeyCode)
		endIf
	else
		handlingKeypress = false
	endIf

endEvent

event OnRequestedFormSent(string asEventName, string asStrArg, float afNumArg, Form akSender)

	; DebugStuff("OnRequestedFormSent - raw trace.. asEventName: " + asEventName + "; asStrArg: " + asStrArg + "; afNumArg: " + afNumArg + "; akSender: " + akSender)

	int pressedKey = afNumArg as int
	if (pressedKey < 1 || !akSender)
		DebugStuff("OnRequestedFormSent - key " + pressedKey + ", form " + akSender)
		handlingKeypress = false
		return
	endIf

	int currentEquipSlot = 0
	if (pressedKey == KeycodePoisonRght)
		currentEquipSlot = 1
	endIf

	Potion toUse = akSender as Potion
	if (!toUse && Math.RightShift(akSender.GetFormID(), 24) >= 255)
		if (lastUsedLeft && pressedKey == KeycodePoisonLeft && WornObjectSubject.GetItemCount(lastUsedLeft) > 0)
			toUse = lastUsedLeft
		elseIf (lastUsedRght && pressedKey == KeycodePoisonRght && WornObjectSubject.GetItemCount(lastUsedRght) > 0)
			toUse = lastUsedRght
		endIf
	endIf
	if (toUse)
		DirectPoison(toUse, currentEquipSlot)
	elseIf (akSender as Weapon)
		RemovePoison(akSender as Weapon)
	else
		DebugStuff("OnRequestedFormSent - not a potion or weapon")
	endIf

	handlingKeypress = false

endEvent

event OnMenuClose(string a_MenuName)
	UnregisterForModEvent("_psx_selectionChanged")
	UnregisterForModEvent("_psx_tabChanged")
	UnregisterForModEvent("_psx_requestedFormSent")
	UnregisterForKey(KeycodePoisonLeft)
	UnregisterForKey(KeycodePoisonRght)
	currentMenu = ""
	TargetRef = None
	handlingKeypress = false
	lastUsedLeft = None
	lastUsedRght = None
	DebugStuff("Closed " + a_MenuName)
	UpdatePoisonWidgets()
endEvent


Function DirectPoison(Potion akPoison, int aiHand)

	if (aiHand != 0 && aiHand != 1)
		string msg = "Can't get weapon in " + GetHandName(aiHand) + " hand"
		DebugStuff(msg, msg)
		return
	endIf

	if (akPoison.IsFood())
		string msg = "Cannot poison a weapon with food"
		DebugStuff(msg, msg)
		return
	endIf

	Weapon actorWeapon = WornObjectSubject.GetEquippedWeapon(aiHand == 0)
	if (!actorWeapon)
		string msg = "No weapon to poison in " + GetHandName(aiHand) + " hand"
		DebugStuff(msg, msg)
		return
	endIf

	Potion currentPoison = _Q2C_Functions.WornGetPoison(WornObjectSubject, aiHand)
	if (currentPoison && currentPoison != akPoison)
		string msg = "The current weapon is already poisoned with " + currentPoison.GetName()
		DebugStuff(msg, msg)
		return
	endIf
	
	if (currentPoison)
		if (ConfirmPoison == C_CONFIRM_POISON_ALWAYS)
			int conf = _PSX_ConfirmPoisonTopupMsg.Show()
			if (conf != 0)
				return
			endIf
		endIf
	elseIf (!akPoison.IsPoison() && ConfirmPoison != C_CONFIRM_POISON_NEVER)
		int conf = _PSX_ConfirmPoisonBeneficialMsg.Show()
		if (conf != 0)
			return
		endIf
	elseIf (ConfirmPoison == C_CONFIRM_POISON_ALWAYS || ConfirmPoison == C_CONFIRM_POISON_NEWPOISON)
		int conf = _PSX_ConfirmPoisonMsg.Show()
		if (conf != 0)
			return
		endIf
	endIf

	int chargesToSet = ChargesPerPoisonVial * ChargeMultiplier
	int newCharges = -1
	if (currentPoison)
		chargesToSet += _Q2C_Functions.WornGetPoisonCharges(WornObjectSubject, aiHand)
		newCharges = _Q2C_Functions.WornSetPoisonCharges(WornObjectSubject, aiHand, chargesToSet)
	else
		newCharges = _Q2C_Functions.WornSetPoison(WornObjectSubject, aiHand, akPoison, chargesToSet)
	endIf
	if (aiHand == 0)
		lastUsedLeft = akPoison
	else
		lastUsedRght = akPoison
	endIf
	WornObjectSubject.RemoveItem(akPoison, 1, true)
	_PSX_PoisonUse.Play(playerRef)

	string wpnName = actorWeapon.GetName()
	string psnName = akPoison.GetName()
	string notify = wpnName + " poisoned with " + psnName
	string trace = WornObjectSubject.GetLeveledActorBase().GetName() + "'s " + wpnName + " in " + GetHandName(aiHand) + " hand has " + newCharges + " (should be " + chargesToSet + ")" + " of " + psnName
	DebugStuff(trace, notify)

endFunction

Function RemovePoison(Weapon akWeapon)

	int currentEquipSlot = 0
	if (currentMenu == "FavoritesMenu")
		currentEquipSlot = UI.GetInt(currentMenu, "_root.MenuHolder.Menu_mc.itemList.selectedEntry.equipState")
	else
		currentEquipSlot = UI.GetInt(currentMenu, "_root.Menu_mc.inventoryLists.panelContainer.itemList.selectedEntry.equipState")
	endIf

	if (currentEquipSlot < 2)
		return
	endIf
	; vals are 2,3,4 for left/right/both - remove 2 to convert to SKSE's 0/1
	currentEquipSlot -= 2
	if (currentEquipSlot == 2)
		; bows are UI state 2, but count as slot 1 for WornObject
		currentEquipSlot = 1
	endIf

	string msg
	Potion currentPoison = _Q2C_Functions.WornGetPoison(WornObjectSubject, currentEquipSlot)
	if (!currentPoison)
		msg = "Weapon in " + GetHandName(currentEquipSlot) + " hand is not poisoned"
		DebugStuff(msg, msg)
		return
	endIf

	if (ConfirmClean == C_CONFIRM_CLEAN_ALWAYS)
		int conf = _PSX_ConfirmCleanMsg.Show()
		if (conf != 0)
			return
		endIf
	endIf

	int currentCharges = _Q2C_Functions.WornGetPoisonCharges(WornObjectSubject, currentEquipSlot)
	_Q2C_Functions.WornRemovePoison(WornObjectSubject, currentEquipSlot)
	_PSX_PoisonRemove.Play(playerRef)

	if (currentMenu != "FavoritesMenu")
		; clear poison indicators on ItemCard
		UI.SetString(currentMenu, "_root.Menu_mc.itemCard.PoisonInstance._poisonData.text", "")
		UI.InvokeString(currentMenu, "_root.Menu_mc.itemCard.PoisonInstance.gotoAndStop", "Off")
		; No point doing it in ListEntry, as that is only refreshed when state changes
		; could try to run requestInvalidate to rebuild everything..?
		UI.Invoke(currentMenu, "_root.Menu_mc.inventoryLists.itemList.requestInvalidate")
		UI.Invoke(currentMenu, "_root.Menu_mc.inventoryLists.InvalidateListData")
	endIf

	string wpnName = akWeapon.GetName()
	string psnName = currentPoison.GetName()
	string notify = "Removed " + psnName + " from " + wpnName
	msg = "Removed " + currentCharges + " of " + psnName + " from " + WornObjectSubject.GetLeveledActorBase().GetName() + "'s " + wpnName
	DebugStuff(msg, notify)

endFunction

function UpdatePoisonWidgets()

	if (ShowWidgets)
		UpdatePoisonWidget(0)
		UpdatePoisonWidget(1)
		SendModEvent("_PSX_SetVisibility", "visible")
	else
		SendModEvent("_PSX_SetVisibility", "hidden")
	endIf

endFunction

function UpdatePoisonWidget(int aiHand)

	string eventName = "_PSX_SetPoisonText" + GetHandName(aiHand)
	Potion currentPoison = _Q2C_Functions.WornGetPoison(playerRef, aiHand)
	if (!currentPoison)
		SendModEvent(eventName, "")
	else
		string poisonName = currentPoison.GetName()
		int charges = _Q2C_Functions.WornGetPoisonCharges(playerRef, aiHand)
		if (charges > 1)
			poisonName += " (" + charges + ")"
		endIf
		SendModEvent(eventName, poisonName)
	endIf

endFunction


int function GetDefaultChargeMultiplier()
	if (PlayerRef.HasPerk(ConcentratedPoison))
		return 2
	endIf
	return 1
endFunction

string function GetHandName(int aiHand)
	if (aiHand == 0)
		return "left"
	elseIf (aiHand == 1)
		return "right"
	endIf
	return "unknown"
endFunction

string function GetVersionAsString(float afVersion)

	string raw = afVersion as string
	int dotPos = StringUtil.Find(raw, ".")
	string major = StringUtil.SubString(raw, 0, dotPos)
	string minor = StringUtil.SubString(raw, dotPos + 1, 2)
	string revsn = StringUtil.SubString(raw, dotPos + 3, 2)
	return major + "." + minor + "." + revsn

endFunction

function DebugStuff(string asLogMsg, string asScreenMsg = "", bool abPrefix = false)

	if (DebugToFile)
		Debug.TraceUser(LogName, asLogMsg)
	endIf
	if (asScreenMsg != "")
		if (abPrefix)
			asScreenMsg = ModName + " - " + asScreenMsg
		endIf
		Debug.Notification(asScreenMsg)
	endIf

endFunction
