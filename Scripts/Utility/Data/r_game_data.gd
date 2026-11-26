extends Resource
class_name R_Game_Data

@export var name: String = ""

@export var current_player_character: String = "test"
@export var current_map: String = ""

@export var player_data_list: Dictionary = {}
@export var map_data_list: Dictionary = {}

func set_up(player_name: String) -> void:
	name = player_name
	create_player_data(player_name, current_player_character)

func create_map_data(map_name: String): 
	var new_map_data = R_Map_Data.new()
	map_data_list.set(map_name, new_map_data)

func create_player_data(player_name: String, player_character: String):
	var new_player_data = R_Player_Data.new()
	new_player_data.name = player_name
	player_data_list.set(player_character, new_player_data)

func get_player_grid_position() -> Vector2i:
	var current_player_data: R_Player_Data = player_data_list.get(current_player_character)
	return current_player_data.player_grid_position

func set_player_grid_position(new_position: Vector2i):
	map_data_list.player_grid_position = new_position

func get_current_player_character_name() -> String:
	return current_player_character

func set_current_player_character_name(character_name: String):
	current_player_character = character_name

func get_map_data_entry_by_name(map_data_name: String) -> R_Map_Data:
	if map_data_list.has(map_data_name):
		return null
	
	return map_data_list.get(map_data_name)

func check_for_map_data_entry_by_name(map_data_name: String) -> bool:
	return map_data_list.has(map_data_name)

func set_map_squares_data(map_data_name: String, new_square_list: Array[C_Room_Square], new_square_index_count: int):
	var map_data = get_map_data_entry_by_name(map_data_name)

	if map_data:
		map_data.square_list = new_square_list
		map_data.square_index_count = new_square_index_count

func set_map_room_data(map_data_name: String, new_room_list: Array[Dictionary], new_room_index_count: int):
	var map_data = get_map_data_entry_by_name(map_data_name)

	if map_data:
		map_data.room_list = new_room_list
		map_data.room_index_count = new_room_index_count

func set_map_door_data(map_data_name: String, new_door_list: Array[Dictionary], new_door_index_count: int):
	var map_data = get_map_data_entry_by_name(map_data_name)

	if map_data:
		map_data.door_list = new_door_list
		map_data.door_index_count = new_door_index_count

func set_map_effect_data(map_data_name: String, new_context_list: Array[Dictionary], new_context_index_count: int):
	var map_data = get_map_data_entry_by_name(map_data_name)

	if map_data:
		map_data.active_context_list = new_context_list
		map_data.active_context_index_count = new_context_index_count

func set_map_random_encounter_data(map_data_name: String, new_random_encounter_data: Dictionary):
	var map_data = get_map_data_entry_by_name(map_data_name)

	if map_data:
		var success_threshold_data = new_random_encounter_data.get("success", { "current": 4, "mod": 0 })
		var critical_failure_threshold_data = new_random_encounter_data.get("crit_fail", { "current": 1, "mod": 0 })
		var rolls_per_encounter_check_data = new_random_encounter_data.get("rolls_per_encounter", { "current": 1, "mod": 0 })
		var current_encounter_die = new_random_encounter_data.get("current_encounter_die", 12)
		
		map_data.current_success_threshold = success_threshold_data.current
		map_data.success_threshold_modifier = success_threshold_data.mod

		map_data.current_critical_failure_threshold = critical_failure_threshold_data.current
		map_data.critical_failure_threshold_modifier = critical_failure_threshold_data.mod

		map_data.current_rolls_per_encounter_check = rolls_per_encounter_check_data.current
		map_data.rolls_per_encounter_check_modifier = rolls_per_encounter_check_data.mod

		map_data.current_encounter_die = current_encounter_die