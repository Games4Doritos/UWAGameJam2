extends Area3D

var player

const SPEED = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += (player.position - position).normalized() * delta * SPEED


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().current_scene.gameOver()
		body.hit()


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("bullet"):
		queue_free()
