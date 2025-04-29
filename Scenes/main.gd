extends Node2D

#loads and prepares explosion scene to be instantiated later when needed
var explosionpath = "res://Scenes/explosion.tscn"
var loadexplosion = load(explosionpath)
#loads and prepares crate scene to be instantiated later when needed
var cratepath = "res://Scenes/crate.tscn"
var loadcrate = load(cratepath)
# vars for tracking when phases are unlocked
var phase2progress : int = 0
var phase3progress : int = 0
@export var patronMood : float = 10000.0
@export var labRebuildCost : float
@export var supplyCost : float
@export var textCost : float
var patronStartingMood : int
var moodThreshold1 : float
var moodThreshold2 : float
var moodThreshold3 : float
var moodThreshold4 : float

func _ready() -> void:
	#makes later phase methods invisible to start
	$distillation.visible = false
	$Infusion.visible = false
	#checks character creation rules
	if global.char_patience == true:
		var adjustment: float = 2.0 / 3.0
		var newMood = patronMood * adjustment
		patronMood = newMood
	patronStartingMood = patronMood
	moodThreshold1 = patronStartingMood * 5.0 / 6.0
	moodThreshold2 = patronStartingMood * 4.0 / 6.0
	moodThreshold3 = patronStartingMood * 3.0 / 6.0
	moodThreshold4 = patronStartingMood * 2.0 / 6.0
	#script for spawning player starting materials
	#vars for spawning starting materials
	var potionpath
	var loadpotion
	var potioninstance
	#spawning crate scene
	var crateinstance = loadcrate.instantiate()
	add_child(crateinstance)
	crateinstance.global_position = $CenterReference.global_position
	#populate three crate slots with RGB potions
	var startingpotions = ["red_solution", "green_solution", "blue_solution"]
	var crateslotnumber: int = 0
	var crateslots = crateinstance.get_child(1)
	for potion: String in startingpotions: 
		potionpath = "res://Scenes/Items/" + potion + ".tscn"
		loadpotion = load(potionpath)
		potioninstance = loadpotion.instantiate()
		add_child(potioninstance)
		potioninstance.global_position = crateslots.get_child(crateslotnumber).global_position
		crateslotnumber += 1
	#array of solutions that can be obtained for starting materials
	startingpotions = ["red_solution", "green_solution", "blue_solution", "magenta_solution", "yellow_solution", "cyan_solution", "white_solution"]
	for i in range(3):
		var nextpotion = startingpotions.pick_random()
		potionpath = "res://Scenes/Items/" + nextpotion + ".tscn"
		loadpotion = load(potionpath)
		potioninstance = loadpotion.instantiate()
		add_child(potioninstance)
		potioninstance.global_position = crateslots.get_child(crateslotnumber).global_position
		crateslotnumber += 1


func _process(_delta: float) -> void:
	# logic for unlocking later methods
	if phase2progress >= 2:
		$distillation.visible = true
	if phase3progress >= 2 and $distillation.visible:
		$Infusion.visible = true
	#logic for adjusting patron mood
	if patronMood <= moodThreshold1: 
		$UIs/PatronMood/mood_face.texture = load("res://Assets/Moods/stage1.png")
	elif patronMood <= moodThreshold2: 
		$UIs/PatronMood/mood_face.texture = load("res://Assets/Moods/stage2.png")
	elif patronMood <= moodThreshold3: 
		$UIs/PatronMood/mood_face.texture = load("res://Assets/Moods/stage3.png")
	elif patronMood <= moodThreshold4: 
		$UIs/PatronMood/mood_face.texture = load("res://Assets/Moods/stage4.png")
	elif patronMood <= 0: 
		get_tree().change_scene_to_file("res://Scenes/GameEnd/game_over.tscn")

func _on_agitation_agit_complete(leftitem: Node2D, rightitem: Node2D, created: String) -> void:
	# clears crafted items
	leftitem.queue_free()
	rightitem.queue_free()
	# if craft failed, explodes
	if created == "boom":
		lab_rebuild()
		var boominstance = loadexplosion.instantiate()
		add_child(boominstance)
		boominstance.global_position = $Agitation.global_position
	#if craft was successful, spawns required item
	else:
		var itemscenepath: String # holds filepath of item to be spawned
		var itempack # loads item to be spawned
		var iteminstance # creates instance of item to be spawned
		itemscenepath = "res://Scenes/Items/" + created + ".tscn"
		itempack = load(itemscenepath)
		iteminstance = itempack.instantiate()
		add_child(iteminstance)
		if iteminstance.CanBeDistilled:
			phase2progress += 1
		if iteminstance.CanBeInfused:
			phase3progress += 1
		iteminstance.global_position = $Agitation.global_position
		iteminstance.global_position.y = $Agitation.global_position.y + 150.0
		$AudioStreamPlayer.play()

