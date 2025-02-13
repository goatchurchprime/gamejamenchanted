extends RigidBody3D


var target = null
@export var flyvelocity = 1.2
var xzrange = 3.0
var yrange = 0.5
var xzmotion = 0.9
var ymotion = 0.2
var xzcollapse = 0.9

@onready var flashphase = randf_range(0, 999)
@onready var flashfac = randf_range(0.002, 0.006)
@onready var flashoffs = randf_range(-0.2, 0.8) + 0.0
@onready var flyvecfac = randf_range(0.5, 1.2)*0.5

func _ready():
	$firefly/firefly/AnimationPlayer.play("firefly_fly")

var rec_physdelta = 0.001
func _physics_process(delta):
	rec_physdelta = delta
	var tvec = target - position if target != null else Vector3.ZERO
	var tdist = tvec.length()
	if tdist < 0.05:
		target = Vector3(
			clampf(position.x + randf_range(-xzmotion, xzmotion), -xzrange, xzrange), 
			clampf(position.y + randf_range(-yrange, yrange), -ymotion, max(ymotion, position.y)), 
			clampf(position.z + randf_range(-xzmotion, xzmotion), -xzrange, xzrange))
		target = target*xzcollapse
		look_at(get_parent().global_transform*target)
		tvec = target - position
		tdist = tvec.length()
		
	var gtvec = get_parent().global_transform*tvec
	var tvf = delta*flyvelocity*flyvecfac/tdist
	var k = move_and_collide(tvec*tvf)
	if k:
		target = null
	var ft = Time.get_ticks_msec()*flashfac + flashphase
	var fg = sin(ft) + flashoffs
	$Glow.get_surface_override_material(0).albedo_color = Color.YELLOW * clamp(fg, 0, 1)
	$firefly/firefly/Firefly.get_surface_override_material(1).albedo_color = Color.YELLOW * clamp(fg, 0, 1)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is XRToolsCollisionHand:
		var palmvec = body.global_transform.basis.x
		if body.get_parent().tracker == "left_hand":
			palmvec = -palmvec
		var closingphvelocity = linear_velocity - body._last_movement/rec_physdelta
		var swatvelocity = palmvec.dot(closingphvelocity)
		#prints(swatvelocity, "gg ", body._last_movement/rec_physdelta, linear_velocity)
		var handlight = body.get_node_or_null("HandLight")
		if handlight:
			body.get_parent().trigger_haptic_pulse(&"haptic",0,min(1.0,abs(swatvelocity)*100),0.06,0)
			if swatvelocity < -0.3:
				get_parent().get_parent().sethandlighton(handlight)
				queue_free()
			elif swatvelocity > 0.2:
				flyvecfac = 0.2
