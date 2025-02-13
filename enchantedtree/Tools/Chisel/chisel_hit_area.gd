extends StaticBody3D

var tool_velocity := 0.0

var previous_position := Vector3.ZERO

func _ready():
	previous_position = global_transform.origin

func _physics_process(delta: float) -> void:
	tool_velocity = ((global_transform.origin - previous_position) / delta).length()
	previous_position = global_position
