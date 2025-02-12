extends RigidBody3D


var target = null
var flyvelocity = 1.2
var xzrange = 3.0
var yrange = 0.5
var xzmotion = 0.9
var ymotion = 0.2
func _physics_process(delta):
	var tvec = target - position if target != null else Vector3.ZERO
	var tdist = tvec.length()
	if tdist < 0.05:
		target = Vector3(
			clampf(position.x + randf_range(-xzmotion, xzmotion), -xzrange, xzrange), 
			clampf(position.y + randf_range(-yrange, yrange), -ymotion, max(ymotion, position.y)), 
			clampf(position.z + randf_range(-xzmotion, xzmotion), -xzrange, xzrange))
		look_at(get_parent().global_transform*target)
		tvec = target - position
		tdist = tvec.length()
	var k = move_and_collide(tvec*(delta*flyvelocity/tdist))
	if k:
		print(k)
		target = null
	$Glow.get_surface_override_material(0).albedo_color = Color.YELLOW * max(0, sin(Time.get_ticks_msec()*0.005))
