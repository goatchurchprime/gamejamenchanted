@tool #allows for updates in the editor
#script icon will be blue when tool is active!

extends CSGShape3D
#fake light script
#DO NOT DELETE!

@export var mesh_pos : MeshInstance3D

#maybe get all lights during level load? insert into list?

#func _ready() -> void:
	#
	#for x in self.get_surface_override_material_count():
		#
		#self.get_active_material(x).set_shader_parameter("light_pos", light_pos.global_position);
		

func _process(_delta: float) -> void:
	#add to a group?
	
	self.material.set_shader_parameter("light_pos", mesh_pos.global_position);
		