func _on_distillation_dist_complete(leftitem: Node2D, rightitem: Node2D, created: String) -> void:
	
	#clears crafted items
	leftitem.queue_free()
	rightitem.queue_free()
	#if craft failed, explodes
	if created == "boom":
		lab_rebuild()
		var boominstance = loadexplosion.instantiate()
		add_child(boominstance)
		boominstance.global_position = $distillation.global_position
	#if craft was successful, spawns required item
	else:
		var itemscenepath: String # holds filepath of item to be spawned
		var itempack # loads item to be spawned
		var iteminstance # creates instance of item to be spawned
		itemscenepath = "res://Scenes/Items/" + created + ".tscn"
		itempack = load(itemscenepath)
		iteminstance = itempack.instantiate()
		add_child(iteminstance)
		if iteminstance.CanBeDistilled:
			phase2progress += 1
		if iteminstance.CanBeInfused:
			phase3progress += 1
		iteminstance.global_position = $distillation.global_position
		iteminstance.global_position.y = $distillation.global_position.y + 150.0
		$AudioStreamPlayer.play()

func _on_infusion_inf_complete(leftitem: Node2D, rightitem: Node2D, created: String) -> void:
	if created == "no effect":
		$Infusion.no_effect()
	elif created == "gold":
		#game win logic
		leftitem.queue_free()
		rightitem.queue_free()
		get_tree().change_scene_to_file("res://Scenes/GameEnd/game_win.tscn")
	# if craft failed, explodes
	elif created == "boom":
		lab_rebuild()
		# clears crafted items
		leftitem.queue_free()
		rightitem.queue_free()
		var boominstance = loadexplosion.instantiate()
		add_child(boominstance)
		boominstance.global_position = $Infusion.global_position
	#if craft was successful, spawns required item
	else:
		# clears crafted items
		leftitem.queue_free()
		rightitem.queue_free()
		var itemscenepath: String # holds filepath of item to be spawned
		var itempack # loads item to be spawned
		var iteminstance # creates instance of item to be spawned
		itemscenepath = "res://Scenes/Items/" + created + ".tscn"
		itempack = load(itemscenepath)
		iteminstance = itempack.instantiate()
		add_child(iteminstance)
		if iteminstance.CanBeDistilled:
			phase2progress += 1
		if iteminstance.CanBeInfused:
			phase3progress += 1
		iteminstance.global_position = $Infusion.global_position
		iteminstance.global_position.y = $Infusion.global_position.y + 150.0
		$AudioStreamPlayer.play()

func lab_rebuild():
	patronMood -= labRebuildCost


func _on_bg_music_1_finished() -> void:
	await get_tree().create_timer(20.0).timeout
	$BGMusic2.play()

func _on_bg_music_2_finished() -> void:
	await get_tree().create_timer(20.0).timeout
	$BGMusic1.play()

func craftable_Descrition(ItemName, Description):
	$UIs/Node/ItemName/Label.text = ItemName
	$UIs/Node/ItemDescription/Label.text = Description

func craftable_Unhovered():
	$UIs/Node/ItemName/Label.text = ""
	$UIs/Node/ItemDescription/Label.text = ""


func _on_shop_pressed() -> void:
	#player buys new materials
	patronMood -= supplyCost
	#vars for spawning starting materials
	var materialpath
	var loadmaterial
	var materialinstance
	#spawning crate scene
	var crateinstance = loadcrate.instantiate()
	add_child(crateinstance)
	crateinstance.global_position = $CenterReference.global_position
	var shopitems = ["red_solution", "green_solution", "blue_solution", "magenta_solution", "yellow_solution", "cyan_solution", "white_solution", "unrefined_metal"]
	var crateslotnumber: int = 0
	var crateslots = crateinstance.get_child(1)
	for i in range(6):
		var nextitem = shopitems.pick_random()
		materialpath = "res://Scenes/Items/" + nextitem + ".tscn"
		loadmaterial = load(materialpath)
		materialinstance = loadmaterial.instantiate()
		add_child(materialinstance)
		materialinstance.global_position = crateslots.get_child(crateslotnumber).global_position
		crateslotnumber += 1
