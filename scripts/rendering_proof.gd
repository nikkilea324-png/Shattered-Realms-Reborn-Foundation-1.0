extends Node3D

# Shattered Realms: Reborn — Rendering Proof
# Procedural stand-in scene used to lock the camera, lighting, terrain,
# elevation, vegetation, props, water, and unit readability before production art.

const TILE_SIZE := 4.0

var materials: Dictionary = {}

func _ready() -> void:
	_build_material_library()
	_build_environment()
	_build_camera()
	_build_lighting()
	_build_ground()
	_build_path()
	_build_cliff_and_shore()
	_build_water()
	_build_forest()
	_build_props()
	_build_test_unit()

func mat(key: String, color: Color, roughness := 0.82) -> StandardMaterial3D:
	if materials.has(key):
		return materials[key]
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	m.metallic = 0.0
	materials[key] = m
	return m

func mesh_node(mesh: Mesh, material: Material, position: Vector3, parent: Node = self) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.mesh = mesh
	node.position = position
	node.material_override = material
	parent.add_child(node)
	return node

func _build_material_library() -> void:
	mat("ground", Color("#4f6635"))
	mat("grass_a", Color("#627a3d"))
	mat("grass_b", Color("#718847"))
	mat("path", Color("#78664b"))
	mat("stone", Color("#56534d"))
	mat("stone_dark", Color("#403e3a"))
	mat("water", Color("#1f6873"), 0.3)
	mat("trunk", Color("#503923"))
	mat("pine_dark", Color("#21452a"))
	mat("pine_mid", Color("#315f31"))
	mat("leaf", Color("#466d38"))
	mat("rock", Color("#70695c"))
	mat("log", Color("#68462c"))
	mat("unit_body", Color("#9a7646"))
	mat("unit_cloak", Color("#3c2631"))
	mat("banner", Color("#b48b4b"))

func _build_environment() -> void:
	var world := WorldEnvironment.new()
	world.name = "WorldEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("#172019")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("#91a37e")
	environment.ambient_light_energy = 0.72
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	world.environment = environment
	add_child(world)

func _build_camera() -> void:
	var camera := Camera3D.new()
	camera.name = "StrategicCamera"
	camera.position = Vector3(19, 22, 19)
	camera.look_at_from_position(camera.position, Vector3(0, 1.8, 0))
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 24.0
	camera.near = 0.1
	camera.far = 120.0
	camera.current = true
	add_child(camera)

func _build_lighting() -> void:
	var sun := DirectionalLight3D.new()
	sun.name = "Sun"
	sun.rotation_degrees = Vector3(-52, -32, 0)
	sun.light_energy = 1.2
	sun.light_color = Color("#fff0cf")
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 80.0
	add_child(sun)

	var fill := OmniLight3D.new()
	fill.name = "ForestFill"
	fill.position = Vector3(-8, 9, 10)
	fill.light_color = Color("#9db9a1")
	fill.light_energy = 0.65
	fill.omni_range = 32.0
	add_child(fill)

func _build_ground() -> void:
	var base := BoxMesh.new()
	base.size = Vector3(28.0, 0.7, 28.0)
	mesh_node(base, materials["ground"], Vector3(0, -0.35, 0))

	# Modular hex plates are the visual language test; production tiles will replace these.
	for x in range(-3, 4):
		for z in range(-3, 4):
			if x == -2 and z >= -1 and z <= 2:
				continue
			var tile := CylinderMesh.new()
			tile.top_radius = TILE_SIZE * 0.49
			tile.bottom_radius = TILE_SIZE * 0.49
			tile.height = 0.28
			tile.radial_segments = 6
			var key := "grass_a" if (x + z) % 2 == 0 else "grass_b"
			mesh_node(tile, materials[key], Vector3(x * TILE_SIZE * 0.88, 0.12, z * TILE_SIZE * 0.88))

func _build_path() -> void:
	for z in range(-5, 6):
		var tile := BoxMesh.new()
		tile.size = Vector3(2.2, 0.12, 3.1)
		mesh_node(tile, materials["path"], Vector3(0, 0.32, z * 1.9))

func _build_cliff_and_shore() -> void:
	# Stepped cliff demonstrates elevation transitions and layered grass caps.
	for i in range(3):
		var rock := BoxMesh.new()
		rock.size = Vector3(7.4 - i * 0.45, 1.35, 5.8 - i * 0.35)
		mesh_node(rock, materials["stone"] if i < 2 else materials["stone_dark"],
			Vector3(6.4, 0.68 + i * 1.35, -4.0 + i * 0.05))

		var cap := BoxMesh.new()
		cap.size = Vector3(7.5 - i * 0.45, 0.22, 5.9 - i * 0.35)
		mesh_node(cap, materials["grass_b"], Vector3(6.4, 1.4 + i * 1.35, -4.0 + i * 0.05))

	# A small exposed rock shelf makes the shoreline readable.
	var shelf := BoxMesh.new()
	shelf.size = Vector3(4.5, 0.65, 2.6)
	mesh_node(shelf, materials["stone"], Vector3(-5.8, 0.15, 5.0))

