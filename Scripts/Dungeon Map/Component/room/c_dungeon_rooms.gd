extends Node
class_name C_Dungeon_Rooms

var dungeon_map_component: C_Dungeon_Map = null

var room_list: Array[Dictionary] = []
var room_index_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CrabbyConsole.add_custom_command("print_room_list", func(): print(room_list))
	CrabbyConsole.add_custom_command("print_room_count", func(): print(room_list.size()))

func update_room_walls():
	var room_grid: Array[Array] = dungeon_map_component.room_grid

	var max_x = room_grid.size()

	for grid_x in max_x:
		var max_y = room_grid[grid_x].size()
		for grid_y in max_y:
			var current_room_instance: C_Room_Square = room_grid[grid_x][grid_y]
			
			if current_room_instance:
				current_room_instance.calculate_room_walls()

func scan_room_grid_for_room_shapes():
	var room_grid: Array[Array] = dungeon_map_component.room_grid.duplicate_deep()

	scan_pass(room_grid, dungeon_map_component.room_grid)

func scan_pass(room_grid_copy: Array[Array], room_grid: Array[Array]):
	var new_room_squares: Array[C_Room_Square] = []
	var first_room_square: C_Room_Square

	var max_x = room_grid_copy.size()

	for grid_x in max_x:
		var max_y = room_grid_copy[grid_x].size()
		for grid_y in max_y:
			var current_room_instance: C_Room_Square = room_grid_copy[grid_x][grid_y]
			
			if current_room_instance:
				first_room_square = current_room_instance
				new_room_squares.push_back(current_room_instance)
				break

		if first_room_square: 
			break
	
	for new_room_square in new_room_squares:
		var matching_neighbours = new_room_square.matching_neighbours

		for matching_neighbour in matching_neighbours:
			var neighbour_square: C_Room_Square = room_grid[matching_neighbour.grid_x][matching_neighbour.grid_y]
			if new_room_squares.find_custom(func(square: C_Room_Square): return square.square_id == neighbour_square.square_id) == -1:
				new_room_squares.push_back(neighbour_square)
	
	if new_room_squares.size() > 0:
		register_shapes_to_room_id(new_room_squares)

		for new_room_square in new_room_squares:
			room_grid_copy[new_room_square.get_grid_x()][new_room_square.get_grid_y()] = null
		
		scan_pass(room_grid_copy, room_grid)

func register_shapes_to_room_id(new_room_squares: Array[C_Room_Square]):
	var neighbour_room_ids = search_neighbours_for_room_ids(new_room_squares)
	neighbour_room_ids.sort()

	if neighbour_room_ids.size() != 0:
		for room_square in new_room_squares:
			room_square.room_id = neighbour_room_ids[0]
		
		if neighbour_room_ids.size() > 1:
			merge_rooms_together(neighbour_room_ids)
	else:
		for room_square in new_room_squares:
			room_square.room_id = room_index_count
		room_index_count += 1

	for room_square in new_room_squares:
		var found_room_index = room_list.find_custom(func(entry: Dictionary): return entry.id == room_square.room_id)

		if found_room_index == -1:
			create_new_room_data(room_square)
		else:
			update_existing_room_data(found_room_index, room_square)

func merge_rooms_together(neighbour_room_ids: Array[int]):
	var dungeon_squares_component = dungeon_map_component.dungeon_squares_component
	var dungeon_doors_component = dungeon_map_component.dungeon_doors_component

	# The neighbour IDs are sorted so the lowest, and oldest relevant ID is first
	# Default to this when merging rooms to avoid conflicts
	var oldest_id = neighbour_room_ids.pop_at(0)
	var oldest_room_index = room_list.find_custom(func(room_data: Dictionary): return oldest_id == room_data.id)

	for room_id in neighbour_room_ids:
		var room_index = room_list.find_custom(func(room_entry: Dictionary): return room_id == room_entry.id)
		var room_data: Dictionary = room_list[room_index]

		# Convert all squares Room ID to the newly merged Oldest Room ID
		for room_sqaure_id in room_data.squares:
			var room_square: C_Room_Square = dungeon_squares_component.get_square(room_sqaure_id)

			if room_square:
				dungeon_squares_component.update_square_room_id(room_sqaure_id, oldest_id)
				update_existing_room_data(oldest_room_index, room_square)
		
		dungeon_doors_component.update_doors_with_new_room_id(room_data.id, oldest_id)

		room_list.pop_at(room_index)

func create_new_room_data(room_square: C_Room_Square):
	# Room doesn't exist so make new room
	var new_room_data = {
		"id": room_square.room_id,
		"squares": [
			room_square.square_id
		],
		"colour": room_square.room_colour,
		"traversable": false,
		"width": 1,
		"height": 1,
		"x": room_square.get_grid_x(),
		"y": room_square.get_grid_y()
	}

	room_list.push_back(new_room_data)

func update_existing_room_data(found_room_index: int, room_square: C_Room_Square):
	var dungeon_squares_component: C_Dungeon_Squares = dungeon_map_component.dungeon_squares_component
	var square_list: Array[C_Room_Square] = dungeon_squares_component.square_list

	# Room does exist, check if already registered
	var room_data = room_list[found_room_index]
	var check_if_registered = room_data.squares.find(room_square.square_id)

	if check_if_registered == -1:
		var smallest_x = room_square.get_grid_x()
		var smallest_y = room_square.get_grid_y()
		var largest_x = room_square.get_grid_x()
		var largest_y = room_square.get_grid_y()

		# Attempt to figure out the bounds of the shape
		for square_id in room_data.squares:
			var current_room_square = square_list[square_id]
			if current_room_square.get_grid_x() < smallest_x:
				smallest_x = current_room_square.get_grid_x()
			
			if current_room_square.get_grid_x() > largest_x:
				largest_x = current_room_square.get_grid_x()
			
			if current_room_square.get_grid_y() < smallest_y:
				smallest_y = current_room_square.get_grid_y()
			
			if current_room_square.get_grid_y() > largest_y:
				largest_y = current_room_square.get_grid_y()

		var new_width = largest_x - smallest_x + 1
		var new_height = largest_y - smallest_y + 1

		room_list[found_room_index].width = new_width
		room_list[found_room_index].height = new_height

		room_list[found_room_index].x = smallest_x
		room_list[found_room_index].y = smallest_y

		room_list[found_room_index].squares.push_back(room_square.square_id)

