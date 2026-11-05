extends Node
class_name C_Dungeon_Squares

var dungeon_map_component: C_Dungeon_Map = null

var square_list: Array[C_Room_Square] = []
var square_index_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CrabbyConsole.add_custom_command("print_square_list", func(): print(square_list))
	CrabbyConsole.add_custom_command("print_square_count", func(): print(square_list.size()))

func get_square(id: int) -> C_Room_Square:
	var square_index = square_list.find_custom(func(square: C_Room_Square): return square.square_id == id)

	if square_index > -1:
		return square_list[square_index]
	else:
		return null

func update_square_room_id(id: int, new_room_id: int):
	var square = get_square(id)

	if square:
		square.room_id = new_room_id

func update_room_square_data():
	var room_grid: Array[Array] = dungeon_map_component.room_grid

	var max_x = room_grid.size()
	
	for grid_x in max_x:
		var max_y = room_grid[grid_x].size()
		for grid_y in max_y:
			var current_room_instance: C_Room_Square = room_grid[grid_x][grid_y]
			
			if current_room_instance:
				process_room_adjacency_checks(grid_x, grid_y, max_x, max_y)

func process_room_adjacency_checks(grid_x: int, grid_y: int, max_x: int, max_y: int):
	var room_grid: Array[Array] = dungeon_map_component.room_grid

	var north_cell: C_Grid_Room = null
	var east_cell: C_Grid_Room = null
	var south_cell: C_Grid_Room = null
	var west_cell: C_Grid_Room = null
	
	var north_coord = grid_y - 1
	var east_coord = grid_x + 1
	var south_coord = grid_y + 1
	var west_coord = grid_x - 1
	
	var current_room_data_component: C_Grid_Room = room_grid[grid_x][grid_y].c_grid_room
	
	# North
	if north_coord >= 0 and room_grid[grid_x][north_coord]:
		north_cell = room_grid[grid_x][north_coord].c_grid_room
	
	# South
	if south_coord < max_y and room_grid[grid_x][south_coord]:
		south_cell = room_grid[grid_x][south_coord].c_grid_room
	
	# East
	if east_coord < max_x and room_grid[east_coord][grid_y]:
		east_cell = room_grid[east_coord][grid_y].c_grid_room
	
	# West
	if west_coord >= 0 and room_grid[west_coord][grid_y]:
		west_cell = room_grid[west_coord][grid_y].c_grid_room
	
	current_room_data_component.north_cell = north_cell
	current_room_data_component.east_cell = east_cell
	current_room_data_component.south_cell = south_cell
	current_room_data_component.west_cell = west_cell

	room_grid[grid_x][grid_y].c_grid_room = current_room_data_component

func update_door_state(room_1_id: int, room_2_id: int):
	var square_1: C_Room_Square = get_square(room_1_id)
	var square_2: C_Room_Square = get_square(room_2_id)

	var square_1_grid_position = square_1.get_grid_xy()
	var square_2_grid_position = square_2.get_grid_xy()

	var is_room_1_above_room_2 = square_1_grid_position.y < square_2_grid_position.y
	var is_room_1_below_room_2 = square_1_grid_position.y > square_2_grid_position.y
	var is_room_1_left_of_room_2 = square_1_grid_position.x > square_2_grid_position.x
	var is_room_1_right_of_room_2 = square_1_grid_position.x < square_2_grid_position.x

	var square_1_direction = -1
	var square_2_direction = -1

	if is_room_1_above_room_2 or is_room_1_below_room_2:
		if is_room_1_above_room_2:
			square_1_direction = GlobalVariables.cardinal_direction.SOUTH
			square_2_direction = GlobalVariables.cardinal_direction.NORTH
		
		if is_room_1_below_room_2:
			square_1_direction = GlobalVariables.cardinal_direction.NORTH
			square_2_direction = GlobalVariables.cardinal_direction.SOUTH
	else:
		if is_room_1_left_of_room_2:
			square_1_direction = GlobalVariables.cardinal_direction.WEST
			square_2_direction = GlobalVariables.cardinal_direction.EAST

		if is_room_1_right_of_room_2:
			square_1_direction = GlobalVariables.cardinal_direction.EAST
			square_2_direction = GlobalVariables.cardinal_direction.WEST
	
	if square_1_direction != -1 and square_2_direction != -1:
		square_1.update_wall_state(square_1_direction, false)
		square_1.update_door_state(square_1_direction, true)
		square_2.update_wall_state(square_2_direction, false)
		square_2.update_door_state(square_2_direction, true)

func register_square_id(room_square: C_Room_Square) -> int:
	if room_square.square_id == -1:
		room_square.square_id = square_index_count
		square_index_count += 1

		square_list.push_back(room_square)
	
	return room_square.square_id
