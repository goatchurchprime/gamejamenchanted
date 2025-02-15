extends Node3D

@onready var orgchiseltrans = $Chisel/XRToolsPickable.transform
@onready var orghammertrans = $Hammer.transform

func _process(delta):
	if ($Chisel/XRToolsPickable.transform.origin - orgchiseltrans.origin).length() > 5 and not $Chisel/XRToolsPickable.is_picked_up():
		print("Chisel out of range, moving it back")
		$Chisel/XRToolsPickable.transform.origin = orgchiseltrans.origin
		$Chisel/XRToolsPickable.linear_velocity = Vector3.ZERO
	if ($Hammer.transform.origin - orghammertrans.origin).length() > 5.0 and not $Hammer.is_picked_up():
		print("Hammer out of range, moving it back")
		$Hammer.transform.origin = orghammertrans.origin
		$Hammer.linear_velocity = Vector3.ZERO