func search_neighbours_for_room_ids(new_room_squares: Array[C_Room_Square]) -> Array[int]:
	var room_grid: Array[Array] = dungeon_map_component.room_grid

	# Check Neighbours for Room ID
	var neighbour_room_ids: Array[int] = []

	for room_square in new_room_squares:
		var matching_neighbours = room_square.matching_neighbours

		for neighbour_grid_square in matching_neighbours:
			var neighbour_square: C_Room_Square = room_grid[neighbour_grid_square.grid_x][neighbour_grid_square.grid_y]
			# If Neighbour has a Room ID and matches colour, set that as the Room ID
			if neighbour_square.room_id > -1:
				neighbour_room_ids.push_back(neighbour_square.room_id)

	return neighbour_room_ids

func find_id_of_closest_traversable_room(new_room_id: int) -> int:
	var new_room_data = room_list[new_room_id]
	var first_room_data = room_list[0]

	if new_room_data.id == first_room_data.id:
		return new_room_id
	
	var new_room_corner_position = Vector2i(new_room_data.x, new_room_data.y)
	var room_first_corner_position = Vector2i(first_room_data.x, first_room_data.y)

	var shortest_distance_between_rooms = new_room_corner_position.distance_to(room_first_corner_position)
	var return_room_id = first_room_data.id

	for room_data in room_list:
		var room_corner_position = Vector2i(room_data.x, room_data.y)
		var distance_between_rooms = new_room_corner_position.distance_to(room_corner_position)

		if shortest_distance_between_rooms > distance_between_rooms:
			shortest_distance_between_rooms = distance_between_rooms
			return_room_id = room_data.id

	return return_room_id

func check_if_room_1_is_adjacent_to_room_2(room_id_1: int, room_id_2: int) -> bool:
	var room_1_data = room_list[room_id_1]
	var room_2_data = room_list[room_id_2]

	var room_1_corner_position = Vector2i(room_1_data.x, room_1_data.y)
	var room_2_corner_position = Vector2i(room_2_data.x, room_2_data.y)

	var distance_between_points = room_1_corner_position.distance_to(room_2_corner_position)

	var x_distance_between_corners = find_pythagoras_short_size(room_1_data.width, distance_between_points)
	var y_distance_between_corners = find_pythagoras_short_size(room_1_data.height, distance_between_points)

	return x_distance_between_corners <= room_1_data.width and y_distance_between_corners <= room_1_data.height

func check_shortest_distance_between_room_squares(room_id_1: int, room_id_2: int) -> Dictionary:
	var dungeon_squares_component: C_Dungeon_Squares = dungeon_map_component.dungeon_squares_component
	var square_list: Array[C_Room_Square] = dungeon_squares_component.square_list

	var return_data = { "id_1": -1, "id_2": -1}

	var room_1_data = room_list[room_id_1]
	var room_2_data = room_list[room_id_2]

	var room_1_first_square_position = square_list[room_1_data.squares[0]].get_grid_xy()
	var room_2_first_square_position = square_list[room_2_data.squares[0]].get_grid_xy()

	var shortest_distance: float = room_1_first_square_position.distance_to(room_2_first_square_position)
	var square_1_id = -1
	var square_2_id = -1

	for room_1_square_id in room_1_data.squares:
		var room_1_square = square_list[room_1_square_id]

		for room_2_square_id in room_2_data.squares:
			var room_2_square = square_list[room_2_square_id]

			var room_1_square_position = room_1_square.get_grid_xy()
			var room_2_square_position = room_2_square.get_grid_xy()

			var distance_between_squares: float = room_1_square_position.distance_to(room_2_square_position)

			if shortest_distance > distance_between_squares:
				shortest_distance = distance_between_squares
				square_1_id = room_1_square.square_id
				square_2_id = room_2_square.square_id
	
	return_data.id_1 = square_1_id
	return_data.id_2 = square_2_id

	return return_data

func update_room_as_traversable_by_grid_position(grid_position: Vector2i):
	var considered_room_square_data = find_room_data_from_grid_position(grid_position)

	if considered_room_square_data.id != -1 and not considered_room_square_data.traversable:
		room_list[considered_room_square_data.id].traversable = true

func find_room_data_from_grid_position(grid_position: Vector2i) -> Dictionary:
	var room_grid: Array[Array] = dungeon_map_component.room_grid

	var return_data = { "id": -1 }
	var considered_room_square: C_Room_Square = room_grid[grid_position.x][grid_position.y]
	var room_index = room_list.find_custom(func(room_data: Dictionary): return considered_room_square.room_id == room_data.id)

	if considered_room_square and room_list[room_index]:
		return_data = room_list[room_index]
	
	return return_data

func find_pythagoras_short_size(known_side_a: float, hypotenuse: float):
	var short_side_squared = absf((hypotenuse*hypotenuse) - (known_side_a*known_side_a))

	return sqrt(short_side_squared)
