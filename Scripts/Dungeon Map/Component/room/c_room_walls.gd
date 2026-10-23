extends Node3D
class_name C_Room_Walls

@onready var north_wall: C_Room_Mesh_Part = $north_wall
@onready var east_wall: C_Room_Mesh_Part = $east_wall
@onready var south_wall: C_Room_Mesh_Part = $south_wall
@onready var west_wall: C_Room_Mesh_Part = $west_wall

func update_materials(new_material: Material, surf_idx: int = 0):
	north_wall.update_material(new_material, surf_idx)
	east_wall.update_material(new_material, surf_idx)
	south_wall.update_material(new_material, surf_idx)
	west_wall.update_material(new_material, surf_idx)