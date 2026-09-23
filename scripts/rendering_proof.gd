extends Node3D

# Shattered Realms: Reborn — Rendering Proof
# Showcase pass: locks the chunky modular 2.5D visual language before production art.
# This is intentionally procedural. Production assets must replace these stand-ins
# without changing the camera, scale, lighting, or gameplay-facing composition.

const TILE_SIZE := 3.6
const TILE_SPACING := 0.86
const BOARD_RADIUS := 5

var materials: Dictionary = {}

func _ready() -> void:
	_build_material_library()
	_build_environment()
	_build_camera()
	_build_lighting()
	_build_ground()
	_build_water()
	_build_path()
	_build_cliffs()
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
	# Bright grass tops + darker vertical faces are deliberate: they sell the
	# miniature-board look from the strategic camera.
	mat("ground", Color("#34482d"))
	mat("grass_a", Color("#83a84a"))
	mat("grass_b", Color("#9bbd55"))
	mat("grass_c", Color("#6f963e"))
	mat("grass_edge", Color("#4e7135"))
	mat("path", Color("#c19a5a"))
	mat("path_edge", Color("#87663e"))
	mat("stone", Color("#66645b"))
	mat("stone_dark", Color("#3e403a"))
	mat("stone_top", Color("#7c796c"))
	mat("water", Color("#20a9ad"), 0.24)
	mat("water_dark", Color("#16777f"), 0.32)
	mat("trunk", Color("#593a24"))
	mat("trunk_light", Color("#765032"))
	mat("pine_dark", Color("#28522c"))
	mat("pine_mid", Color("#3f7434"))
	mat("pine_light", Color("#5d913b"))
	mat("leaf_dark", Color("#4c792f"))
	mat("leaf", Color("#75a840"))
	mat("leaf_light", Color("#93c34b"))
	mat("rock", Color("#817c6b"))
	mat("rock_dark", Color("#5b584e"))
	mat("log", Color("#6f492b"))
	mat("unit_body", Color("#b58a4e"))
	mat("unit_cloak", Color("#493047"))
	mat("banner", Color("#d4a84d"))
	mat("banner_dark", Color("#6e3b32"))

func _build_environment() -> void:
	var world := WorldEnvironment.new()
	world.name = "WorldEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("#152119")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("#a4b68f")
	environment.ambient_light_energy = 0.82
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	world.environment = environment
	add_child(world)

func _build_camera() -> void:
	var camera := Camera3D.new()
	camera.name = "StrategicCamera"
	camera.position = Vector3(22, 25, 22)
	camera.look_at_from_position(camera.position, Vector3(0, 1.9, 0))
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 29.0
	camera.near = 0.1
	camera.far = 140.0
	camera.current = true
	add_child(camera)

func _build_lighting() -> void:
	var sun := DirectionalLight3D.new()
	sun.name = "Sun"
	sun.rotation_degrees = Vector3(-54, -34, 0)
	sun.light_energy = 1.35
	sun.light_color = Color("#ffe9bb")
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 95.0
	add_child(sun)

	var fill := OmniLight3D.new()
	fill.name = "ForestFill"
	fill.position = Vector3(-11, 11, 12)
	fill.light_color = Color("#8fb7a0")
	fill.light_energy = 0.52
	fill.omni_range = 38.0
	add_child(fill)

func _hex_tile(grid_x: int, grid_z: int, y: float, material_key: String, scale := 1.0) -> void:
	var tile := CylinderMesh.new()
	tile.top_radius = TILE_SIZE * 0.49 * scale
	tile.bottom_radius = TILE_SIZE * 0.49 * scale
	tile.height = 0.48
	tile.radial_segments = 6
	tile.rings = 1
	var px := grid_x * TILE_SIZE * TILE_SPACING
	var pz := grid_z * TILE_SIZE * TILE_SPACING
	if absi(grid_z) % 2 == 1:
		px += TILE_SIZE * TILE_SPACING * 0.5
	mesh_node(tile, materials[material_key], Vector3(px, y, pz))

func _build_ground() -> void:
	# Dark foundation gives every modular tile a readable underside.
	var base := BoxMesh.new()
	base.size = Vector3(38.0, 0.9, 38.0)
	mesh_node(base, materials["ground"], Vector3(0, -0.55, 0))

	for x in range(-BOARD_RADIUS, BOARD_RADIUS + 1):
		for z in range(-BOARD_RADIUS, BOARD_RADIUS + 1):
			# Carve the pond, path, and cliff footprint out of the board.
			if (x <= -2 and z >= -2 and z <= 2):
				continue
			if (x >= 2 and z <= -2 and z >= -4):
				continue
			var key := "grass_a"
			if (x + z) % 5 == 0:
				key = "grass_b"
			elif (x - z) % 4 == 0:
				key = "grass_c"
			_hex_tile(x, z, 0.22, key)

