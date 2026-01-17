extends Node3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Victory")
