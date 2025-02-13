extends Node3D

func _ready() -> void:
	var inner_static_bodies = find_children("", "StaticBody3D", true)
	for inner_body:StaticBody3D in inner_static_bodies:
		inner_body.set_collision_layer_value(1, false)
		inner_body.set_collision_layer_value(8, true)
