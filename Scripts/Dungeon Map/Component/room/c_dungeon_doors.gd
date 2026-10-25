extends Node
class_name C_Dungeon_Doors

var dungeon_map_component: C_Dungeon_Map = null

var door_list: Array[Dictionary] = []
var door_index_count: int = 0

func _ready() -> void:
	CrabbyConsole.add_custom_command("print_door_list", func(): print(door_list))

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
	var room_with_player_in: Dictionary = dungeon_rooms_component.find_room_data_from_grid_position(PlayerManager.grid_position)

	# Room exists and has been recently added, and is about to gain a door. It should now be made traversable.
	new_room_data.traversable = true

	# Are both rooms actually the same room?
	if new_room_data.id == room_with_player_in.id:
		# Both rooms are the same room, so no need for a door
		return

	if check_rooms_already_have_door(new_room_data.id, room_with_player_in.id):
		return

	# Check if room with player is in is adjacent to the player with 
	if dungeon_rooms_component.check_if_room_1_is_adjacent_to_room_2(new_room_data.id, room_with_player_in.id):
		# Added room next to room with player in
		var shortest_distance_squares_data = dungeon_rooms_component.check_shortest_distance_between_room_squares(new_room_data.id, room_with_player_in.id)

		if shortest_distance_squares_data.id_1 != -1 and shortest_distance_squares_data.id_2 != -1:
			create_door_from_ids(new_room_data.id, shortest_distance_squares_data.id_1, room_with_player_in.id, shortest_distance_squares_data.id_2)
		else:
			return
	else:
		# Room added is added to another, traversable room
		var closest_room_id = dungeon_rooms_component.find_id_of_closest_traversable_room(new_room_data.id)

		if new_room_data.id == closest_room_id:
			return

		if check_rooms_already_have_door(new_room_data.id, closest_room_id):
			return

		if dungeon_rooms_component.check_if_room_1_is_adjacent_to_room_2(new_room_data.id, closest_room_id):
			var shortest_distance_squares_data = dungeon_rooms_component.check_shortest_distance_between_room_squares(new_room_data.id, closest_room_id)

			if shortest_distance_squares_data.id_1 != -1 and shortest_distance_squares_data.id_2 != -1:
				create_door_from_ids(new_room_data.id, shortest_distance_squares_data.id_1, closest_room_id, shortest_distance_squares_data.id_2)
			else:
				return
		else:
			return

func check_rooms_already_have_door(room_id_1: int, room_id_2: int):
	var found_index = door_list.find_custom(func(entry): return (entry.room_id_1 == room_id_1 and entry.room_id_2 == room_id_2) or (entry.room_id_1 == room_id_2 and entry.room_id_2 == room_id_1))

	# If true, door found
	return found_index != -1