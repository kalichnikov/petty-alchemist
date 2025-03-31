extends Node2D

var explosionpath = "res://Scenes/explosion.tscn"
var loadexplosion = load(explosionpath)

func _ready() -> void:
	pass # Replace with function body.

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
