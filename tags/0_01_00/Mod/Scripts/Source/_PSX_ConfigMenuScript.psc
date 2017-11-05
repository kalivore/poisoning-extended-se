ScriptName _PSX_ConfigMenuScript extends SKI_ConfigBase

; SCRIPT VERSION ----------------------------------------------------------------------------------
;
; History
;
; 1 - Initial version

int function GetVersion()
	return 1
endFunction


; PRIVATE VARIABLES -------------------------------------------------------------------------------
; string constants
string C_LOGO_PATH = "PoisoningExtended/mcm_logo.dds"
; Image size 768x384
; X offset = 376 - (width / 2) = -8
int offsetX = -8
; Y offset = 223 - (height / 2) = 31
int offsetY = 31

string C_STRING_EMPTY = ""

; Translatables
string C_MOD_NAME = "$PSXModName"
string C_PAGE_MISC = "$PSXPageMisc"
string C_FORMAT_PLACEHOLDER_SECONDS = "$PSXFormatPlaceholderSeconds"
string C_FORMAT_PLACEHOLDER_PERCENT = "$PSXFormatPlaceholderPercent"
string C_MENU_OPTION_ALWAYS = "$PSXMenuOptionAlways"
string C_MENU_OPTION_NEW_POISON = "$PSXMenuOptionNewPoison"
string C_MENU_OPTION_BENEFICIAL = "$PSXMenuOptionBeneficial"
string C_MENU_OPTION_NEVER = "$PSXMenuOptionNever"
string C_HEADER_LABEL_PROMPTS = "$PSXHeaderLabelPrompts"
string C_HEADER_LABEL_WIDGETS = "$PSXHeaderLabelWidgets"
string C_HEADER_LABEL_MISC = "$PSXHeaderLabelMisc"
string C_OPTION_LABEL_POISONPROMPT = "$PSXOptionLabelPoisonPrompt"
string C_OPTION_LABEL_CLEANPROMPT = "$PSXOptionLabelCleanPrompt"
string C_OPTION_LABEL_HOTKEYLEFT = "$PSXOptionLabelHotkeyLeft"
string C_OPTION_LABEL_HOTKEYRGHT = "$PSXOptionLabelHotkeyRght"
string C_OPTION_LABEL_CHARGEMULTIPLIER = "$PSXOptionLabelChargeMultiplier"
string C_OPTION_LABEL_SHOWWIDGETS = "$PSXOptionLabelShowWidgets"
string C_OPTION_LABEL_DEBUG = "$PSXOptionLabelDebug"
string C_OPTION_LABEL_CURRENT_VERSION = "$PSXOptionLabelCurrentVersion"
string C_INFO_TEXT_POISONPROMPT = "$PSXInfoTextPoisonPrompt"
string C_INFO_TEXT_CLEANPROMPT = "$PSXInfoTextCleanPrompt"
string C_INFO_TEXT_HOTKEYLEFT = "$PSXInfoTextPoisonLeft"
string C_INFO_TEXT_HOTKEYRGHT = "$PSXInfoTextPoisonRght"
string C_INFO_TEXT_CHARGEMULTIPLIER = "$PSXInfoTextChargeMultiplier"
string C_INFO_TEXT_SHOWWIDGETS = "$PSXInfoTextShowWidgets"
string C_INFO_TEXT_DEBUG = "$PSXInfoTextDebug"

; State
int poisonPrompt
int poisonPromptDefault
int cleanPrompt
int cleanPromptDefault
int hotkeyLeft
int hotkeyLeftDefault
int hotkeyRght
int hotkeyRghtDefault
int chargeMultiplier
int chargeMultiplierDefault
bool showWidgets
bool showWidgetsDefault
bool modDebug
bool modDebugDefault

; Internal
_PSX_QuestScript Property PSXQuest Auto

string[] poisonPromptOptions
string[] cleanPromptOptions


; INITIALIZATION ----------------------------------------------------------------------------------

; @implements SKI_QuestBase
event OnVersionUpdate(int a_version)
	if (a_version > 1)
		OnConfigInit()
	endIf
endEvent

