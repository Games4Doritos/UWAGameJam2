extends CSGMesh3D


const hole = preload("res://Scenes/hole.tscn")

func createHole(x,h):
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
	#Bit confusing, the noise is fetched for a certain (x,y) point, this point is roughly transformed to (noise * platform width, x) which is where the shape is placed
	newHole.position = Vector3(h*self.mesh.size.x,0,x-self.mesh.size.z/2)
	self.add_child(newHole)

	
func _ready():
	var noiseCreator = FastNoiseLite.new()
	noiseCreator.noise_type = FastNoiseLite.TYPE_PERLIN
	for i in int(self.mesh.size.z/3):
		for x in int(self.mesh.size.x/3):
			var noise = noiseCreator.get_noise_2d(3*x,3*i)
			createHole(3*i, noise)
			print(noise)
				
	
	
	
