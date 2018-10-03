scriptname _PSX_PoisonWidgets extends SKI_WidgetBase  

; PRIVATE VARIABLES -------------------------------------------------------------------------------

bool	_visible
string	_poisonTextLeft
string	_poisonTextRight
float 	_leftX
float 	_leftY
float 	_rightX
float 	_rightY


; PROPERTIES --------------------------------------------------------------------------------------

bool Property Visible
	bool function get()
		return _visible
	endFunction

	function set(bool a_val)
		_visible = a_val
		if (Ready)
			UI.InvokeBool(HUD_MENU, WidgetRoot + ".setVisible", _visible) 
		endIf
	endFunction
endProperty

string Property PoisonTextLeft
	string function get()
		return _poisonTextLeft
	endFunction

	function set(string a_val)
		_poisonTextLeft = a_val
		if (Ready)
			UI.InvokeString(HUD_MENU, WidgetRoot + ".setPoisonTextLeft", _poisonTextLeft) 
		endIf
	endFunction
endProperty

string Property PoisonTextRight
	string function get()
		return _poisonTextRight
	endFunction

	function set(string a_val)
		_poisonTextRight = a_val
		if (Ready)
			UI.InvokeString(HUD_MENU, WidgetRoot + ".setPoisonTextRight", _poisonTextRight) 
		endIf
	endFunction
endProperty

float Property LeftX
	float function get()
		return _leftX
	endFunction

	function set(float a_val)
		_leftX = a_val
		if (Ready)
			UI.InvokeString(HUD_MENU, WidgetRoot + ".setPoisonLeftPosX", _leftX) 
		endIf
	endFunction
endProperty

float Property LeftY
	float function get()
		return _leftY
	endFunction

	function set(float a_val)
		_leftY = a_val
		if (Ready)
			UI.InvokeString(HUD_MENU, WidgetRoot + ".setPoisonLeftPosY", _leftY) 
		endIf
	endFunction
endProperty

float Property RightX
	float function get()
		return _rightX
	endFunction

	function set(float a_val)
		_rightX = a_val
		if (Ready)
			UI.InvokeString(HUD_MENU, WidgetRoot + ".setPoisonRightPosX", _rightX) 
		endIf
	endFunction
endProperty

float Property RightY
	float function get()
		return _rightY
	endFunction

	function set(float a_val)
		_rightY = a_val
		if (Ready)
			UI.InvokeString(HUD_MENU, WidgetRoot + ".setPoisonRightPosY", _rightY) 
		endIf
	endFunction
endProperty



; EVENTS ------------------------------------------------------------------------------------------

Event OnGameReload()
	; this happens before OnWidgetReset
	
	parent.OnGameReload()
	
	RegisterForModEvent("_PSX_SetVisibility", "OnSetVisibility")
	RegisterForModEvent("_PSX_SetPoisonTextLeft", "OnSetPoisonTextLeft")
	RegisterForModEvent("_PSX_SetPoisonTextRight", "OnSetPoisonTextRight")
	RegisterForModEvent("_PSX_BumpPoisonUp", "OnBumpPoisonUp")
	RegisterForModEvent("_PSX_BumpPoisonDown", "OnBumpPoisonDown")
	RegisterForModEvent("_PSX_BumpPoisonLeft", "OnBumpPoisonLeft")
	RegisterForModEvent("_PSX_BumpPoisonRight", "OnBumpPoisonRight")
	
	UpdateStatus("OnGameReload")
EndEvent

; @override SKI_WidgetBase
event OnWidgetReset()
	parent.OnWidgetReset()
	
	_leftX = 90
	_leftY = 680
	_rightX = 850
	_rightY = 680
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setPoisonLeftPosX", _leftX) 
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setPoisonLeftPosY", _leftY) 
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setPoisonRightPosX", _rightX) 
	UI.InvokeString(HUD_MENU, WidgetRoot + ".setPoisonRightPosY", _rightY) 
	
	UpdateStatus("OnWidgetReset")
endEvent


Event OnSetVisibility(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	Visible = a_strArg == "visible"
EndEvent

Event OnSetPoisonTextLeft(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	PoisonTextLeft = a_strArg
EndEvent

Event OnSetPoisonTextRight(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	PoisonTextRight = a_strArg
EndEvent


Event OnBumpPoisonUp(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
EndEvent

Event OnBumpPoisonDown(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
EndEvent

Event OnBumpPoisonLeft(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
EndEvent

Event OnBumpPoisonRight(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
EndEvent


; FUNCTIONS ---------------------------------------------------------------------------------------

; @overrides SKI_WidgetBase
string function GetWidgetSource()
	return "poisoningextended/poisoninfo.swf"
endFunction

; @overrides SKI_WidgetBase
string function GetWidgetType()
	; Must be the same as scriptname
	return "_PSX_PoisonWidgets"
endFunction


function UpdateStatus(string src)

	if (!Ready)
		return
	endIf

	;string msg = src + "::UpdateStatus. Overall: (" + X + "," + Y + "), visible " + Visible + "; Left: (" + LeftX + "," + LeftY + "), " + PoisonTextLeft + "; Right: (" + RightX + "," + RightY + ")" + PoisonTextRight
	;Debug.Notification(msg)
	;Debug.Trace(msg)

endFunction


; STATES ---------------------------------------------------------------------------------------

state BumpingLeft

	Event OnBumpPoisonUp(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
		float oldLeftY = LeftY
		LeftY = oldLeftY - 50
		Debug.Notification(oldLeftY + " => " + LeftY)
	EndEvent

	Event OnBumpPoisonDown(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
		float oldLeftY = LeftY
		LeftY = oldLeftY + 50
		Debug.Notification(oldLeftY + " => " + LeftY)
	EndEvent

	Event OnBumpPoisonLeft(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
		float oldLeftX = LeftX
		LeftX = oldLeftX - 50
		Debug.Notification(oldLeftX + " => " + LeftX)
	EndEvent

	Event OnBumpPoisonRight(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
		float oldLeftX = LeftX
		LeftX = oldLeftX + 50
		Debug.Notification(oldLeftX + " => " + LeftX)
	EndEvent

endState

state BumpingRght

	Event OnBumpPoisonUp(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
		float oldRightY = RightY
		RightY = oldRightY - 50
		Debug.Notification(oldRightY + " => " + RightY)
	EndEvent

	Event OnBumpPoisonDown(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
		float oldRightY = RightY
		RightY = oldRightY + 50
		Debug.Notification(oldRightY + " => " + RightY)
	EndEvent

	Event OnBumpPoisonLeft(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
		float oldRightX = RightX
		RightX = oldRightX - 50
		Debug.Notification(oldRightX + " => " + RightX)
	EndEvent

	Event OnBumpPoisonRight(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
		float oldRightX = RightX
		RightX = oldRightX + 50
		Debug.Notification(oldRightX + " => " + RightX)
	EndEvent

endState
