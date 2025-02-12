extends RigidBody3D


var target = null
var vel = 1.5
func _process(delta):
	var tvec = target - position if target != null else Vector3.ZERO
	var tdist = tvec.length() if target != null else 0.0
	if tdist < 0.05:
		var tpos = Vector3(
			clampf(position.x + randf_range(-1, 1), -2, 2), 
			clampf(position.y + randf_range(-1, 1)*0.2, 0.6, 1.8), 
			clampf(position.z + randf_range(-1, 1), -2, 2))
		look_at(tpos)
		$RayCast3D.force_raycast_update()
		if $RayCast3D.is_colliding():
			target = $RayCast3D.get_collision_point()
		else:
			target = $RayCast3D.global_transform*$RayCast3D.target_position
		tvec = target - position
		tdist = tvec.length()
		
		$Glow.get_surface_override_material(0).albedo_color = Color.YELLOW * ((sin(Time.get_ticks_msec()*0.005) + 1)/2)

	position += tvec*(delta*vel/tdist)