; @overrides SKI_ConfigBase
event OnConfigInit()

	ModName = C_MOD_NAME

	Pages = new string[1]
	Pages[0] = C_PAGE_MISC
	
	poisonPromptOptions = new string[4]
	poisonPromptOptions[PSXQuest.C_CONFIRM_POISON_BENEFICIAL] = C_MENU_OPTION_BENEFICIAL
	poisonPromptOptions[PSXQuest.C_CONFIRM_POISON_NEWPOISON] = C_MENU_OPTION_NEW_POISON
	poisonPromptOptions[PSXQuest.C_CONFIRM_POISON_NEVER] = C_MENU_OPTION_NEVER
	poisonPromptOptions[PSXQuest.C_CONFIRM_POISON_ALWAYS] = C_MENU_OPTION_ALWAYS
	
	cleanPromptOptions = new string[2]
	cleanPromptOptions[PSXQuest.C_CONFIRM_CLEAN_NEVER] = C_MENU_OPTION_NEVER
	cleanPromptOptions[PSXQuest.C_CONFIRM_CLEAN_ALWAYS] = C_MENU_OPTION_ALWAYS
	
	poisonPromptDefault = PSXQuest.C_CONFIRM_POISON_NEWPOISON
	cleanPromptDefault = PSXQuest.C_CONFIRM_CLEAN_NEVER
	hotkeyLeftDefault = -1
	hotkeyRghtDefault = -1
	chargeMultiplierDefault = PSXQuest.GetDefaultChargeMultiplier()
	showWidgetsDefault = true
	modDebugDefault = false
	
endEvent


; EVENTS ------------------------------------------------------------------------------------------

Event OnConfigOpen()

	poisonPrompt = PSXQuest.ConfirmPoison
	cleanPrompt = PSXQuest.ConfirmClean
	hotkeyLeft = PSXQuest.KeycodePoisonLeft
	hotkeyRght = PSXQuest.KeycodePoisonRght
	chargeMultiplier = PSXQuest.ChargeMultiplier
	showWidgets = PSXQuest.ShowWidgets
	modDebug = PSXQuest.DebugToFile

EndEvent

Event OnConfigClose()
EndEvent

; @implements SKI_ConfigBase
event OnPageReset(string a_page)
	{Called when a new page is selected, including the initial empty page}

	; Load custom logo in DDS format
	if (a_page == C_STRING_EMPTY)
		LoadCustomContent(C_LOGO_PATH, offsetX, offsetY)
		return
	else
		UnloadCustomContent()
	endIf

	SetCursorFillMode(TOP_TO_BOTTOM)
	
	if (a_page == C_PAGE_MISC)
	
		AddHeaderOption(C_HEADER_LABEL_PROMPTS)
		
		AddMenuOptionST("PoisonPrompt_M", C_OPTION_LABEL_POISONPROMPT, poisonPromptOptions[poisonPrompt])
		AddMenuOptionST("CleanPrompt_M", C_OPTION_LABEL_CLEANPROMPT, cleanPromptOptions[cleanPrompt])
		AddKeyMapOptionST("HotkeyRght_K", C_OPTION_LABEL_HOTKEYRGHT, hotkeyRght)
		AddKeyMapOptionST("HotkeyLeft_K", C_OPTION_LABEL_HOTKEYLEFT, hotkeyLeft)
		
		AddEmptyOption()
		
		AddHeaderOption(C_HEADER_LABEL_MISC)
		
		AddSliderOptionST("ChargeMultiplier_S", C_OPTION_LABEL_CHARGEMULTIPLIER, chargeMultiplier)
		AddToggleOptionST("Debug_B", C_OPTION_LABEL_DEBUG, modDebug)
		
		AddEmptyOption()
		AddEmptyOption()
		AddEmptyOption()

		AddTextOptionST("CurrentVersion_T", C_OPTION_LABEL_CURRENT_VERSION, PSXQuest.GetVersionAsString(PSXQuest.CurrentVersion), OPTION_FLAG_DISABLED)
		
		SetCursorPosition(1) ; Move to the top of the right-hand pane
		
		AddHeaderOption(C_HEADER_LABEL_WIDGETS)
		
		AddToggleOptionST("ShowWidgets_B", C_OPTION_LABEL_SHOWWIDGETS, showWidgets)
		
	endIf
	
endEvent


state PoisonPrompt_M

	event OnMenuOpenST()
		SetMenuDialogStartIndex(poisonPrompt)
		SetMenuDialogDefaultIndex(poisonPromptDefault)
		SetMenuDialogOptions(poisonPromptOptions)
	endEvent
	
	event OnMenuAcceptST(int a_index)
		poisonPrompt = a_index
		SetMenuOptionValueST(poisonPromptOptions[poisonPrompt])
		PSXQuest.ConfirmPoison = poisonPrompt
	endEvent
	
	event OnDefaultST()
		poisonPrompt = poisonPromptDefault
		SetMenuOptionValueST(poisonPromptOptions[poisonPrompt])
		PSXQuest.ConfirmPoison = poisonPrompt
	endEvent

	event OnHighlightST()
		SetInfoText(C_INFO_TEXT_POISONPROMPT)
	endEvent

endState

