extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const TERMINAL_VELOCITY = 40
@onready var camera = $Camera3D
var cameraX:float:
	set(value):
		cameraX = clamp(value, -PI/2, PI/2)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var pauseMenu

func _ready():
	pauseMenu = get_tree().get_first_node_in_group("pauseMenu")
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var spherNorm = Vector2(sin(camera.rotation.y), cos(camera.rotation.y))
	var spherDir = Input.get_vector("A", "D", "S", "W")
	
	if not pauseMenu.isPaused:
		
		if spherDir[1] == 1:
			velocity.z = -spherNorm[1] *  SPEED
			velocity.x = -spherNorm[0] * SPEED
		if spherDir[1] == -1:
			velocity.z = spherNorm[1] *  SPEED
			velocity.x = spherNorm[0] * SPEED
		if spherDir[0] == -1:
			velocity.z = spherNorm[0] *  SPEED
			velocity.x = -spherNorm[1] * SPEED
		if spherDir[0] == 1:
			velocity.z = -spherNorm[0] *  SPEED
			velocity.x = spherNorm[1] * SPEED
		if spherDir == Vector2(0,0):
			velocity.z = 0
			velocity.x = 0
		if abs(velocity.y) >= TERMINAL_VELOCITY:
			velocity.y = TERMINAL_VELOCITY * velocity.y / abs(velocity.y)
	else:
		velocity = Vector3(0,0,0)
	
	move_and_slide()
	
	
func _input(event):
	if event is InputEventMouseMotion and not pauseMenu.isPaused:
		camera.rotation.y -= event.relative.x/1000
		cameraX -= event.relative.y/1000
		camera.rotation.x = cameraX
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not pauseMenu.isPaused and event.pressed and not pauseMenu.leftmouseDead:
		gravity = -gravity
		print(gravity)
	if event.is_action_pressed("Esc") and not pauseMenu.isPaused and not pauseMenu.escDead:
		pauseMenu.isPaused = true
		pauseMenu.visible = true
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
