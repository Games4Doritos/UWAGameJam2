extends Control



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeWhite":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
