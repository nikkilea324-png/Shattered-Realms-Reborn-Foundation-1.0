extends Node3D

# Shattered Realms: Reborn — Rendering Proof
# This scene intentionally uses procedural primitives so the rendering contract
# can be tested before any external art assets are introduced.

const GROUND_SIZE := 24.0
const TILE_SIZE := 4.0

func _ready() -> void:
	_build_environment()
	_build_camera()
	_build_lighting()
	_build_ground()
	_build_cliff()
	_build_water()
	_build_forest()
	_build_props()
	_build_test_unit()

func mat(color: Color, roughness := 0.82) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	m.metallic = 0.0
	return m

func mesh_node(mesh: Mesh, material: Material, position: Vector3, parent := self) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.mesh = mesh
	node.position = position
	node.material_override = material
	parent.add_child(node)
	return node

func _build_environment() -> void:
	var world := WorldEnvironment.new()
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
	camera.position = Vector3(18, 20, 18)
	camera.look_at_from_position(camera.position, Vector3(0, 1.5, 0))
	camera.fov = 42.0
	add_child(camera)
	camera.current = true

func _build_lighting() -> void:
	var sun := DirectionalLight3D.new()
	sun.name = "Sun"
	sun.rotation_degrees = Vector3(-48, -32, 0)
	sun.light_energy = 1.15
	sun.shadow_enabled = true
	add_child(sun)

	var fill := OmniLight3D.new()
	fill.position = Vector3(-8, 8, 8)
	fill.light_energy = 0.7
	fill.omni_range = 30.0
	add_child(fill)

func _build_ground() -> void:
	var ground := BoxMesh.new()
	ground.size = Vector3(GROUND_SIZE, 0.8, GROUND_SIZE)
	mesh_node(ground, mat(Color("#536b35")), Vector3(0, -0.4, 0))

	# Small terrain plates establish the modular-tile language.
	for x in range(-2, 3):
		for z in range(-2, 3):
			var tile := BoxMesh.new()
			tile.size = Vector3(TILE_SIZE - 0.08, 0.32, TILE_SIZE - 0.08)
			var color := Color("#5f743c") if (x + z) % 2 == 0 else Color("#657b42")
			mesh_node(tile, mat(color), Vector3(x * TILE_SIZE, 0.15, z * TILE_SIZE))

func _build_cliff() -> void:
	var rock := BoxMesh.new()
	rock.size = Vector3(7.0, 4.0, 5.5)
	mesh_node(rock, mat(Color("#555047")), Vector3(6.5, 2.0, -4.0))

	var grass := BoxMesh.new()
	grass.size = Vector3(7.1, 0.35, 5.6)
	mesh_node(grass, mat(Color("#718f43")), Vector3(6.5, 4.18, -4.0))

func _build_water() -> void:
	var water := BoxMesh.new()
	water.size = Vector3(6.5, 0.16, 14.0)
	var water_mat := mat(Color("#236b78"), 0.28)
	water_mat.metallic_specular = 0.45
	mesh_node(water, water_mat, Vector3(-6.5, 0.08, 1.0))

func _build_forest() -> void:
	var positions := [
		Vector3(-7, 0, -7), Vector3(-3, 0, -8), Vector3(1, 0, -7),
		Vector3(-9, 0, -2), Vector3(-4, 0, -2), Vector3(1, 0, 1),
		Vector3(8, 4.35, -5), Vector3(10, 4.35, -2), Vector3(7, 4.35, -7)
	]
	for p in positions:
		_tree(p)

func _tree(p: Vector3) -> void:
	var trunk := CylinderMesh.new()
	trunk.top_radius = 0.22
	trunk.bottom_radius = 0.34
	trunk.height = 2.8
	mesh_node(trunk, mat(Color("#513a25")), p + Vector3(0, 1.4, 0))

	for i in range(3):
		var crown := CylinderMesh.new()
		crown.top_radius = 0.0
		crown.bottom_radius = 1.55 - i * 0.28
		crown.height = 2.0
		var green := Color("#244b2a") if i == 0 else Color("#315d2e")
		mesh_node(crown, mat(green), p + Vector3(0, 3.0 + i * 1.05, 0))

func _build_props() -> void:
	for p in [Vector3(-1, 0.4, -4), Vector3(3, 0.4, 4), Vector3(8, 4.6, 0)]:
		var rock := SphereMesh.new()
		rock.radius = 0.7
		rock.height = 1.0
		var node := mesh_node(rock, mat(Color("#70695c")), p)
		node.scale = Vector3(1.25, 0.8, 1.0)

	var log_mesh := CylinderMesh.new()
	log_mesh.top_radius = 0.25
	log_mesh.bottom_radius = 0.32
	log_mesh.height = 3.2
	var log_node := mesh_node(log_mesh, mat(Color("#68462c")), Vector3(2, 0.55, -2))
	log_node.rotation_degrees = Vector3(0, 0, 72)

func _build_test_unit() -> void:
	var root := Node3D.new()
	root.name = "TestUnit"
	root.position = Vector3(0, 0, 3)
	add_child(root)

	var body := CapsuleMesh.new()
	body.radius = 0.45
	body.height = 1.7
	mesh_node(body, mat(Color("#8a6b42")), Vector3(0, 1.0, 0), root)

	var cloak := SphereMesh.new()
	cloak.radius = 0.72
	cloak.height = 1.5
	mesh_node(cloak, mat(Color("#3c2631")), Vector3(0, 1.2, 0), root)

	var banner := BoxMesh.new()
	banner.size = Vector3(0.12, 1.8, 0.7)
	mesh_node(banner, mat(Color("#b48b4b")), Vector3(0.75, 1.8, 0), root)
