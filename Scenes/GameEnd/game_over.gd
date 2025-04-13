extends Control


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
