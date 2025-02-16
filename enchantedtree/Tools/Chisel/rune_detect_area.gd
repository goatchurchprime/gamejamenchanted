extends Area3D

var not_in_body_closest_distance := 10000.0

func _physics_process(delta: float) -> void:
	var closest_distance := not_in_body_closest_distance
	for overlapped_body in get_overlapping_bodies():
		if !overlapped_body.is_class("StaticBody3D"):
			continue
		if overlapped_body.is_in_group("rune_point"):
			var distance := global_position.distance_to(overlapped_body.global_position)
			if distance < closest_distance:
				closest_distance = distance
	
	if XRServer and closest_distance != not_in_body_closest_distance:
		if !owner.holding_hand:
			return
		var active_hand = owner.holding_hand.tracker
		var trigger_name = ""
		if active_hand == "left_hand":
			trigger_name = "haptic_left"
		if active_hand == "right_hand":
			trigger_name = "haptic_right"
		XRServer.primary_interface.trigger_haptic_pulse(
			trigger_name,
			active_hand,
			inverse_lerp(1.0, 0.0, closest_distance * 5),
			inverse_lerp(1.0, 0.0, closest_distance * 5),
			0.1,
			0.0
		)
	
