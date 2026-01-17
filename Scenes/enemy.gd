extends Node3D

@onready var timer = $Timer

var ball = preload("res://Scenes/electric_ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_area_entered(area: Area3D) -> void:
		if area.is_in_group("bullet"):
			$RootNode/Skeleton3D/PhysicalBoneSimulator3D.physical_bones_start_simulation()


func _on_timer_timeout() -> void:
	var ballInstance = ball.instantiate()
	ballInstance.position = global_position
	
	get_tree().current_scene.add_child(ballInstance)
