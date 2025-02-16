extends Area3D

var is_inside_rock := false
const FULL_STONE_SOUNDS = [
	preload("res://Tools/Chisel/Sounds/full_stone-01.mp3"),
	preload("res://Tools/Chisel/Sounds/full_stone-02.mp3"),
	preload("res://Tools/Chisel/Sounds/full_stone-03.mp3"),
	preload("res://Tools/Chisel/Sounds/full_stone-04.mp3"),
	preload("res://Tools/Chisel/Sounds/full_stone-05.mp3"),
	preload("res://Tools/Chisel/Sounds/full_stone-06.mp3"),
	preload("res://Tools/Chisel/Sounds/full_stone-07.mp3")
]
const HOLLOW_STONE_SOUNDS = [
	preload("res://Tools/Chisel/Sounds/hollow_stone-01.mp3"),
	preload("res://Tools/Chisel/Sounds/hollow_stone-02.mp3"),
	preload("res://Tools/Chisel/Sounds/hollow_stone-03.mp3"),
	preload("res://Tools/Chisel/Sounds/hollow_stone-04.mp3")
]

func play_sound(sound_collection):
	var audio_stream_player = AudioStreamPlayer3D.new()
	audio_stream_player.global_position = global_position
	audio_stream_player.top_level = true
	audio_stream_player.max_distance = 90
	audio_stream_player.stream = sound_collection.pick_random()
	audio_stream_player.finished.connect(func():
		audio_stream_player.queue_free())
	add_child(audio_stream_player)
	audio_stream_player.play()


func _on_body_entered(body: Node3D) -> void:
	if !is_inside_rock:
		is_inside_rock = true
		for overlapped_body in get_overlapping_bodies():
			if !overlapped_body.is_class("StaticBody3D"):
				continue
			if overlapped_body.is_in_group("rune_point"):
				play_sound(FULL_STONE_SOUNDS)
				return
			play_sound(HOLLOW_STONE_SOUNDS)
		

func _on_body_exited(body: Node3D) -> void:
	if len(get_overlapping_bodies()) == 0:
		is_inside_rock = false
