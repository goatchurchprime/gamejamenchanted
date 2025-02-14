extends Node3D

var nmaxfireflies = 0
var fireflyspawnaltitude = 1.5
var fireflyspawnrad = 1
var fireflyxzrange = 1.3

var Ddevmode = true
func _ready():
	if Ddevmode:
		nmaxfireflies = 10
		for i in range(nmaxfireflies - $FlyList.get_child_count()):
			var newfly = load("res://goatcode/fire_fly.tscn").instantiate()
			newfly.position = Vector3(i*0.2-1,-0.3,0)
			newfly.flyvelocity = 0.02
			$FlyList.add_child(newfly)
			
func _on_timer_timeout():
	if $FlyList.get_child_count() < nmaxfireflies:
		var newfly = load("res://goatcode/fire_fly.tscn").instantiate()
		newfly.position = Vector3(randf_range(-fireflyspawnrad, fireflyspawnrad), fireflyspawnaltitude, randf_range(-fireflyspawnrad, fireflyspawnrad))
		newfly.xzrange = fireflyxzrange
		$FlyList.add_child(newfly)
	elif $FlyList.get_child_count() > nmaxfireflies:
		$FlyList.get_child(0).queue_free()

var activehandlighttweens = { }
func sethandlightoff(handlight):
	handlight.visible = false
	activehandlighttweens.erase(handlight)

func sethandlighton(handlight):
	if activehandlighttweens.has(handlight):
		activehandlighttweens[handlight].kill()
		activehandlighttweens.erase(handlight)
	$BugSquelch.position = handlight.global_position
	$BugSquelch.play()
	var tween = get_tree().create_tween()
	#handlight.visible = true
	tween.tween_method(handlight.setlightenergy, handlight.slightenergy, 3.0, 0.2)
	tween.tween_method(handlight.setlightenergy, handlight.slightenergy, 0.0, randf_range(4, 15))
	tween.tween_callback(sethandlightoff.bind(handlight))
	activehandlighttweens[handlight] = tween
	
