extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005

@onready var cam = $Yaw/Pitch/Camera3D
@onready var yaw = $Yaw
@onready var pitch = $Yaw/Pitch
@onready var gun_anim = $Yaw/Pitch/Camera3D/shotgun/AnimationPlayer
@onready var raycast = $Yaw/Pitch/Camera3D/shotgun/RayCast3D

var bullet = preload("res://Scenes/bullet.tscn")
var bulletInstance

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var isPaused = false
var pauseMenu
var flip = 1

func _ready():
	pauseMenu = get_tree().get_first_node_in_group("pauseMenu")
	
func flip_gravity():
	gravity = -gravity
	flip *= -1
	up_direction.y *= -1
	
	#Adjust camera
	yaw.position.y += 0.7 * flip
	
	#flip view without affecting movement!
	cam.rotate_x(deg_to_rad(180))
	

func _unhandled_input(event: InputEvent) -> void:
	pass

	if event is InputEventMouseMotion:
		yaw.rotate_y(-event.relative.x * SENSITIVITY * flip)
		pitch.rotate_x(-event.relative.y * SENSITIVITY)
		pitch.rotation.x = clamp(pitch.rotation.x, -PI/2, PI/2)
		


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if Input.is_action_just_pressed("Esc") and not pauseMenu.isPaused and not pauseMenu.escDead:
		pauseMenu.isPaused = true
		pauseMenu.visible = true
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if not pauseMenu.isPaused:
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY * flip

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("backward", "forward", "left", "right")

		var movement_dir_3d = yaw.basis.x * input_dir.y - flip * yaw.basis.z * input_dir.x
		
		position += movement_dir_3d * SPEED * delta
		
		if Input.is_action_just_pressed("shoot") and !gun_anim.is_playing():
			bulletInstance = bullet.instantiate()
			bulletInstance.position = raycast.global_position
			bulletInstance.transform.basis = raycast.global_transform.basis
			get_parent().add_child(bulletInstance)
			gun_anim.play("shoot")
			pitch.rotation.x = clamp(pitch.rotation.x + PI/8, -PI/2, PI/2)
			

	move_and_slide()
