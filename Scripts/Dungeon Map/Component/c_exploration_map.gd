extends Node3D
class_name C_Exploration_Map

var room_scene = preload("uid://d3phn7lggeyed")

@export var map_data_resource: Map_Data
@export var spacing_x: float = 1.0
@export var spacing_z: float = 1.0

@onready var grid_space: Node3D = $grid_space

var _room_grid: Array[Array]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_data_resource.calculate_room_data()
	var room_map = map_data_resource.map_grid
	
	for i in room_map.size():
		_room_grid.append([])
		for j in room_map[i].size():
			if room_map[i][j] == GlobalVariables.room_colours.keys()[0]:
				_room_grid[i].push_back(null)
			else:
				var room_colour = Global_Variables.room_colours.get(room_map[i][j])
				var room_instance = add_room(i, j, room_colour)
				_room_grid[i].push_back(room_instance)
	
	var max_x = _room_grid.size()
	
	for x in max_x:
		var max_y = _room_grid[x].size()
		for y in max_y:
			var north_cell: C_Grid_Room = null
			var east_cell: C_Grid_Room = null
			var south_cell: C_Grid_Room = null
			var west_cell: C_Grid_Room = null
			
			var north_coord = y - 1
			var east_coord = x + 1
			var south_coord = y + 1
			var west_coord = x - 1
			
			var current_room_instance: C_Room_Square = _room_grid[x][y]
			
			if not current_room_instance:
				continue
			
			var current_room_data_component: C_Grid_Room = current_room_instance.c_grid_room
			
			# North
			if north_coord >= 0 and _room_grid[x][north_coord]:
				north_cell = _room_grid[x][north_coord].c_grid_room
			
			# South
			if south_coord < max_y and _room_grid[x][south_coord]:
				south_cell = _room_grid[x][south_coord].c_grid_room
			
			# East
			if east_coord < max_x and _room_grid[east_coord][y]:
				east_cell = _room_grid[east_coord][y].c_grid_room
			
			# West
			if west_coord >= 0 and _room_grid[west_coord][y]:
				west_cell = _room_grid[west_coord][y].c_grid_room
			
			current_room_data_component.north_cell = north_cell
			current_room_data_component.east_cell = east_cell
			current_room_data_component.south_cell = south_cell
			current_room_data_component.west_cell = west_cell
			
			current_room_instance.calculate_room_walls()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_room(x: int, y: int, colour: GlobalVariables.room_colours) -> C_Room_Square:
	var new_room: C_Room_Square = room_scene.instantiate()
	grid_space.add_child(new_room)
	new_room.position.x += x * spacing_x
	new_room.position.z += y * spacing_z
	
	new_room.c_grid_room.grid_x = x
	new_room.c_grid_room.grid_y = y
	new_room.c_grid_room.grid_z = 0
	
	new_room.room_colour = colour
	
	return new_room