state CleanPrompt_M

	event OnMenuOpenST()
		SetMenuDialogStartIndex(cleanPrompt)
		SetMenuDialogDefaultIndex(cleanPromptDefault)
		SetMenuDialogOptions(cleanPromptOptions)
	endEvent
	
	event OnMenuAcceptST(int a_index)
		cleanPrompt = a_index
		SetMenuOptionValueST(cleanPromptOptions[cleanPrompt])
		PSXQuest.ConfirmClean = cleanPrompt
	endEvent
	
	event OnDefaultST()
		cleanPrompt = cleanPromptDefault
		SetMenuOptionValueST(cleanPromptOptions[cleanPrompt])
		PSXQuest.ConfirmClean = cleanPrompt
	endEvent

	event OnHighlightST()
		SetInfoText(C_INFO_TEXT_CLEANPROMPT)
	endEvent

endState

state HotkeyLeft_K

	event OnKeyMapChangeST(int a_keyCode, string a_conflictControl, string a_conflictName)
		if (!passesKeyConflictControl(a_keyCode, a_conflictControl, a_conflictName))
			return
		endIf
		hotkeyLeft = a_keyCode
		SetKeyMapOptionValueST(hotkeyLeft)
		PSXQuest.KeycodePoisonLeft = hotkeyLeft
	endEvent
	
	event OnDefaultST()
		hotkeyLeft = hotkeyLeftDefault
		SetKeyMapOptionValueST(hotkeyLeft)
		PSXQuest.KeycodePoisonLeft = hotkeyLeft
	endEvent
	
	event OnHighlightST()
		SetInfoText(C_INFO_TEXT_HOTKEYLEFT)
	endEvent

endState

state HotkeyRght_K

	event OnKeyMapChangeST(int a_keyCode, string a_conflictControl, string a_conflictName)
		if (!passesKeyConflictControl(a_keyCode, a_conflictControl, a_conflictName))
			return
		endIf
		hotkeyRght = a_keyCode
		SetKeyMapOptionValueST(hotkeyRght)
		PSXQuest.KeycodePoisonRght = hotkeyRght
	endEvent
	
	event OnDefaultST()
		hotkeyRght = hotkeyRghtDefault
		SetKeyMapOptionValueST(hotkeyRght)
		PSXQuest.KeycodePoisonRght = hotkeyRght
	endEvent
	
	event OnHighlightST()
		SetInfoText(C_INFO_TEXT_HOTKEYRGHT)
	endEvent

endState

state ChargeMultiplier_S

	event OnSliderOpenST()
		SetSliderDialogStartValue(chargeMultiplier)
		SetSliderDialogDefaultValue(chargeMultiplier)
		SetSliderDialogRange(0, 10)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float a_val)
		chargeMultiplier = a_val as int
		SetSliderOptionValueST(chargeMultiplier)
		PSXQuest.ChargeMultiplier = chargeMultiplier
	endEvent

	event OnDefaultST()
		chargeMultiplier = chargeMultiplierDefault
		SetSliderOptionValueST(chargeMultiplier)
		PSXQuest.ChargeMultiplier = chargeMultiplier
	endEvent
	
	event OnHighlightST()
		SetInfoText(C_INFO_TEXT_CHARGEMULTIPLIER)
	endEvent

endState

state ShowWidgets_B

	event OnSelectST()
		showWidgets = !showWidgets
		SetToggleOptionValueST(showWidgets)
		PSXQuest.ShowWidgets = showWidgets
	endEvent
	
	event OnDefaultST()
		showWidgets = showWidgetsDefault
		SetToggleOptionValueST(showWidgets)
		PSXQuest.ShowWidgets = showWidgets
	endEvent

	event OnHighlightST()
		SetInfoText(C_INFO_TEXT_SHOWWIDGETS)
	endEvent

endState

state Debug_B

	event OnSelectST()
		modDebug = !modDebug
		SetToggleOptionValueST(modDebug)
		PSXQuest.DebugToFile = modDebug
	endEvent
	
	event OnDefaultST()
		modDebug = modDebugDefault
		SetToggleOptionValueST(modDebug)
		PSXQuest.DebugToFile = modDebug
	endEvent

	event OnHighlightST()
		SetInfoText(C_INFO_TEXT_DEBUG)
	endEvent

endState



; shamelessly robbed from sevencardz.. :p
bool Function passesKeyConflictControl(int keyCode, String conflictControl, String conflictName)
	if conflictControl != "" && keyCode > 0
		String msg = "$PSXKeyConflict{" + conflictControl + "}"
		if conflictName != ""
			msg += "{" + conflictName + "}"
		endIf
		return ShowMessage(msg, true, "$Yes", "$No")
	else
		return true
	endIf
endFunction
