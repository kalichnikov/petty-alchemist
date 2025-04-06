extends StaticBody2D


func _ready() -> void:
	modulate = Color(Color.LIGHT_GRAY, 0.7)
	add_to_group("Droppable")
	add_to_group("CanBeDroppable")
