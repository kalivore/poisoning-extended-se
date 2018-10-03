;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 17
Scriptname _KLV_StashRefPerkScript Extends Perk Hidden

;BEGIN FRAGMENT Fragment_14
Function Fragment_14(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
int handle = ModEvent.Create("_KLV_ContainerActivated")
if (handle)
	ModEvent.PushForm(handle, akTargetRef)
	ModEvent.Send(handle)
endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
