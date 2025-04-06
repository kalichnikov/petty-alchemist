extends Node2D

var leftitemID: int 
var rightitemID: int
var leftfilled: bool = false
var rightfilled: bool = false
#the following variables capture the nodes of the objects placed into each slot
var leftitem
var rightitem
#signal fired to main scene to spawn new item and delete old items
signal dist_complete

func _ready() -> void:
	#sets slot mod
	$"Crafting Slots/Slot 1".modulate = Color(Color.LIGHT_GRAY, 0.7)
	$"Crafting Slots/Slot 2".modulate = Color(Color.LIGHT_GRAY, 0.7)
	#makes slots invisible to start
	$"Crafting Slots".visible = false
	$CombineButton.visible = false

func _process(_delta):
	#behavior for opening craft button when both slots are filled
	if leftfilled and rightfilled: $CombineButton.visible = true
	else: $CombineButton.visible = false

#button to activate crafting for distillation (makes slots visible)
func _on_distillationbutton_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$"Crafting Slots".visible = true
		$Sounds/Open.play()
	elif toggled_on == false:
		$"Crafting Slots".visible = false
		$Sounds/Open.play()

#detector behavior for left slot
func _on_dis_slot_1_detector_area_entered(area: Area2D) -> void:
	#first checks if item is in slot already and if not fills slot and grabs itemID
	var overlapping = area.get_parent().overlapping
	var CanBeDistilled = area.get_parent().CanBeDistilled
	if CanBeDistilled:
		if not leftfilled and not overlapping: 
			leftfilled = true
			leftitem = area.get_parent()
			leftitemID = leftitem.ItemIdentity
	elif not CanBeDistilled: $"Crafting Slots/Slot 1".remove_from_group("Droppable")
func _on_dis_slot_1_detector_area_exited(area: Area2D) -> void:
	#when taking an item out of craft slot, notes that slot is no longer filled
	if leftfilled and not area.get_parent().overlapping: 
		leftfilled = false
		leftitemID = 0
		leftitem = null
	if not $"Crafting Slots/Slot 1".is_in_group("Droppable"): $"Crafting Slots/Slot 1".add_to_group("Droppable")

#detector behavior for right slot
func _on_dis_slot_2_detector_area_entered(area: Area2D) -> void:
	#first checks if item is in slot already and if not fills slot and grabs itemID
	var overlapping = area.get_parent().overlapping
	var CanBeDistilled = area.get_parent().CanBeDistilled
	if CanBeDistilled:
		if not rightfilled and not overlapping: 
			rightfilled = true
			rightitem = area.get_parent()
			rightitemID = rightitem.ItemIdentity
	elif not CanBeDistilled: $"Crafting Slots/Slot 2".remove_from_group("Droppable")
func _on_dis_slot_2_detector_area_exited(area: Area2D) -> void:
	#when taking an item out of craft slot, notes that slot is no longer filled
	if rightfilled and not area.get_parent().overlapping: 
		rightfilled = false
		rightitemID = 0
		rightitem = null
	if not $"Crafting Slots/Slot 2".is_in_group("Droppable"): $"Crafting Slots/Slot 2".add_to_group("Droppable")

#logic for starting craft
func _on_combine_button_pressed() -> void:
	if leftfilled and rightfilled:
		$Sounds/Distill.play()
		await get_tree().create_timer(1.8).timeout
		var val1: int
		var val2: int
		var created: String
		val1 = leftitemID
		val2 = rightitemID
		created = global.phase1craft(val1, val2)
		dist_complete.emit(leftitem, rightitem, created)
		#

func clear_crafting_slots():
	leftfilled = false
	leftitemID = 0
	leftitem = null
	rightfilled = false
	rightitemID = 0
	rightitem = null
