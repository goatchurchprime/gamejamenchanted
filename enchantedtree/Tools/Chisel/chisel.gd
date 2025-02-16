@tool
extends Node3D

@onready var xr_tools_pickable: XRToolsPickable = $XRToolsPickable
@onready var physics_chisel_container: StaticBody3D = $PhysicsChiselContainer
#@onready var tool_collision: CollisionShape3D = $XRToolsPickable/ToolCollision
@onready var _controller : XRController3D = XRHelpers.get_xr_controller(self)

var holding_hand : XRController3D

func _ready():
	#physics_chisel_container.reparent(get_parent().get_parent())
	xr_tools_pickable.global_transform = global_transform

func _physics_process(delta: float) -> void:
	#print(xr_tools_pickable.global_transform.origin.y)
	physics_chisel_container.global_transform = xr_tools_pickable.global_transform

func _on_xr_tools_pickable_grabbed(pickable: Variant, by: Variant) -> void:
	holding_hand = by._controller
	

func _on_xr_tools_pickable_dropped(pickable: Variant) -> void:
	holding_hand = null
