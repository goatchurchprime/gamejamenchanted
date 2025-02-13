extends RigidBody3D


var target = null
@export var flyvelocity = 1.2
var xzrange = 3.0
var yrange = 0.5
var xzmotion = 0.9
var ymotion = 0.2
@onready var flashphase = randf_range(0, 999)
@onready var flashfac = randf_range(0.002, 0.006)
@onready var flashoffs = randf_range(-0.2, 0.8) + 0.0
@onready var flyvecfac = randf_range(0.5, 1.2)*0.5

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
	var k = move_and_collide(tvec*(delta*flyvelocity*flyvecfac/tdist))
	if k:
		target = null
	var ft = Time.get_ticks_msec()*flashfac + flashphase
	var fg = sin(ft) + flashoffs
	$Glow.get_surface_override_material(0).albedo_color = Color.YELLOW * clamp(fg, 0, 1)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is XRToolsCollisionHand:
		var palmvec = body.global_transform.basis.x
		if body.get_parent().tracker == "left_hand":
			palmvec = -palmvec
		var swatvelocity = palmvec.dot(body._last_movement - linear_velocity)
		if swatvelocity > 0.1:
			var handlight = body.get_node_or_null("HandLight")
			if handlight:
				get_parent().get_parent().sethandlighton(handlight)
			queue_free()
