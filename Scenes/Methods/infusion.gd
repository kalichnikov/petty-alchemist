extends Node2D
var leftitemID: int 
var rightitemID: int
var metalClass: int
var leftfilled: bool = false
var rightfilled: bool = false
#the following variables capture the nodes of the objects placed into each slot
var leftitem
var rightitem
#signal fired to main scene to spawn new item and delete old items
signal inf_complete

func _ready() -> void:
	#sets slot mod
	$"Crafting Slots/Slot 1".modulate = Color(Color.LIGHT_GRAY, 0.7)
	$"Crafting Slots/Slot 2".modulate = Color(Color.LIGHT_GRAY, 0.7)
	#makes slots invisible to start
	$"Crafting Slots".visible = false
	$CombineButton.visible = false
	$"No Effect".visible = false

func _process(_delta):
	#behavior for opening craft button when both slots are filled
	if leftfilled and rightfilled and metalClass != 0: $CombineButton.visible = true
	else: $CombineButton.visible = false


func _on_infusion_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$"Crafting Slots".visible = true
		$Sounds/Open.play()
	elif toggled_on == false:
		$"Crafting Slots".visible = false
		$Sounds/Open.play()

#detector behavior for metal slot
func _on_inf_slot_1_detector_area_entered(area: Area2D) -> void:
	#first checks if item is in slot already and if not fills slot and grabs itemID
	var overlapping = area.get_parent().overlapping
	var CanBeInfused = area.get_parent().CanBeInfused
	var infIsMetal = area.get_parent().infIsMetal
	if CanBeInfused and infIsMetal:
		if not leftfilled and not overlapping: 
			leftfilled = true
			leftitem = area.get_parent()
			metalClass = leftitem.metalClass
	else: $"Crafting Slots/Slot 1".remove_from_group("Droppable")
	#this logic is slightly different from other crafting methods, watch for problems
func _on_inf_slot_1_detector_area_exited(area: Area2D) -> void:
	#when taking an item out of craft slot, notes that slot is no longer filled
	if leftfilled and not area.get_parent().overlapping: 
		leftfilled = false
		leftitem = null
		metalClass = 0
	if not $"Crafting Slots/Slot 1".is_in_group("Droppable"): $"Crafting Slots/Slot 1".add_to_group("Droppable")

#detector behavior for right slot
func _on_inf_slot_2_detector_area_entered(area: Area2D) -> void:
	#first checks if item is in slot already and if not fills slot and grabs itemID
	var overlapping = area.get_parent().overlapping
	var CanBeInfused = area.get_parent().CanBeInfused
	var infIsInfusive = area.get_parent().infIsInfusive
	if CanBeInfused and infIsInfusive: 
		if not rightfilled and not overlapping: 
			rightfilled = true
			rightitem = area.get_parent()
			rightitemID = rightitem.ItemIdentity
	else: $"Crafting Slots/Slot 1".remove_from_group("Droppable")
	#this logic is slightly different from other crafting methods, watch for problems
func _on_inf_slot_2_detector_area_exited(area: Area2D) -> void:
	#when taking an item out of craft slot, notes that slot is no longer filled
	if rightfilled and not area.get_parent().overlapping: 
		rightfilled = false
		rightitemID = 0
		rightitem = null
	if not $"Crafting Slots/Slot 2".is_in_group("Droppable"): $"Crafting Slots/Slot 2".add_to_group("Droppable")

#logic for kicking off craft
func _on_combine_button_pressed() -> void:
	if leftfilled and rightfilled:
		$Sounds/Infuse.play()
		await get_tree().create_timer(1.8).timeout
		var val1: int
		var val2: int
		var val1_style: int
		var created: String
		val1 = leftitemID
		val2 = rightitemID
		val1_style = metalClass
		created = global.phase2craft(val1_style, val1, val2)
		inf_complete.emit(leftitem, rightitem, created)

func clear_crafting_slots():
	leftfilled = false
	leftitemID = 0
	leftitem = null
	rightfilled = false
	rightitemID = 0
	rightitem = null

func no_effect():
	$"No Effect".visible = true
	$AnimationPlayer.play()
	get_tree().create_timer(4.0).timeout
	$"No Effect".visible = false
	
