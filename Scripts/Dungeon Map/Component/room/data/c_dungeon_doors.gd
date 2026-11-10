extends Node
class_name C_Dungeon_Doors

@export var debug_draw: DebugDraw3D

@onready var gui_interaction_point_scene: PackedScene = preload("uid://bvf5kp04u577p")

var dungeon_map_component: C_Dungeon_Map = null

var door_list: Array[Dictionary] = []
var door_index_count: int = 0

var draw_debug = true

func _ready() -> void:
	CrabbyConsole.add_custom_command("print_door_list", func(): print(door_list))
	CrabbyConsole.add_custom_command("print_door_count", func(): print(door_list.size()))
	CrabbyConsole.add_custom_command("draw_door_debug", func(state: String): draw_debug = state == "1")

func _process(_delta: float) -> void:
	if debug_draw and draw_debug:
		var dungeon_squares_component = dungeon_map_component.dungeon_squares_component

		for door_data in door_list:
			var square_1: C_Room_Square = dungeon_squares_component.get_square(door_data.square_id_1)
			var square_2 = dungeon_squares_component.get_square(door_data.square_id_2)

			var line_start_position = square_1.global_position
			var line_end_position = square_2.global_position

			line_start_position.y = 1
			line_end_position.y = 1

			debug_draw.draw_line(
				line_start_position,
				line_end_position,
				Color.WHITE,
				3.0
			)

func create_door_from_ids(room_id_1: int, square_id_1: int, room_id_2: int, square_2_id: int):
	door_list.push_back({
		"room_id_1": room_id_1,
		"square_id_1": square_id_1,
		"room_id_2": room_id_2,
		"square_id_2": square_2_id
	})

func get_doors_with_room_id(room_id: int) -> Array[Dictionary]:
	var return_data = door_list.filter(func(door_entry: Dictionary): return door_entry.room_id_1 == room_id or door_entry.room_id_2 == room_id)

	return return_data

func update_doors_with_new_room_id(room_id: int, new_room_id: int):
	var affected_doors = get_doors_with_room_id(room_id)

	for door_data in affected_doors:
		if door_data.room_id_1 == room_id:
			door_data.room_id_1 = new_room_id
		
		if door_data.room_id_2 == room_id:
			door_data.room_id_2 = new_room_id

func add_door(grid_position: Vector2i):
	var dungeon_rooms_component: C_Dungeon_Rooms = dungeon_map_component.dungeon_rooms_component

	var new_room_data: Dictionary = dungeon_rooms_component.find_room_data_from_grid_position(grid_position)

	# Room added is added to another, traversable room
	var closest_room_ids = dungeon_rooms_component.all_traversable_rooms_ordered_by_distance_to_room(new_room_data.id)

	for closest_room_id in closest_room_ids:
		if new_room_data.id == closest_room_id:
			continue

		if check_rooms_already_have_door(new_room_data.id, closest_room_id):
			continue

		var new_room_is_adjacent = dungeon_rooms_component.check_if_room_1_is_adjacent_to_room_2(new_room_data.id, closest_room_id)

		if new_room_is_adjacent:
			var shortest_distance_squares_data = dungeon_rooms_component.check_shortest_distance_between_room_squares(new_room_data.id, closest_room_id)

			if shortest_distance_squares_data.id_1 != -1 and shortest_distance_squares_data.id_2 != -1:
				create_door_from_ids(new_room_data.id, shortest_distance_squares_data.id_1, closest_room_id, shortest_distance_squares_data.id_2)
			else:
				continue
		else:
			continue

func check_rooms_already_have_door(room_id_1: int, room_id_2: int):
	var found_index = door_list.find_custom(func(entry): return (entry.room_id_1 == room_id_1 and entry.room_id_2 == room_id_2) or (entry.room_id_1 == room_id_2 and entry.room_id_2 == room_id_1))

	# If true, door found
	return found_index != -1

func update_squares_with_doors():
	var dungeon_squares_component: C_Dungeon_Squares = dungeon_map_component.dungeon_squares_component

	for door_data in door_list:
		dungeon_squares_component.update_door_state(door_data.square_id_1, door_data.square_id_2)
		if !door_data.has("interaction_point"):
			create_door_interaction_point(door_data)

func create_door_interaction_point(door_data: Dictionary):
	var dungeon_squares_component: C_Dungeon_Squares = dungeon_map_component.dungeon_squares_component
	var dungeon_rooms_component: C_Dungeon_Rooms = dungeon_map_component.dungeon_rooms_component

	var square_1: C_Room_Square = dungeon_squares_component.get_square(door_data.square_id_1)
	var square_2: C_Room_Square = dungeon_squares_component.get_square(door_data.square_id_2)

	var square_1_grid_position = square_1.position
	var square_2_grid_position = square_2.position

	var new_door_interaction_point: Two_Grid_Pos_Interaction_Point = gui_interaction_point_scene.instantiate()
	dungeon_map_component.room_map_component.interactable_space.add_child(new_door_interaction_point)
	
	new_door_interaction_point.set_up(square_1_grid_position, square_2_grid_position, door_data)

	door_data.set("interaction_point", new_door_interaction_point)

	var current_player_room = dungeon_rooms_component.find_room_data_from_grid_position(PlayerManager.grid_position)

	if current_player_room.id != -1:
		check_if_attached_to_current_room(current_player_room.id)

func check_if_attached_to_current_room(current_room_id: int) -> void:
	for door_data in door_list:
		if door_data.is_empty():
			return
		
		if !door_data.has("interaction_point"):
			return

		var is_attached_to_current_room = door_data.room_id_1 == current_room_id or door_data.room_id_2 == current_room_id

		door_data.interaction_point.set_gui_space_visibility(is_attached_to_current_room)