extends Node3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().current_scene.gameover = true
		$"../player".visible = false
		$Camera3D.make_current()
		$Win.show()
		body.get_node("Control/crosshair").hide()
		$Win/AnimationPlayer.play("fadeWhite")
