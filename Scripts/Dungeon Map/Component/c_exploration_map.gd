extends Node3D
class_name C_Exploration_Map

@export var room_scene: PackedScene

@onready var grid_space: Node3D = $grid_space
@onready var avatar_space: Node3D = $avatar_space

var spacing_x: float = 1.0
var spacing_z: float = 1.0

var full_grid_width: float = 0
var full_grid_height: float = 0

func set_up_values(_spacing_x: float, _spacing_z: float, _full_grid_width: float, _full_grid_height: float):
	spacing_x = _spacing_x
	spacing_z = _spacing_z
	full_grid_width = _full_grid_width
	full_grid_height = _full_grid_height

func add_room(room_position: Vector2i, room_square_list: Array[Vector2i], colour: GlobalVariables.room_colours) -> Array[C_Room_Square]:
	var room_squares: Array[C_Room_Square] = []

	for i in room_square_list.size():
		var room_square_coords = room_square_list[i]
		
		var grid_x = room_position.x + room_square_coords.x
		var grid_y = room_position.y + room_square_coords.y
		
		var room_instance = add_room_square(grid_x, grid_y, colour)
		room_squares.push_back(room_instance)

	return room_squares

func add_room_square(x: int, y: int, colour: GlobalVariables.room_colours) -> C_Room_Square:
	var new_room: C_Room_Square = room_scene.instantiate()
	grid_space.add_child(new_room)
	
	var x_position = x * spacing_x
	var z_position = y * spacing_z
	var grid_offset_x = full_grid_width * 0.5
	var grid_offset_z = full_grid_height * 0.5
	
	new_room.position.x += x_position - grid_offset_x
	new_room.position.z += z_position - grid_offset_z
	
	new_room.c_grid_room.grid_x = x
	new_room.c_grid_room.grid_y = y
	new_room.c_grid_room.grid_z = 0
	
	new_room.room_colour = colour
	
	return new_room