func _build_water() -> void:
	# A broad, simple pond reads like the reference while remaining a clean
	# production-replacement target for a proper water shader later.
	var pond := BoxMesh.new()
	pond.size = Vector3(7.8, 0.16, 14.2)
	var water_mat: StandardMaterial3D = materials["water"]
	water_mat.metallic_specular = 0.42
	mesh_node(pond, water_mat, Vector3(-7.0, 0.19, 0.0))

	# Raised stone crossing.
	var bridge := BoxMesh.new()
	bridge.size = Vector3(3.8, 0.42, 2.4)
	mesh_node(bridge, materials["stone_top"], Vector3(-5.0, 0.42, 0.2))

	# Small waterfall lip on the high terrain.
	var fall := BoxMesh.new()
	fall.size = Vector3(1.5, 4.2, 0.16)
	mesh_node(fall, materials["water_dark"], Vector3(4.0, 2.25, -4.4))

	var lip := BoxMesh.new()
	lip.size = Vector3(2.2, 0.3, 1.5)
	mesh_node(lip, materials["stone_top"], Vector3(4.0, 4.25, -4.0))

func _build_path() -> void:
	# Broad warm path broken into chunky slabs, with a slight bend toward the
	# elevated objective area.
	var points := [
		Vector3(-2.5, 0.42, 7.0),
		Vector3(-1.5, 0.42, 4.2),
		Vector3(-0.5, 0.42, 1.7),
		Vector3(0.6, 0.42, -0.7),
		Vector3(2.0, 0.42, -3.0),
		Vector3(3.7, 0.42, -5.0)
	]
	for i in range(points.size() - 1):
		var a: Vector3 = points[i]
		var b: Vector3 = points[i + 1]
		var center := (a + b) * 0.5
		var slab := BoxMesh.new()
		slab.size = Vector3(2.45, 0.16, a.distance_to(b) + 0.35)
		var node := mesh_node(slab, materials["path"], center)
		node.look_at(b, Vector3.UP)

func _build_cliffs() -> void:
	# Three stepped elevation tiers. The top grass caps deliberately overhang
	# the stone, creating the strong layered silhouette from the target image.
	for i in range(3):
		var width := 8.4 - i * 0.85
		var depth := 6.2 - i * 0.55
		var height := 1.25
		var y := 0.85 + i * height
		var rock := BoxMesh.new()
		rock.size = Vector3(width, height, depth)
		mesh_node(rock, materials["stone"] if i < 2 else materials["stone_dark"],
			Vector3(6.4, y, -4.1))

		var cap := BoxMesh.new()
		cap.size = Vector3(width + 0.22, 0.26, depth + 0.22)
		mesh_node(cap, materials["grass_b"], Vector3(6.4, y + height * 0.52, -4.1))

	# Dark bands make each elevation level legible.
	for i in range(2):
		var band := BoxMesh.new()
		band.size = Vector3(8.65 - i * 0.85, 0.18, 0.22)
		mesh_node(band, materials["stone_dark"], Vector3(6.4, 1.55 + i * 1.25, -7.18 + i * 0.25))

	# A compact ruined platform gives the scene a focal landmark.
	for i in range(3):
		var ruin := BoxMesh.new()
		ruinsize(i, ruin)
		mesh_node(ruin, materials["stone_dark"], Vector3(7.0, 5.0 + i * 0.65, -4.0))

	var ruin_cap := BoxMesh.new()
	ruin_cap.size = Vector3(4.2, 0.22, 3.5)
	mesh_node(ruin_cap, materials["grass_c"], Vector3(7.0, 7.0, -4.0))

func ruinsize(i: int, mesh: BoxMesh) -> void:
	mesh.size = Vector3(5.4 - i * 0.55, 0.55, 4.4 - i * 0.45)

func _build_forest() -> void:
	var pines := [
		Vector3(-9, 0, -8), Vector3(-5, 0, -8.8), Vector3(-1.5, 0, -8.2),
		Vector3(3.0, 0, -8.8), Vector3(7.5, 0, -8.0),
		Vector3(-10, 0, -3.4), Vector3(-4.0, 0, -3.8),
		Vector3(2.7, 0, 2.8), Vector3(8.8, 5.15, -6.8),
		Vector3(10.3, 5.15, -2.8), Vector3(5.0, 5.15, -7.0)
	]
	for p in pines:
		_pine(p)

	var broadleaf := [
		Vector3(-10.0, 0, 4.8), Vector3(-4.0, 0, 6.2),
		Vector3(3.8, 0, 6.4), Vector3(9.6, 5.15, -7.2),
		Vector3(10.2, 0, 5.2)
	]
	for p in broadleaf:
		_broadleaf(p)

