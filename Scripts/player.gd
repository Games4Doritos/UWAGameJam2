extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005

@onready var cam = $Yaw/Pitch/Camera3D
@onready var yaw = $Yaw
@onready var pitch = $Yaw/Pitch
@onready var gun_anim = $Yaw/Pitch/Camera3D/shotgun/AnimationPlayer
@onready var raycast = $Yaw/Pitch/Camera3D/shotgun/RayCast3D
@onready var gun = $Yaw/Pitch/Camera3D/shotgun
@onready var crosshair = $Control/crosshair

var bullet = preload("res://Scenes/bullet.tscn")
var bulletInstance

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var isPaused = false
var pauseMenu
var flip = 1
var sprintSpeed = 1

func _ready():
	pauseMenu = get_tree().get_first_node_in_group("pauseMenu")
	
func flip_gravity():
	gravity = -gravity
	flip *= -1
	up_direction.y *= -1
	
	#Adjust camera
	yaw.position.y += 0.7 * flip
	
	#flip view without affecting movement!
	cam.rotate_z(deg_to_rad(180))
	
func hit() -> void:
	$AudioStreamPlayer3D.play()
	$Timer.start()
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw.rotate_y(-event.relative.x * SENSITIVITY * flip)
		pitch.rotate_x(-event.relative.y * SENSITIVITY * flip)
		pitch.rotation.x = clamp(pitch.rotation.x, -PI/2, PI/2)
		
		


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if Input.is_action_just_pressed("Esc") and not pauseMenu.isPaused and not pauseMenu.escDead:
		crosshair.visible = false
		pauseMenu.isPaused = true
		pauseMenu.visible = true
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		
	if Input.is_action_pressed("run"):
		sprintSpeed = 1.5
	else:
		sprintSpeed = 1
	
	if not pauseMenu.isPaused:
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY * flip

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("backward", "forward", "left", "right")

		var movement_dir_3d = flip * yaw.basis.x * input_dir.y - yaw.basis.z * input_dir.x * sprintSpeed
		
		position += movement_dir_3d * SPEED * delta
		
		if Input.is_action_just_pressed("shoot") and !gun_anim.is_playing() and not pauseMenu.leftmouseDead :
			bulletInstance = bullet.instantiate()
			bulletInstance.position = raycast.global_position
			bulletInstance.transform.basis = raycast.global_transform.basis
			get_parent().add_child(bulletInstance)
			gun_anim.play("shoot")
			gun.get_node("AudioStreamPlayer3D").play()
			
			pitch.rotation.x = clamp(pitch.rotation.x + PI/16 * flip, -PI/2, PI/2)

	move_and_slide()
	
	#get all collisions after moving
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody3D:
			var body = collision.get_collider()
			
			# Apply force in the opposite direction of collision
			body.apply_impulse(-collision.get_normal() * 100000000000, collision.get_position() - body.global_position)


func _on_timer_timeout() -> void:
	$AudioStreamPlayer3D.stop()
