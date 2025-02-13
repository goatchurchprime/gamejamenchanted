extends Node3D

func _ready() -> void:
	$XROrigin3D/XRAim3D/RadialMenu.connect("menuitemselected", radialmenuitem)

func getcontextmenutexts():
	return [ "togglecandle", "toggleshadow", 
			 "intotree", "spawnpt", "togglebloom", 
			"cock1" ]

var Ddebugmode = false

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
	elif menutext == "cock1":
		cock1shadow()
	else:
		printerr("Unknown menu item ", menutext)
		
func set_fade(p_value : float):
	XRToolsFade.set_fade("teleport", Color(0.03, 0.03, 0.1, p_value))

func getyouintothetree():
	$XROrigin3D/XRControllerLeft/XRToolsCollisionHand/HandLight.visible = false
	$XROrigin3D/XRControllerRight/XRToolsCollisionHand/HandLight.visible = false
	var tween = get_tree().create_tween()
	var fadeto = 0.7
	tween.tween_method(set_fade, 0.0, fadeto, 0.3)
	await tween.finished
	tween.kill()
	var treecentretrans = find_child("PosIntoTree").global_transform
	
	# rapid drawing into the tree
	if Ddebugmode:
		$XROrigin3D/PlayerBody.teleport(treecentretrans)
	else:
		var ao = $XROrigin3D/PlayerBody.global_transform.origin + Vector3(0,0.5,0)
		var bgravity = $XROrigin3D/PlayerBody.gravity
		$XROrigin3D/MovementFlight.enabled = true
		$XROrigin3D/MovementDesktopFlight.enabled = true
		$XROrigin3D/MovementGravityZones.enabled = true
		for i in range(11):
			$XROrigin3D/PlayerBody.teleport(Transform3D(treecentretrans.basis, lerp(ao, treecentretrans.origin, i/10.0)))
			$XROrigin3D/XRControllerLeft.trigger_haptic_pulse(&"haptic",0,i/10.0,0.09,0)
			$XROrigin3D/XRControllerRight.trigger_haptic_pulse(&"haptic",0,i/10.0,0.09,0)
			$XROrigin3D/TeleportToTreesound.play()
			await get_tree().create_timer(0.2).timeout
		$XROrigin3D/MovementGravityZones.enabled = false
		$XROrigin3D/MovementFlight.enabled = false
		$XROrigin3D/MovementDesktopFlight.enabled = false

	$FireFlies.position = treecentretrans.origin
	$FireFlies.global_position.y = $XROrigin3D/XRCamera3D.global_position.y - 0.3
	$FireFlies.nmaxfireflies = 10
	for f in $FireFlies/FlyList.get_children():
		f.queue_free()
	$WorldEnvironment/DirectionalLight3D.visible = false
	$WorldEnvironment.environment.background_energy_multiplier = 0.09
	tween = get_tree().create_tween()
	tween.tween_method(set_fade, fadeto, 0.0, 1.0)
	await tween.finished

func getyoutothespawnpoint():
	$XROrigin3D/PlayerBody.teleport(find_child("PosSpawnPoint").global_transform)
	$WorldEnvironment/DirectionalLight3D.visible = true
	$WorldEnvironment.environment.background_energy_multiplier = 1.0
	var tween = get_tree().create_tween()
	tween.tween_method(set_fade, 1.0, 0.0, 1.0)
	await tween.finished
	$XROrigin3D/XRControllerLeft/XRToolsCollisionHand/HandLight.visible = false
	$XROrigin3D/XRControllerRight/XRToolsCollisionHand/HandLight.visible = false

func cock1shadow():
	for i in range(5):
		$SpotLightIntoTree.light_projector = null
		await get_tree().create_timer(0.5).timeout
		$SpotLightIntoTree.light_projector = load("res://images/cockshadow2.tres")
		await get_tree().create_timer(0.5).timeout
		$SpotLightIntoTree.light_projector = load("res://images/cockshadow1.tres")
		await get_tree().create_timer(0.5).timeout
	
		

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
		
