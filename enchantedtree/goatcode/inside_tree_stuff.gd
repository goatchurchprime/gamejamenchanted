extends Node3D

@onready var orgchiseltrans = $Chisel/XRToolsPickable.transform
@onready var orghammertrans = $Hammer.transform

var nextframerespawntools = false
func _physics_process(delta):
	if (nextframerespawntools or ($Chisel/XRToolsPickable.transform.origin - orgchiseltrans.origin).length() > 5) and not $Chisel/XRToolsPickable.is_picked_up():
		print("Chisel out of range, moving it back")
		$Chisel/XRToolsPickable.transform.origin = orgchiseltrans.origin
		$Chisel/XRToolsPickable.linear_velocity = Vector3.ZERO
		$Chisel/XRToolsPickable.angular_velocity = Vector3.ZERO
	if (nextframerespawntools or ($Hammer.transform.origin - orghammertrans.origin).length() > 5.0) and not $Hammer.is_picked_up():
		print("Hammer out of range, moving it back")
		$Hammer.transform.origin = orghammertrans.origin
		$Hammer.linear_velocity = Vector3.ZERO
	nextframerespawntools = false

	
