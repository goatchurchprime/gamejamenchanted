extends Node3D

func _ready() -> void:
	$XROrigin3D/XRAim3D/RadialMenu.connect("menuitemselected", _on_radial_menu_menuitemselected)

func getcontextmenutexts():
	return [ "togglecandle", "toggleshadow", 
			 "intotree", "spawnpt" ]

func _on_radial_menu_menuitemselected(menutext):
	if menutext == "togglecandle":
		$CandleLightIgloo.visible = not $CandleLightIgloo.visible
		$CandleLightConetree.visible = not $CandleLightConetree.visible
	elif menutext == "toggleshadow":
		#$CandleLight.shadow_enabled = not $CandleLight.shadow_enabled
		$WorldEnvironment/DirectionalLight3D.shadow_enabled = not $WorldEnvironment/DirectionalLight3D.shadow_enabled
	elif menutext == "intotree":
		getyouintothetree()
	elif menutext == "spawnpt":
		getyoutothespawnpoint()
		
		
func set_fade(p_value : float):
	XRToolsFade.set_fade("teleport", Color(0.03, 0.03, 0.1, p_value))

func getyouintothetree():
	var tween = get_tree().create_tween()
	tween.tween_method(set_fade, 0.0, 1.0, 0.3)
	await tween.finished
	tween.kill()
	tween = get_tree().create_tween()
	$XROrigin3D/PlayerBody.teleport(find_child("PosIntoTree").global_transform)
	tween.tween_method(set_fade, 1.0, 0.0, 1.0)
	await tween.finished

func getyoutothespawnpoint():
	var tween = get_tree().create_tween()
	$XROrigin3D/PlayerBody.teleport(find_child("PosSpawnPoint").global_transform)
	tween.tween_method(set_fade, 1.0, 0.0, 1.0)
	await tween.finished


func _process(delta):
	$CandleLightConetree.light_energy = clamp($CandleLightConetree.light_energy + randf_range(-4,4)*delta, 1, 3)
