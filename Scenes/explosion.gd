extends Sprite2D

func _ready() -> void:
	$AnimationPlayer.play("explosionanimation")
	$AudioStreamPlayer.play()
	await get_tree().create_timer(1.5).timeout
	explosion_deload()

func explosion_deload():
	queue_free()
