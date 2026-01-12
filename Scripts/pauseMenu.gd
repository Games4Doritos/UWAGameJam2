extends Node2D

@onready var cont = $continue
@onready var leave = $leave

@export var isPaused = false
@export var escDead = false
@export var leftmouseDead = false

var continueSelected = false
var leaveSelected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_continue_mouse_entered() -> void:
	continueSelected = true
	cont.scale = Vector2(1.5,1.5)

func _on_continue_mouse_exited() -> void:
	continueSelected = false
	cont.scale = Vector2(1,1)

func _on_leave_mouse_entered() -> void:
	leaveSelected = true
	leave.scale = Vector2(1.5,1.5)

func _on_leave_mouse_exited() -> void:
	leaveSelected = false
	leave.scale = Vector2(1,1)
	
func _input(event: InputEvent) -> void:
	
	print(event is InputEventMouseButton and continueSelected)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and continueSelected and event.pressed:
		leftmouseDead = true
		self.visible = false
		cont.scale = Vector2(1,1)
		isPaused = false
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and leaveSelected and event.pressed:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("Esc") and isPaused:
		escDead = true
		self.visible = false
		self.isPaused = false
		cont.scale = Vector2(1,1)
		leave.scale = Vector2(1,1)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
	
	if event.is_action_released("Esc") and escDead:
		escDead = false
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released() and leftmouseDead:
		leftmouseDead = false
		
