extends Node3D

@onready var player = $player
var deadPlayer = preload("res://Scenes/PlayerRagdoll.tscn")
var droppedGun = preload("res://Scenes/dropped_gun.tscn")

var time = 30
@export var gameover = false

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
		player.get_node("Control/crosshair").hide()
		
		get_tree().current_scene.add_child(ragdoll)
		get_tree().current_scene.add_child(gun)
		ragdoll.get_node("RootNode/Skeleton3D/PhysicalBoneSimulator3D/Camera3D").make_current()
		$GameOver.show()
		
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.get_node("Timer").stop()
		$Ui.hide()
		$leaveTimer.start()
		print("GAME OVER")

func _on_gravity_timer_timeout() -> void:
	player.flip_gravity()
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		for bone in enemy.get_node("RootNode/Skeleton3D/PhysicalBoneSimulator3D").get_children():
			if bone is PhysicalBone3D:
				bone.gravity_scale = -bone.gravity_scale

func _on_timer_2_timeout() -> void:
	time -= 1
	$Ui.get_node("CenterContainer/Label").text = str(time)
	if time == 0:
		gameOver()


func _on_leave_timer_timeout() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