func _pine(p: Vector3) -> void:
	var trunk := CylinderMesh.new()
	trunk.top_radius = 0.18
	trunk.bottom_radius = 0.30
	trunk.height = 3.0
	trunk.radial_segments = 6
	mesh_node(trunk, materials["trunk"], p + Vector3(0, 1.5, 0))

	for i in range(3):
		var crown := CylinderMesh.new()
		crown.top_radius = 0.04
		crown.bottom_radius = 1.65 - i * 0.30
		crown.height = 1.75
		crown.radial_segments = 6
		var key := "pine_dark"
		if i == 1:
			key = "pine_mid"
		elif i == 2:
			key = "pine_light"
		mesh_node(crown, materials[key], p + Vector3(0, 2.65 + i * 0.98, 0))

func _broadleaf(p: Vector3) -> void:
	var trunk := CylinderMesh.new()
	trunk.top_radius = 0.22
	trunk.bottom_radius = 0.36
	trunk.height = 2.55
	trunk.radial_segments = 6
	mesh_node(trunk, materials["trunk_light"], p + Vector3(0, 1.28, 0))

	var offsets := [
		Vector3(-0.55, 2.35, 0),
		Vector3(0.55, 2.55, 0.12),
		Vector3(0, 3.15, 0)
	]
	for i in range(offsets.size()):
		var crown := SphereMesh.new()
		crown.radius = 1.08 - i * 0.10
		crown.height = 1.6
		var key := "leaf"
		if i == 0:
			key = "leaf_dark"
		elif i == 2:
			key = "leaf_light"
		var node := mesh_node(crown, materials[key], p + offsets[i])
		node.scale = Vector3(1.15, 0.82, 1.0)

func _build_props() -> void:
	var rocks := [
		Vector3(-3.0, 0.58, -4.4),
		Vector3(2.8, 0.58, 4.8),
		Vector3(-8.8, 0.58, 5.8),
		Vector3(9.2, 5.75, 0.1),
		Vector3(5.0, 0.55, 5.4)
	]
	for p in rocks:
		var rock := SphereMesh.new()
		rock.radius = 0.72
		rock.height = 1.0
		var node := mesh_node(rock, materials["rock"], p)
		node.scale = Vector3(1.25, 0.78, 1.0)

	# Fallen log.
	var log_mesh := CylinderMesh.new()
	log_mesh.top_radius = 0.25
	log_mesh.bottom_radius = 0.34
	log_mesh.height = 3.4
	log_mesh.radial_segments = 8
	var log_node := mesh_node(log_mesh, materials["log"], Vector3(1.8, 0.52, -2.2))
	log_node.rotation_degrees = Vector3(0, 0, 70)

	# Small boundary posts around the elevated route.
	for z in [-1.5, 1.0, 3.5]:
		var post := BoxMesh.new()
		post.size = Vector3(0.32, 1.45, 0.32)
		mesh_node(post, materials["trunk"], Vector3(4.5, 0.73, z))

	# Two chunky gate pillars at the objective.
	for x in [4.8, 9.2]:
		var pillar := BoxMesh.new()
		pillar.size = Vector3(0.7, 2.7, 0.7)
		mesh_node(pillar, materials["stone_top"], Vector3(x, 6.7, -6.0))

func _build_test_unit() -> void:
	var root := Node3D.new()
	root.name = "TestUnit"
	root.position = Vector3(-0.2, 0.0, 3.0)
	add_child(root)

	var base := CylinderMesh.new()
	base.top_radius = 0.68
	base.bottom_radius = 0.68
	base.height = 0.16
	base.radial_segments = 8
	mesh_node(base, materials["stone_dark"], Vector3(0, 0.08, 0), root)

	var body := CapsuleMesh.new()
	body.radius = 0.42
	body.height = 1.65
	body.radial_segments = 8
	mesh_node(body, materials["unit_body"], Vector3(0, 1.0, 0), root)

	var cloak := SphereMesh.new()
	cloak.radius = 0.75
	cloak.height = 1.55
	var cloak_node := mesh_node(cloak, materials["unit_cloak"], Vector3(0, 1.18, 0), root)
	cloak_node.scale = Vector3(1.0, 0.85, 1.0)

	var banner_pole := CylinderMesh.new()
	banner_pole.top_radius = 0.035
	banner_pole.bottom_radius = 0.05
	banner_pole.height = 2.5
	banner_pole.radial_segments = 6
	mesh_node(banner_pole, materials["trunk"], Vector3(0.72, 1.45, 0), root)

	var banner := BoxMesh.new()
	banner.size = Vector3(0.10, 1.05, 0.72)
	mesh_node(banner, materials["banner"], Vector3(0.75, 2.0, 0), root)

	var banner_mark := BoxMesh.new()
	banner_mark.size = Vector3(0.06, 0.35, 0.35)
	mesh_node(banner_mark, materials["banner_dark"], Vector3(0.72, 2.0, 0), root)
