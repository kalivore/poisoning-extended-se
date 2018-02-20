Scriptname _PSX_PlayerRefScript extends ReferenceAlias  

_PSX_QuestScript Property PSXQuest  Auto
Actor Property PlayerRef Auto


Bool updateThrottle


event OnInit()
	RegisterForAnimationEvent(PlayerRef, "weaponSwing")
	RegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
	RegisterForAnimationEvent(PlayerRef, "arrowRelease")
endEvent

event OnPlayerLoadGame()
	RegisterForAnimationEvent(PlayerRef, "weaponSwing")
	RegisterForAnimationEvent(PlayerRef, "weaponLeftSwing")
	RegisterForAnimationEvent(PlayerRef, "arrowRelease")
	PSXQuest.Update()
endEvent

Event OnAnimationEvent(ObjectReference aktarg, string EventName)
	If !updateThrottle
		updateThrottle = True
		RegisterForSingleUpdate(1.0)
	EndIf
EndEvent

Event OnUpdate()
	updateThrottle = False
	PSXQuest.UpdatePoisonWidgets()
EndEvent
