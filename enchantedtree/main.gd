extends Node3D

func getcontextmenutexts():
	return [ "togglecandle", "toggleshadow" ]

func _on_radial_menu_menuitemselected(menutext):
	if menutext == "togglecandle":
		$CandleLight.visible = not $CandleLight.visible
	elif menutext == "toggleshadow":
		#$CandleLight.shadow_enabled = not $CandleLight.shadow_enabled
		$WorldEnvironment/DirectionalLight3D.shadow_enabled = not $WorldEnvironment/DirectionalLight3D.shadow_enabled
