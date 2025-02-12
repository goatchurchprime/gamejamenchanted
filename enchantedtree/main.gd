extends Node3D

func _ready() -> void:
	$XROrigin3D/XRAim3D/RadialMenu.connect("menuitemselected", radialmenuitem)

func getcontextmenutexts():
	return [ "togglecandle", "toggleshadow", 
			 "intotree", "spawnpt", "togglebloom" ]

func radialmenuitem(menutext):
	if menutext == "togglecandle":
		$CandleLightConetree.visible = not $CandleLightConetree.visible
	elif menutext == "toggleshadow":
		#$CandleLight.shadow_enabled = not $CandleLight.shadow_enabled
		$WorldEnvironment/DirectionalLight3D.shadow_enabled = not $WorldEnvironment/DirectionalLight3D.shadow_enabled
	elif menutext == "togglebloom":
		$WorldEnvironment.environment.glow_enabled = not $WorldEnvironment.environment.glow_enabled
	elif menutext == "intotree":
		getyouintothetree()
	elif menutext == "spawnpt":
		getyoutothespawnpoint()
	else:
		printerr("Unknown menu item ", menutext)
		
func set_fade(p_value : float):
	XRToolsFade.set_fade("teleport", Color(0.03, 0.03, 0.1, p_value))

func getyouintothetree():
	var tween = get_tree().create_tween()
	tween.tween_method(set_fade, 0.0, 1.0, 0.3)
	await tween.finished
	tween.kill()

	$XROrigin3D/PlayerBody.teleport(find_child("PosIntoTree").global_transform)
	$WorldEnvironment/DirectionalLight3D.visible = false
	$WorldEnvironment.environment.background_energy_multiplier = 0.09
	tween = get_tree().create_tween()
	tween.tween_method(set_fade, 1.0, 0.0, 1.0)
	await tween.finished

func getyoutothespawnpoint():
	$XROrigin3D/PlayerBody.teleport(find_child("PosSpawnPoint").global_transform)
	$WorldEnvironment/DirectionalLight3D.visible = true
	$WorldEnvironment.environment.background_energy_multiplier = 1.0
	var tween = get_tree().create_tween()
	tween.tween_method(set_fade, 1.0, 0.0, 1.0)
	await tween.finished

func _process(delta):
	$CandleLightConetree.light_energy = clamp($CandleLightConetree.light_energy + randf_range(-14,14)*delta, 1, 3)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_T:
			radialmenuitem("intotree")
		if event.keycode == KEY_P:
			radialmenuitem("spawnpt")
		if event.keycode == KEY_C:
			radialmenuitem("togglecandle")
		if event.keycode == KEY_B:
			radialmenuitem("togglebloom")
		
