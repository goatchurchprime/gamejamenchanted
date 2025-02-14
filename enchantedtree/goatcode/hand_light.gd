extends OmniLight3D

@onready var slightenergy = light_energy
func setlightenergy(lslightenergy):
	slightenergy = lslightenergy
	light_energy = slightenergy
	var controller = get_parent().get_parent()
	var grip_value = controller.get_float("grip")
	visible = (slightenergy != 0) and (grip_value < 0.5)

	
	
