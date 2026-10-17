extends Node3D
class_name C_Exploration_Map

var room_scene = preload("uid://d3phn7lggeyed")

@export var map_data_resource: Map_Data
@export var spacing_x: float = 1.0
@export var spacing_z: float = 1.0

@onready var grid_space: Node3D = $grid_space

var _room_grid: Array[Array]

var full_grid_width = 0
var full_grid_height = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_data_resource.calculate_room_data()
	var room_map = map_data_resource.map_grid
	
	full_grid_width = room_map.size() * spacing_x
	full_grid_height = room_map[0].size() * spacing_z
	
	for i in room_map.size():
		_room_grid.append([])
		for j in room_map[i].size():
			if room_map[i][j] == GlobalVariables.room_colours.keys()[0]:
				_room_grid[i].push_back(null)
			else:
				var room_colour = Global_Variables.room_colours.get(room_map[i][j])
				var room_instance = add_room_square(i, j, room_colour)
				_room_grid[i].push_back(room_instance)
	
	var max_x = _room_grid.size()
	
	for grid_x in max_x:
		var max_y = _room_grid[grid_x].size()
		for grid_y in max_y:
			var current_room_instance: C_Room_Square = _room_grid[grid_x][grid_y]
			
			if current_room_instance:
				process_room_adjacency_checks(current_room_instance, grid_x, grid_y, max_x, max_y)
	
	for grid_x in max_x:
		var max_y = _room_grid[grid_x].size()
		for grid_y in max_y:
			var current_room_instance: C_Room_Square = _room_grid[grid_x][grid_y]
			
			if current_room_instance:
				current_room_instance.calculate_room_walls()

func add_room(room_position: Vector2i, room_square_list: Array[Vector2i], colour: GlobalVariables.room_colours):
	for i in room_square_list.size():
		var room_square_coords = room_square_list[i]
		
		var grid_x = room_position.x + room_square_coords.x
		var grid_y = room_position.y + room_square_coords.y
		
		var room_instance = add_room_square(grid_x, grid_y, colour)
		_room_grid[grid_x][grid_y] = room_instance
	
	var max_x = _room_grid.size()
	
	for grid_x in max_x:
		var max_y = _room_grid[grid_x].size()
		for grid_y in max_y:
			var current_room_instance: C_Room_Square = _room_grid[grid_x][grid_y]
			
			if current_room_instance:
				process_room_adjacency_checks(current_room_instance, grid_x, grid_y, max_x, max_y)
	
	for grid_x in max_x:
		var max_y = _room_grid[grid_x].size()
		for grid_y in max_y:
			var current_room_instance: C_Room_Square = _room_grid[grid_x][grid_y]
			
			if current_room_instance:
				current_room_instance.calculate_room_walls()

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

func process_room_adjacency_checks(current_room_instance: C_Room_Square, grid_x: int, grid_y: int, max_x: int, max_y: int):
	var north_cell: C_Grid_Room = null
	var east_cell: C_Grid_Room = null
	var south_cell: C_Grid_Room = null
	var west_cell: C_Grid_Room = null
	
	var north_coord = grid_y - 1
	var east_coord = grid_x + 1
	var south_coord = grid_y + 1
	var west_coord = grid_x - 1
	
	var current_room_data_component: C_Grid_Room = current_room_instance.c_grid_room
	
	# North
	if north_coord >= 0 and _room_grid[grid_x][north_coord]:
		north_cell = _room_grid[grid_x][north_coord].c_grid_room
	
	# South
	if south_coord < max_y and _room_grid[grid_x][south_coord]:
		south_cell = _room_grid[grid_x][south_coord].c_grid_room
	
	# East
	if east_coord < max_x and _room_grid[east_coord][grid_y]:
		east_cell = _room_grid[east_coord][grid_y].c_grid_room
	
	# West
	if west_coord >= 0 and _room_grid[west_coord][grid_y]:
		west_cell = _room_grid[west_coord][grid_y].c_grid_room
	
	current_room_data_component.north_cell = north_cell
	current_room_data_component.east_cell = east_cell
	current_room_data_component.south_cell = south_cell
	current_room_data_component.west_cell = west_cell