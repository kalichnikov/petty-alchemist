extends Node2D

@export var ItemName : String
@export var ItemIdentity : int
@export var CanBeAgitated : bool
@export var CanBeDistilled: bool
@export var CanBeInfused : bool
var draggable = false
var is_inside_droppable = false
var body_ref
var overlapping = false
var offset: Vector2
var initialPos : Vector2

func _ready():
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if draggable: 
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			var tween = get_tree().create_tween()
			$AudioStreamPlayer.play()
			if is_inside_droppable and overlapping == false:
				tween.tween_property(self,"position",body_ref.global_position,0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)


func _on_area_2d_mouse_entered() -> void:
	if not global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)
func _on_area_2d_mouse_exited() -> void:
	if not global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Droppable"):
		is_inside_droppable = true
		body.modulate = Color(Color.DARK_GRAY, 1)
		body_ref = body
func _on_area_2d_body_exited(body: Node2D) -> void:
	#detects when object leaves crafting slot
	if body.is_in_group("Droppable"):
		is_inside_droppable = false
		body.modulate = Color(Color.LIGHT_GRAY, 0.7)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("craftingobject"):
		overlapping = true
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("craftingobject"):
		overlapping = false
