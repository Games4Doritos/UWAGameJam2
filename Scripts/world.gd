extends Node3D

@onready var player = $player

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func gameOver() -> void:
	print("GAME OVER")

func _on_gravity_timer_timeout() -> void:
	player.flip_gravity()
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		for bone in enemy.get_node("RootNode/Skeleton3D/PhysicalBoneSimulator3D").get_children():
			if bone is PhysicalBone3D:
				bone.gravity_scale = -bone.gravity_scale
