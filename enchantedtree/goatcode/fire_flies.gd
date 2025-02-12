extends Node3D

var nmaxfireflies = 10
var fireflyspawnaltitude = 5
var fireflyspawnrad = 1

func _on_timer_timeout():
	if $FlyList.get_child_count() < nmaxfireflies:
		var newfly = load("res://goatcode/fire_fly.tscn").instantiate()
		newfly.position = Vector3(randf_range(-fireflyspawnrad, fireflyspawnrad), fireflyspawnaltitude, randf_range(-fireflyspawnrad, fireflyspawnrad))
		$FlyList.add_child(newfly)
	elif $FlyList.get_child_count() > nmaxfireflies:
		$FlyList.get_child(0).queue_free()

	
