extends Node3D
class_name C_Room_Doors

@onready var north_door: Node3D = $north_door
@onready var east_door: Node3D = $east_door
@onready var south_door: Node3D = $south_door
@onready var west_door: Node3D = $west_door

@onready var north_door_1: MeshInstance3D = $north_door/north_door_1
@onready var north_door_2: MeshInstance3D = $north_door/north_door_2
@onready var south_door_1: MeshInstance3D = $south_door/south_door_1
@onready var south_door_2: MeshInstance3D = $south_door/south_door_2
@onready var west_door_1: MeshInstance3D = $west_door/west_door_1
@onready var west_door_2: MeshInstance3D = $west_door/west_door_2
@onready var east_door_1: MeshInstance3D = $east_door/east_door_1
@onready var east_door_2: MeshInstance3D = $east_door/east_door_2

func update_materials(new_material: Material, surf_idx: int = 0):
	north_door_1.update_material(new_material, surf_idx)
	north_door_2.update_material(new_material, surf_idx)
	south_door_1.update_material(new_material, surf_idx)
	south_door_2.update_material(new_material, surf_idx)
	west_door_1.update_material(new_material, surf_idx)
	west_door_2.update_material(new_material, surf_idx)
	east_door_1.update_material(new_material, surf_idx)
	east_door_2.update_material(new_material, surf_idx)