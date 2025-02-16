@tool
extends XRToolsPickable
var holding_hand : XRController3D

func _ready():
	super()


func _on_grabbed(pickable: Variant, by: Variant) -> void:
	holding_hand = by._controller


func _on_dropped(pickable: Variant) -> void:
	holding_hand = null
