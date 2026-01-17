extends Node3D

@onready var player = $player

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false


func _on_gravity_timer_timeout() -> void:
	player.flip_gravity()
