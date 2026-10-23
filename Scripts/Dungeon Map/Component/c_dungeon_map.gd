extends Node
class_name C_Dungeon_Map

signal room_data_updated(room_grid: Array[Array])
signal room_list_updated(room_list: Array[Dictionary], square_list: Array[C_Room_Square])

@export var map_data_resource: Map_Data
@export var spacing_x: float = 1.0
@export var spacing_z: float = 1.0

var room_map_component: Room_Map = null

var room_grid: Array[Array]

var room_list: Array[Dictionary] = []
var square_list: Array[C_Room_Square] = []

var room_index_count: int = 0
var square_index_count: int = 0

var full_grid_width = 0
var full_grid_height = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CrabbyConsole.add_custom_command("print_room_list", func(): print(room_list))

func process_room_data() -> void:
	map_data_resource.calculate_room_data()
	var room_map = map_data_resource.map_grid
	
	full_grid_width = room_map.size() * spacing_x
	full_grid_height = room_map[0].size() * spacing_z

	room_map_component.set_up_values(spacing_x, spacing_z, full_grid_width, full_grid_height)
	
	for i in room_map.size():
		room_grid.append([])
		for j in room_map[i].size():
			if room_map[i][j] == GlobalVariables.room_colours.keys()[0]:
				room_grid[i].push_back(null)
			else:
				var room_colour = Global_Variables.room_colours.get(room_map[i][j])
				var room_instance = add_room_square(i, j, room_colour)
				room_grid[i].push_back(room_instance)
	
	update_room_squares()

func update_room_squares():
	update_room_square_data()
	update_room_walls()
	room_data_updated.emit(room_grid)

func add_room_square(x: int, y: int, colour: GlobalVariables.room_colours) -> C_Room_Square:
	return room_map_component.add_room_square(x, y, colour)

func add_room(room_position: Vector2i, room_square_list: Array[Vector2i], colour: GlobalVariables.room_colours):
	var new_room_squares: Array[C_Room_Square] = room_map_component.add_room(room_position, room_square_list, colour)

	for new_room_square in new_room_squares:
		var square_position: Vector2i = new_room_square.get_grid_xy()

		room_grid[square_position.x][square_position.y] = new_room_square
	
	update_room_squares()

func update_room_square_data():
	var max_x = room_grid.size()
	
	for grid_x in max_x:
		var max_y = room_grid[grid_x].size()
		for grid_y in max_y:
			var current_room_instance: C_Room_Square = room_grid[grid_x][grid_y]
			
			if current_room_instance:
				process_room_adjacency_checks(grid_x, grid_y, max_x, max_y)

func update_room_walls():
	var max_x = room_grid.size()

	for grid_x in max_x:
		var max_y = room_grid[grid_x].size()
		for grid_y in max_y:
			var current_room_instance: C_Room_Square = room_grid[grid_x][grid_y]
			
			if current_room_instance:
				current_room_instance.calculate_room_walls()

func process_room_adjacency_checks(grid_x: int, grid_y: int, max_x: int, max_y: int):
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

func register_room_square(room_square: C_Room_Square, matching_neighbours: Array[C_Grid_Room]):
	if room_square.square_id == -1:
		room_square.square_id = square_index_count
		square_index_count += 1

		square_list.push_back(room_square)
	
	if room_square.room_id == -1:
		# Check Neighbours for Room ID
		var neighbour_room_id: int = -1

		for neighbour_grid_square in matching_neighbours:
			var neighbour_square: C_Room_Square = room_grid[neighbour_grid_square.grid_x][neighbour_grid_square.grid_y]
			if neighbour_square.room_id > -1:
				neighbour_room_id = neighbour_square.room_id
				break
		
		if neighbour_room_id > -1:
			room_square.room_id = neighbour_room_id
		else:
			room_square.room_id = room_index_count
			room_index_count += 1
	

	var found_room_square = room_list.find_custom(func(entry: Dictionary): return entry.id == room_square.room_id)

	if found_room_square == -1:
		# Room doesn't exist so make new room
		var new_room_data = {
			"id": room_square.room_id,
			"squares": [
				room_square.square_id
			],
			"colour": room_square.room_colour,
			"traversable": false
		}

		room_list.push_back(new_room_data)
	else:
		# Room does exist, check if already registered
		var check_if_registered = room_list[found_room_square].squares.find(room_square.square_id)

		if check_if_registered == -1:
			room_list[found_room_square].squares.push_back(room_square.square_id)
	
	room_list_updated.emit(room_list, square_list)

func update_current_room_as_traversable_by_grid_position(grid_position: Vector2i):
	var considered_room_square: C_Room_Square = room_grid[grid_position.x][grid_position.y]

	if considered_room_square and not room_list[considered_room_square.room_id].traversable:
		room_list[considered_room_square.room_id].traversable = true

		room_list_updated.emit(room_list, square_list)