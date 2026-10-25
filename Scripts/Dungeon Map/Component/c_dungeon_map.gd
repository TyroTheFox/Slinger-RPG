extends Node
class_name C_Dungeon_Map

signal room_data_updated(room_grid: Array[Array])
signal room_list_updated(room_list: Array[Dictionary], square_list: Array[C_Room_Square])

@export var map_data_resource: Map_Data
@export var spacing_x: float = 1.0
@export var spacing_z: float = 1.0

@export var dungeon_squares_component: C_Dungeon_Squares
@export var dungeon_rooms_component: C_Dungeon_Rooms
@export var dungeon_doors_component: C_Dungeon_Doors

var room_map_component: Room_Map = null

var room_grid: Array[Array]

var full_grid_width = 0
var full_grid_height = 0

func _ready() -> void:
	dungeon_doors_component.dungeon_map_component = self
	dungeon_rooms_component.dungeon_map_component = self
	dungeon_squares_component.dungeon_map_component = self

func get_room_list() -> Array[Dictionary]:
	return dungeon_rooms_component.room_list

func get_squares_list() -> Array[C_Room_Square]:
	return dungeon_squares_component.square_list

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
				var room_instance = create_room_square(i, j, room_colour)
				room_grid[i].push_back(room_instance)
				dungeon_squares_component.register_square_id(room_instance)
	
	update_room_squares()
	dungeon_rooms_component.scan_room_grid_for_room_shapes()
	room_data_updated.emit(room_grid)
	room_list_updated.emit(dungeon_rooms_component.room_list, dungeon_squares_component.square_list)

func update_room_squares():
	dungeon_squares_component.update_room_square_data()
	dungeon_rooms_component.update_room_walls()
	
func create_room_square(x: int, y: int, colour: GlobalVariables.room_colours) -> C_Room_Square:
	return room_map_component.create_room_square(x, y, colour)

func add_room(room_position: Vector2i, room_square_list: Array[Vector2i], colour: GlobalVariables.room_colours):
	var new_room_squares: Array[C_Room_Square] = room_map_component.add_room(room_position, room_square_list, colour)

	for new_room_square in new_room_squares:
		var square_position: Vector2i = new_room_square.get_grid_xy()

		room_grid[square_position.x][square_position.y] = new_room_square

		dungeon_squares_component.register_square_id(new_room_square)
	
	update_room_squares()

	dungeon_rooms_component.register_shapes_to_room_id(new_room_squares)

	room_data_updated.emit(room_grid)

func add_door_to_room(grid_position: Vector2i):
	dungeon_doors_component.add_door(grid_position)

func update_room_as_traversable_by_grid_position(grid_position: Vector2i):
	dungeon_rooms_component.update_room_as_traversable_by_grid_position(grid_position)
