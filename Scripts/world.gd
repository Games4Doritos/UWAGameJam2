extends Node3D

@onready var player = $player
var deadPlayer = preload("res://Scenes/PlayerRagdoll.tscn")
var droppedGun = preload("res://Scenes/dropped_gun.tscn")

var gameover = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func gameOver() -> void:
	if !gameover:
		gameover = true
		var ragdoll = deadPlayer.instantiate()
		var gun = droppedGun.instantiate()
		ragdoll.position = player.position
		gun.position = player.position
		player.hide()
		
		get_tree().current_scene.add_child(ragdoll)
		get_tree().current_scene.add_child(gun)
		ragdoll.get_node("RootNode/Skeleton3D/PhysicalBoneSimulator3D/Camera3D").make_current()
		$GameOver.show()
		
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.get_node("Timer").stop()
		
		print("GAME OVER")

func _on_gravity_timer_timeout() -> void:
	player.flip_gravity()
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		for bone in enemy.get_node("RootNode/Skeleton3D/PhysicalBoneSimulator3D").get_children():
			if bone is PhysicalBone3D:
				bone.gravity_scale = -bone.gravity_scale
