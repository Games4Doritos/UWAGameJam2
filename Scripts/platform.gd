extends CSGMesh3D


const hole = preload("res://Scenes/hole.tscn")

func createHole(x,y, h):
	var newHole := hole.instantiate()
	#random shape
	var result = randi_range(0,3)
	if result == 3:
		newHole.set_mesh(BoxMesh.new()) 
		newHole.mesh.size.x = randf_range(1.5 ,3)
		newHole.mesh.size.z = randf_range(1.5 ,3)
	elif result == 2:
		newHole.set_mesh(SphereMesh.new())
		newHole.mesh.radius = randf_range(0.75, 3)
	elif result == 1:
		newHole.set_mesh(PrismMesh.new())
		newHole.mesh.size.x = randf_range(1.5 ,3)
		newHole.mesh.size.z = randf_range(1.5 ,3)
	else:
		newHole.set_mesh(TorusMesh.new())
		newHole.mesh.outer_radius = randf_range(1.2,3)
		newHole.mesh.inner_radius = randi_range(newHole.mesh.outer_radius/5, newHole.mesh.outer_radius/2)
	newHole.position = Vector3(x-self.mesh.size.x/2, h*100, y - self.mesh.size.z/2)
	self.add_child(newHole)

	
func _ready():
	var noiseCreator = FastNoiseLite.new()
	noiseCreator.noise_type = FastNoiseLite.TYPE_SIMPLEX
	for i in int(self.mesh.size.z):
		for x in int(self.mesh.size.x):
			var noise = noiseCreator.get_noise_2d(x,i)
			#createHole(x,i, noise)
			if noise > 0:
				print(noise)
				
	
	
	
