extends Node3D

func getcontextmenutexts():
	return [ "togglecandle", "toggleshadow" ]

func _on_radial_menu_menuitemselected(menutext):
	if menutext == "togglecandle":
		$CandleLightIgloo.visible = not $CandleLightIgloo.visible
		$CandleLightConetree.visible = not $CandleLightConetree.visible
	elif menutext == "toggleshadow":
		#$CandleLight.shadow_enabled = not $CandleLight.shadow_enabled
		$WorldEnvironment/DirectionalLight3D.shadow_enabled = not $WorldEnvironment/DirectionalLight3D.shadow_enabled

func _process(delta):
	$CandleLightConetree.light_energy = clamp($CandleLightConetree.light_energy + randf_range(-4,4)*delta, 1, 3)
