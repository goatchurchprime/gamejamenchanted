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

func restore_chunk(material: ShaderMaterial, weight):
	material.set_shader_parameter("DissolveRate", weight)
	
func _on_body_entered(body: StaticBody3D) -> void:
	label_3d.text = str(body.get_groups())

	if body.is_in_group("chisel_hammer_hit"):
		if body.tool_velocity == null:
			return
		var velocity = body.tool_velocity
		label_3d.text = str(velocity)
		
		if velocity < min_hammer_velocity: 
			return
		
		var bodies_in_target = break_area.get_overlapping_bodies()
		for body_in_target in bodies_in_target:
			if body_in_target.is_in_group("chisable"):
				var parent_mesh = body_in_target.get_parent() as MeshInstance3D
				var material = parent_mesh.mesh.surface_get_material(0) as ShaderMaterial
				material.set_shader_parameter("DissolveRate", 1)
				
				if !body_in_target.is_in_group("rune_point"):
					var id = parent_mesh.get_instance_id()
					if body_in_target.owner.chunk_tweens.has(id):
						body_in_target.owner.chunk_tweens[id].kill()
					body_in_target.owner.chunk_tweens[id] = create_tween()
					body_in_target.owner.chunk_tweens[id].tween_method(func (rate): 
						restore_chunk(material, rate)
					, 1.0, 0.0, 3.0)
					
	
		get_node("/root/Main/XROrigin3D/XRControllerLeft").trigger_haptic_pulse(&"haptic",0,0.5,0.25,0)
		get_node("/root/Main/XROrigin3D/XRControllerRight").trigger_haptic_pulse(&"haptic",0,1.0,0.09,0)
		$GPUParticles3D.emitting = true

		var audio_stream_player = AudioStreamPlayer3D.new()
		audio_stream_player.global_position = global_position
		audio_stream_player.top_level = true
		audio_stream_player.max_distance = 90
		audio_stream_player.volume_linear = clampf(velocity / 4, 0.1, 0.8)
		audio_stream_player.stream = hit_sounds.pick_random()
		audio_stream_player.finished.connect(func():
			audio_stream_player.queue_free())
		add_child(audio_stream_player)
		audio_stream_player.play()
		
		var owner_hand = body.owner.holding_hand
		if XRServer and owner_hand:
			var active_hand = owner_hand.tracker
			var trigger_name = ""
			if active_hand == "left_hand":
				trigger_name = "haptic_left"
			if active_hand == "right_hand":
				trigger_name = "haptic_right"
			XRServer.primary_interface.trigger_haptic_pulse(
				trigger_name,
				active_hand,
				0.0,
				1.0,
				0.15,
				0.0
			)
	
