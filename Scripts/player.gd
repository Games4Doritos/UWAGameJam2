extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const TERMINAL_VELOCITY = 40
@onready var camera = $head/Camera3D
var cameraX:float:
	set(value):
		cameraX = clamp(value, -PI/2, PI/2)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var pauseMenu
var flip = 1 # 1 for normal -1 for flipped gravity

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
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
	#var spherNorm = Vector2(sin(camera.rotation.y), cos(camera.rotation.y)) * flip
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not pauseMenu.isPaused:
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.y = direction.y * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)

		if abs(velocity.y) >= TERMINAL_VELOCITY:
			velocity.y = TERMINAL_VELOCITY * velocity.y / abs(velocity.y)
	else:
		velocity = Vector3(0,0,0)
	
	move_and_slide()
	
	
func _input(event):
	var sensitivity = 700
	
	if event is InputEventMouseMotion and not pauseMenu.isPaused:
		camera.rotation.y -= event.relative.x/sensitivity
		cameraX -= event.relative.y/sensitivity
		camera.rotation.x = cameraX
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not pauseMenu.isPaused and event.pressed and not pauseMenu.leftmouseDead:
		flip *= -1
		gravity = -gravity
		print(gravity)
		rotate_z(deg_to_rad(180))
	if event.is_action_pressed("Esc") and not pauseMenu.isPaused and not pauseMenu.escDead:
		pauseMenu.isPaused = true
		pauseMenu.visible = true
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		
func changeGrav():
	#camera.rotate_z(PI)
	gravity = -gravity
	if is_on_floor():
		velocity.y = -gravity/abs(gravity)
	
