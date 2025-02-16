extends Node3D

func _ready() -> void:
	$XROrigin3D/XRAim3D/RadialMenu.connect("menuitemselected", radialmenuitem)

func getcontextmenutexts():
	return [ "togglecandle", "toggleshadow", 
			 "intotree", "spawnpt", "respawntools", 
			 "cock1", "cock2" ]

var Ddebugmode = true

func radialmenuitem(menutext):
	if menutext == "togglecandle":
		$InsideTreeStuff/CandleLightConetree.visible = not $InsideTreeStuff/CandleLightConetree.visible
	elif menutext == "toggleshadow":
		#$CandleLight.shadow_enabled = not $CandleLight.shadow_enabled
		var vv = $WorldEnvironment/DirectionalLight3D.shadow_enabled
		$WorldEnvironment/DirectionalLight3D.shadow_enabled = not vv
		$SpotLightIntoTree.visible = vv

	elif menutext == "togglebloom":
		$WorldEnvDdebugmodeironment.environment.glow_enabled = not $WorldEnvironment.environment.glow_enabled
	elif menutext == "intotree":
		getyouintotree()
	elif menutext == "spawnpt":
		getyoutothespawnpoint()
	elif menutext == "cock1":
		cock1shadow()
	elif menutext == "cock2":
		cock2attack()
	elif menutext == "respawntools":
		$InsideTreeStuff.nextframerespawntools = true
	else:
		printerr("Unknown menu item ", menutext)
		
func set_fade(p_value : float):
	XRToolsFade.set_fade("teleport", Color(0.03, 0.03, 0.1, p_value))

func getyouintotree():
	$XROrigin3D/XRControllerLeft/XRToolsCollisionHand/HandLight.visible = false
	$XROrigin3D/XRControllerRight/XRToolsCollisionHand/HandLight.visible = false
	$XROrigin3D/XRControllerLeft/MovementDirect.max_speed = 0.3
	var tween = get_tree().create_tween()
	var fadeto = 0.7
	tween.tween_method(set_fade, 0.0, fadeto, 0.3)
	await tween.finished
	tween.kill()
	var treecentretrans = find_child("PosIntoTree").global_transform

	for f in $FireFlies/FlyList.get_children():
		f.queue_free()
	
	# rapid pulling us into the tree
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

			if i == 9:
				$WorldEnvironment/DirectionalLight3D.visible = false
				$WorldEnvironment.environment.background_energy_multiplier = 0.09

		$XROrigin3D/MovementGravityZones.enabled = false
		$XROrigin3D/MovementFlight.enabled = false
		$XROrigin3D/MovementDesktopFlight.enabled = false

	$WorldEnvironment/DirectionalLight3D.visible = false
	$WorldEnvironment.environment.background_energy_multiplier = 0.09 if Ddebugmode else 0.001
	tween = get_tree().create_tween()
	tween.tween_method(set_fade, fadeto, 0.0, 1.0)
	await tween.finished

	$InsideTreeStuff/TreeDoorCover.visible = true
	$InsideTreeStuff/TreeDoorCover.use_collision = true
	$InsideTreeStuff/TreeHollowShadow.visible = false

	$FireFlies.position = treecentretrans.origin
	print("gg ", $XROrigin3D/XRCamera3D.global_position.y)
	$FireFlies.global_position.y = $XROrigin3D/XRCamera3D.global_position.y - 0.3
	$FireFlies.nmaxfireflies = 10
	$FireFlies.fireflyspawnaltitude = 1.5 if Ddebugmode else 3.0


func getyoutothespawnpoint():
	$Cockatrice.visible = false
	$World/Enviroment/Terrain/EnchantedTreeSPLIT.visible = true
	Ddebugmode = false
	$XROrigin3D/PlayerBody.teleport(find_child("PosSpawnPoint").global_transform)
	$WorldEnvironment/DirectionalLight3D.visible = true
	$WorldEnvironment.environment.background_energy_multiplier = 1.0
	for f in $FireFlies/FlyList.get_children():
		f.queue_free()
	var tween = get_tree().create_tween()
	tween.tween_method(set_fade, 1.0, 0.0, 1.0)
	await tween.finished
	$XROrigin3D/XRControllerLeft/XRToolsCollisionHand/HandLight.visible = false
	$XROrigin3D/XRControllerRight/XRToolsCollisionHand/HandLight.visible = false
	$XROrigin3D/XRControllerLeft/MovementDirect.max_speed = 3.0
	$InsideTreeStuff/TreeHollowShadow.visible = true
	$InsideTreeStuff/TreeDoorCover.visible = false
	$InsideTreeStuff/TreeDoorCover.use_collision = false
	$World/TweetingBirdsong.play()
	

func cock1shadow():
	for i in range(5):
		$SpotLightIntoTree.light_projector = null
		await get_tree().create_timer(0.5).timeout
		$SpotLightIntoTree.light_projector = load("res://images/cockshadow2.tres")
		await get_tree().create_timer(0.5).timeout
		$SpotLightIntoTree.light_projector = load("res://images/cockshadow1.tres")
		await get_tree().create_timer(0.5).timeout
	
func cock2attack():
	$Cockatrice.visible = true
	$Cockatrice/AnimationPlayer.play("move1")
	$InsideTreeStuff/TreeDoorCover.visible = false
	$Cockatrice/AudioStreamPlayerScream.play()
	await get_tree().create_timer(2.0).timeout
	$World/Enviroment/Terrain/EnchantedTreeSPLIT.visible = false
	for s in [0.8, 0.6, 0.7, 0.5, 1.1]:
		await get_tree().create_timer(s).timeout
		$Cockatrice/AudioStreamPlayerCrunch.play()
	await get_tree().create_timer(0.8).timeout
	$World/Enviroment/Terrain/EnchantedTreeSPLIT.visible = true
	$InsideTreeStuff/TreeDoorCover.visible = true
	$Cockatrice.visible = false
	$Cockatrice/AnimationPlayer.stop()
	

var candlelightlow = 0
var candlelighthi = 0
#candlelightlow = 1
#candlelighthi = 3

func _process(delta):
	$InsideTreeStuff/CandleLightConetree.light_energy = clamp($InsideTreeStuff/CandleLightConetree.light_energy + randf_range(-14,14)*delta, candlelightlow, candlelighthi)

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
		if event.keycode == KEY_K:
			radialmenuitem("cock2")
		

func _on_tree_approach_area_body_entered(body):
	print(body)
	if body.name == "PlayerBody":
		$World/TweetingBirdsong.stop()
		$InsideTreeStuff/TreeApproachArea/VultureSound.play()
		if not Ddebugmode:
			await get_tree().create_timer(1.5).timeout
			getyouintotree()

func _on_candlestick_activation_body_entered(body):
	print("candlestick_activation_body_entered ", body)
	if body.get_parent().name == "FlyList":
		if body.flytouches != 0:
			body.queue_free()
			$FireFlies.nmaxfireflies -= 1
			$InsideTreeStuff/CandleLightConetree.visible = true
			candlelighthi = min(3, candlelighthi + 0.3)
			candlelightlow = candlelighthi/3
			$InsideTreeStuff/CandlestickActivation/AudioStreamPlayer3D.play()
			$WorldEnvironment.environment.background_energy_multiplier = 0.09