func _build_water() -> void:
	var water := BoxMesh.new()
	water.size = Vector3(5.0, 0.12, 14.0)
	var water_mat: StandardMaterial3D = materials["water"]
	water_mat.metallic_specular = 0.35
	mesh_node(water, water_mat, Vector3(-7.0, 0.14, 0.5))

	# Narrow waterfall test on the cliff face.
	var fall := BoxMesh.new()
	fall.size = Vector3(1.3, 3.8, 0.12)
	mesh_node(fall, water_mat, Vector3(4.25, 1.95, -3.1))

func _build_forest() -> void:
	var pines := [
		Vector3(-8, 0, -8), Vector3(-3, 0, -8.5), Vector3(3, 0, -8),
		Vector3(-10, 0, -2.5), Vector3(-4, 0, -2.8),
		Vector3(3.5, 0, 2.0), Vector3(9.0, 4.3, -6.0), Vector3(10.0, 4.3, -2.0)
	]
	for p in pines:
		_pine(p)

	var broadleaf := [
		Vector3(-10, 0, 5), Vector3(-3, 0, 6.5), Vector3(4, 0, 6.5),
		Vector3(10, 4.3, -7.5)
	]
	for p in broadleaf:
		_broadleaf(p)

func _pine(p: Vector3) -> void:
	var trunk := CylinderMesh.new()
	trunk.top_radius = 0.18
	trunk.bottom_radius = 0.32
	trunk.height = 2.8
	mesh_node(trunk, materials["trunk"], p + Vector3(0, 1.4, 0))

	for i in range(3):
		var crown := CylinderMesh.new()
		crown.top_radius = 0.0
		crown.bottom_radius = 1.6 - i * 0.32
		crown.height = 1.9
		crown.radial_segments = 6
		var key := "pine_dark" if i == 0 else "pine_mid"
		mesh_node(crown, materials[key], p + Vector3(0, 2.8 + i * 1.0, 0))

func _broadleaf(p: Vector3) -> void:
	var trunk := CylinderMesh.new()
	trunk.top_radius = 0.24
	trunk.bottom_radius = 0.38
	trunk.height = 2.4
	mesh_node(trunk, materials["trunk"], p + Vector3(0, 1.2, 0))

	for i in range(3):
		var crown := SphereMesh.new()
		crown.radius = 1.05 - i * 0.14
		crown.height = 1.65
		var node := mesh_node(crown, materials["leaf"], p + Vector3((i - 1) * 0.5, 2.65 + i * 0.7, 0))
		node.scale = Vector3(1.1, 0.8, 1.0)

func _build_props() -> void:
	for p in [Vector3(-2.5, 0.55, -4.0), Vector3(3.0, 0.55, 4.5), Vector3(8.7, 4.9, 0.0)]:
		var rock := SphereMesh.new()
		rock.radius = 0.72
		rock.height = 1.0
		var node := mesh_node(rock, materials["rock"], p)
		node.scale = Vector3(1.25, 0.8, 1.0)

	var log_mesh := CylinderMesh.new()
	log_mesh.top_radius = 0.25
	log_mesh.bottom_radius = 0.32
	log_mesh.height = 3.2
	var log_node := mesh_node(log_mesh, materials["log"], Vector3(2.2, 0.5, -2.0))
	log_node.rotation_degrees = Vector3(0, 0, 72)

	# Simple boundary posts test prop scale and silhouette.
	for z in [-2.0, 1.0, 4.0]:
		var post := BoxMesh.new()
		post.size = Vector3(0.28, 1.5, 0.28)
		mesh_node(post, materials["trunk"], Vector3(5.0, 0.75, z))

func _build_test_unit() -> void:
	var root := Node3D.new()
	root.name = "TestUnit"
	root.position = Vector3(0, 0, 3)
	add_child(root)

	var body := CapsuleMesh.new()
	body.radius = 0.45
	body.height = 1.7
	mesh_node(body, materials["unit_body"], Vector3(0, 1.0, 0), root)

	var cloak := SphereMesh.new()
	cloak.radius = 0.72
	cloak.height = 1.5
	mesh_node(cloak, materials["unit_cloak"], Vector3(0, 1.2, 0), root)

	var banner := BoxMesh.new()
	banner.size = Vector3(0.12, 1.8, 0.7)
	mesh_node(banner, materials["banner"], Vector3(0.75, 1.8, 0), root)

	var base := CylinderMesh.new()
	base.top_radius = 0.62
	base.bottom_radius = 0.62
	base.height = 0.12
	base.radial_segments = 8
	mesh_node(base, materials["stone_dark"], Vector3(0, 0.08, 0), root)
