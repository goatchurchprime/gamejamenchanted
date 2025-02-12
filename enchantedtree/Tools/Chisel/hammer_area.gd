extends Area3D

const hit_sounds = [
	preload("res://Tools/Chisel/Sounds/metal_hit_-01.mp3"),
	preload("res://Tools/Chisel/Sounds/metal_hit_-02.mp3"),
	preload("res://Tools/Chisel/Sounds/metal_hit_-03.mp3"),
	preload("res://Tools/Chisel/Sounds/metal_hit_-04.mp3"),
	preload("res://Tools/Chisel/Sounds/metal_hit_-05.mp3")
]

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("chisel_hammer_hit"):
		var audio_stream_player = AudioStreamPlayer3D.new()
		audio_stream_player.global_position = global_position
		audio_stream_player.top_level = true
		audio_stream_player.stream = hit_sounds.pick_random()
		audio_stream_player.finished.connect(func():
			audio_stream_player.queue_free())
		add_child(audio_stream_player)
		audio_stream_player.play()
