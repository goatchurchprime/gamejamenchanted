extends Node3D

func _ready() -> void:
	$XROrigin3D/XRAim3D/RadialMenu.connect("menuitemselected", _on_radial_menu_menuitemselected)

func getcontextmenutexts():
	return [ "togglecandle", "toggleshadow", 
			 "intotree" ]

func _on_radial_menu_menuitemselected(menutext):
	if menutext == "togglecandle":
		$CandleLightIgloo.visible = not $CandleLightIgloo.visible
		$CandleLightConetree.visible = not $CandleLightConetree.visible
	elif menutext == "toggleshadow":
		#$CandleLight.shadow_enabled = not $CandleLight.shadow_enabled
		$WorldEnvironment/DirectionalLight3D.shadow_enabled = not $WorldEnvironment/DirectionalLight3D.shadow_enabled
	#elif menutext == "intotree":
		


func _process(delta):
	$CandleLightConetree.light_energy = clamp($CandleLightConetree.light_energy + randf_range(-4,4)*delta, 1, 3)
