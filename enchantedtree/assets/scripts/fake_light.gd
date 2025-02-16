@tool #allows for updates in the editor
#script icon will be blue when tool is active!

extends MeshInstance3D
#fake light script
#DO NOT DELETE!

var mesh_pos : MeshInstance3D

#maybe get all lights during level load? insert into list?

func _ready() -> void:
	mesh_pos = get_tree().get_first_node_in_group("FakeLight")

func _process(_delta: float) -> void:
	#add to a group?
	#if !self.get_surface_override_material(0) == null:
	self.get_surface_override_material(0).set_shader_parameter("light_pos", mesh_pos.global_position);
	#else:
	#	self.get_active_material(0).set_shader_parameter("light_pos", mesh_pos.global_position);
