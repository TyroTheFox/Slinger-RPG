extends Node3D
class_name C_Room_Doors

@onready var north_door: C_Room_Door_Node = $north_door
@onready var east_door: C_Room_Door_Node = $east_door
@onready var south_door: C_Room_Door_Node = $south_door
@onready var west_door: C_Room_Door_Node = $west_door

func update_materials(new_material: Material, surf_idx: int = 0):
	north_door.update_materials(new_material, surf_idx)
	east_door.update_materials(new_material, surf_idx)
	south_door.update_materials(new_material, surf_idx)
	west_door.update_materials(new_material, surf_idx)