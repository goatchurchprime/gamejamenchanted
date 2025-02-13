extends Area3D

@export var material: StandardMaterial3D
@export var min_hammer_velocity = 1.0
@onready var rune_detect_area: Area3D = $"../RuneDetectArea"
@onready var hit_point: Marker3D = $"../HitPoint"
@onready var break_area: Area3D = $"../BreakArea"

const hit_sounds = [
	preload("res://Tools/Chisel/Sounds/metal_hit_-01.mp3"),
	preload("res://Tools/Chisel/Sounds/metal_hit_-02.mp3"),
	preload("res://Tools/Chisel/Sounds/metal_hit_-03.mp3"),
	preload("res://Tools/Chisel/Sounds/metal_hit_-04.mp3"),
	preload("res://Tools/Chisel/Sounds/metal_hit_-05.mp3")
]

@onready var label_3d: Label3D = $Label3D


func _on_body_entered(body: StaticBody3D) -> void:
	label_3d.text = str(body.get_groups())

	if body.is_in_group("chisel_hammer_hit"):
		if body.tool_velocity == null:
			return
		var velocity = body.tool_velocity
		label_3d.text = str(velocity)
		
		#if velocity < min_hammer_velocity: 
			#return
		
		var bodies_in_target = break_area.get_overlapping_bodies()
		for body_in_target in bodies_in_target:
			label_3d.text += " " + str(body_in_target.name) 
			if body_in_target.get_parent().get_parent().is_in_group("chisable"):
				body_in_target.get_parent().queue_free()
				#label_3d.text += " YAYAYAY"
				#var csg_body = body_in_target as CSGMesh3D
				#var remove_area = CSGSphere3D.new()
				#remove_area.radius = 3
				#remove_area.global_position = hit_point.global_position
				#remove_area.set_operation(CSGShape3D.OPERATION_SUBTRACTION)
				#body.add_child(remove_area)
				#var combiner = CSGCombiner3D.new()
				#combiner.add_child(body_in_target)
				#combiner.add_child(remove_area)
				#
				#var combined_mesh = combiner.bake_static_mesh()
				#csg_body.mesh = combined_mesh
		
			
		var audio_stream_player = AudioStreamPlayer3D.new()
		audio_stream_player.global_position = global_position
		audio_stream_player.top_level = true
		audio_stream_player.max_distance = 90
		audio_stream_player.stream = hit_sounds.pick_random()
		audio_stream_player.finished.connect(func():
			audio_stream_player.queue_free())
		add_child(audio_stream_player)
		audio_stream_player.play()
