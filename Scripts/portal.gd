extends Node3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().current_scene.gameover = true
		$Camera3D.make_current()
		$Win.show()
		
		print("Victory")
