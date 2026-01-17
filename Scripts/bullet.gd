extends Node3D

@onready var mesh = $MeshInstance3D
@onready var raycast = $RayCast3D
@onready var particles = $GPUParticles3D

const SPEED = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(SPEED, 0, 0) * delta
	
	if raycast.is_colliding():
		mesh.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_3d_area_entered(area: Area3D) -> void:
	mesh.visible = false
	particles.emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
