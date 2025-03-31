extends Node2D

var leftitemID: int 
var rightitemID: int
var leftfilled: bool = false
var rightfilled: bool = false
#the following variables capture the nodes of the objects placed into each slot
var leftitem
var rightitem
#signal fired to main scene to spawn new item and delete old items
signal agit_complete

func _ready() -> void:
	#makes slots invisible to start
	$"Crafting Slots".visible = false
	$CombineButton.visible = false

func _process(_delta):
	#behavior for opening craft button when both slots are filled
	if leftfilled and rightfilled:
		$CombineButton.visible = true

#button to activate crafting for agitator (makes slots visible)
func _on_agitation_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$"Crafting Slots".visible = true
	elif toggled_on == false:
		$"Crafting Slots".visible = false

#detector behavior for left slot
func _on_agi_slot_1_detector_area_entered(area: Area2D) -> void:
	#first checks if item is in slot already and if not fills slot and grabs itemID
	if not leftfilled and not area.get_parent().overlapping: 
		leftfilled = true
		leftitem = area.get_parent()
		leftitemID = leftitem.ItemIdentity
func _on_agi_slot_1_detector_area_exited(area: Area2D) -> void:
	#when taking an item out of craft slot, notes that slot is no longer filled
	if leftfilled and not area.get_parent().overlapping: 
		leftfilled = false
		leftitemID = 0
		leftitem = null

#detector behavior for right slot
func _on_agi_slot_2_detector_area_entered(area: Area2D) -> void:
	#first checks if item is in slot already and if not fills slot and grabs itemID
	if not rightfilled and not area.get_parent().overlapping: 
		rightfilled = true
		rightitem = area.get_parent()
		rightitemID = rightitem.ItemIdentity
func _on_agi_slot_2_detector_area_exited(area: Area2D) -> void:
	#when taking an item out of craft slot, notes that slot is no longer filled
	if rightfilled and not area.get_parent().overlapping: 
		rightfilled = false
		rightitemID = 0
		rightitem = null

func _on_combine_button_pressed() -> void:
	if leftfilled and rightfilled:
		var val1: int
		var val2: int
		var created: String
		val1 = leftitemID
		val2 = rightitemID
		created = await global.phase1craft(val1, val2)
		agit_complete.emit(leftitem, rightitem, created)
