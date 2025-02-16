extends Node3D

@export var minimum_broken_to_finish := 15

@onready var rune_shape: Path3D = $RuneShape
@onready var curve := rune_shape.curve
var rune_points := []
var chunk_tweens := {}
var rune_chunk_count := 0
var destroyed_chunks := 0

@onready var shader_source: MeshInstance3D = $ShaderSource

signal correct_fragment_carved(destroyed_chunks)
signal correct_fragment_treshold_reached()

func init_shape():
	pass
	
func on_fragment_destroy():
	pass
	
func _ready():
	var inner_static_bodies = find_children("", "StaticBody3D", true)
	for inner_body: StaticBody3D in inner_static_bodies:		
		inner_body.set_collision_layer_value(1, false)
		inner_body.set_collision_layer_value(14, true)
		inner_body.add_to_group("chisable")
		var mesh_instance = inner_body.get_parent() as MeshInstance3D
		var material := shader_source.get_active_material(0).duplicate()
		
		mesh_instance.mesh.surface_set_material(1, material)	
		mesh_instance.mesh.surface_set_material(0, material)	
	
	for point in curve.get_baked_points():
		var rune_point = Area3D.new()
		var collision_shape = CollisionShape3D.new()
		collision_shape.shape = SphereShape3D.new()
		collision_shape.shape.radius = 0.005
		rune_point.add_child(collision_shape)
		rune_point.position = rune_shape.transform.basis * point
		rune_point.set_collision_mask_value(14, true)
		rune_shape.add_child(rune_point)
		rune_points.append(rune_point)
	
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(process_rune_points_overlaps)
	add_child(timer)
	timer.start()
	
func process_rune_points_overlaps():
	for rune_point: Area3D in rune_points:
		for fragment: StaticBody3D in rune_point.get_overlapping_bodies():
			if !fragment.is_in_group("rune_point"):
				rune_chunk_count += 1
				fragment.add_to_group('rune_point')
			#var mesh_instance = fragment.get_parent() as MeshInstance3D
			#var material := StandardMaterial3D.new()
			#material.albedo_color = Color.RED
			#mesh_instance.mesh.surface_set_material(1, material)	

		var debug_mesh = MeshInstance3D.new()
		debug_mesh.mesh = SphereMesh.new()
		debug_mesh.mesh.height = 0.02
		debug_mesh.mesh.radius = 0.01
		debug_mesh.position = rune_point.position
		rune_shape.add_child(debug_mesh)
		debug_mesh.translate(Vector3(-0.1, 0, 0))
