extends Control

@onready var start = $CenterContainer/HBoxContainer/startLabel

var startSelected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and startSelected:
		get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_start_label_mouse_entered() -> void:
	startSelected = true
	start.scale = Vector2(1.2,1.2)

func _on_start_label_mouse_exited() -> void:
	startSelected = false
	start.scale = Vector2(1,1)
