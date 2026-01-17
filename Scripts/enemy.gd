extends Node3D

@onready var timer = $Timer

var ball = preload("res://Scenes/electric_ball.tscn")
var player
var is_ragdoll = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("bullet") and !is_ragdoll:
		is_ragdoll = true
		$RootNode/Skeleton3D/PhysicalBoneSimulator3D.physical_bones_start_simulation()
		$"RootNode/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone mixamorig_Spine".linear_velocity = (position - area.position).normalized() * 100
		$StaticBody3D.queue_free()
		$Timer.stop()
		$AudioStreamPlayer3D.stop()


func _on_timer_timeout() -> void:
	if (position-player.position).length() < 30:
		var ballInstance = ball.instantiate()
		ballInstance.position = global_position
		
		get_tree().current_scene.add_child(ballInstance)
