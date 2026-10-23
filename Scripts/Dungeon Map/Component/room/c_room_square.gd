extends Node3D
class_name C_Room_Square

@export var room_colour: GlobalVariables.room_colours = GlobalVariables.room_colours.NULL:
	set(value):
		room_colour = value
		c_grid_room.room_colour = value
		
		change_room_meshes_colour()

@onready var room_floor: C_Room_Mesh_Part = $floor

@onready var walls: C_Room_Walls = $floor/walls
@onready var doors: C_Room_Doors = $floor/doors

@onready var c_grid_room: C_Grid_Room = $C_Grid_Room

var matching_neighbours: Array[C_Grid_Room] = []

var square_id = -1
var room_id = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	c_grid_room.room_colour = room_colour
	
	change_room_meshes_colour()

func change_room_meshes_colour():
	var colour_material = GlobalVariables.room_textures.get(room_colour)

	room_floor.update_material(colour_material, 0)
	walls.update_materials(colour_material, 0)
	doors.update_materials(colour_material, 0)

func calculate_room_walls():
	calculate_room_wall(c_grid_room.north_cell, walls.north_wall)
	calculate_room_wall(c_grid_room.south_cell, walls.south_wall)
	calculate_room_wall(c_grid_room.east_cell, walls.east_wall)
	calculate_room_wall(c_grid_room.west_cell, walls.west_wall)

	get_tree().call_group("Exploration_Scene", "register_room_square", self, matching_neighbours)

func calculate_room_wall(cell: C_Grid_Room, wall: MeshInstance3D):
	if cell and cell.room_colour == room_colour:
		wall.visible = false
		matching_neighbours.push_back(cell)
	else:
		wall.visible = true

func get_grid_x() -> int:
	return c_grid_room.grid_x

func get_grid_y() -> int:
	return c_grid_room.grid_y

func get_grid_z() -> int:
	return c_grid_room.grid_z

func get_grid_xy() -> Vector2i:
	return Vector2i(get_grid_x(), get_grid_y())