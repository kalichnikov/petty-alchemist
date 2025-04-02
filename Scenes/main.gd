extends Node2D

#loads and prepares explosion scene to be instantiated later when needed
var explosionpath = "res://Scenes/explosion.tscn"
var loadexplosion = load(explosionpath)
#loads and prepares crate scene to be instantiated later when needed
var cratepath = "res://Scenes/crate.tscn"
var loadcrate = load(cratepath)


func _ready() -> void:
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
	pass

func _on_agitation_agit_complete(leftitem: Node2D, rightitem: Node2D, created: String) -> void:
	# clears crafted items
	leftitem.queue_free()
	rightitem.queue_free()
	# if craft failed, explodes
	if created == "boom":
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
		iteminstance.global_position = $Agitation.global_position
		iteminstance.global_position.y = $Agitation.global_position.y + 150.0
		$AudioStreamPlayer.play()
