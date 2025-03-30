extends Node2D

var leftitemID: int 
var rightitemID: int
var leftfilled: bool = false
var rightfilled: bool = false

func _ready() -> void:
	$"Crafting Slots".visible = false

func _on_agitation_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$"Crafting Slots".visible = true
	elif toggled_on == false:
		$"Crafting Slots".visible = false

#set to detect when area2d enters detectors
#and take item IDs from entered areas in order to grab numbers to do math to
