extends Resource
class_name Map_Data

@export var _room_grid: Array[Array]

var map_grid: Array[Array]

var grid_x = 0
var grid_y = 0

func calculate_room_data() -> void:
	grid_x = _room_grid.size()
	
	var largest_y = 0
	for i in _room_grid.size():
		if largest_y < _room_grid[i].size():
			largest_y = _room_grid[i].size()
	
	grid_y = largest_y
	
	for i in grid_x:
		map_grid.append([])
		for j in grid_y:
			var room_cell_key = _room_grid[i][j]
			map_grid[i].push_back(GlobalVariables.room_colours.keys()[room_cell_key])
