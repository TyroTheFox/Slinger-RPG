extends Node3D
class_name C_Room_Door_Node

@onready var door_1: C_Room_Mesh_Part = $door_1
@onready var door_2: C_Room_Mesh_Part = $door_2

func update_materials(new_material: Material, surf_idx: int = 0):
	door_1.update_material(new_material, surf_idx)
	door_2.update_material(new_material, surf_idx)