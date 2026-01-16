extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_area_entered(area: Area3D) -> void:
		if area.is_in_group("bullet"):
			$RootNode/Skeleton3D/PhysicalBoneSimulator3D.physical_bones_start_simulation()
