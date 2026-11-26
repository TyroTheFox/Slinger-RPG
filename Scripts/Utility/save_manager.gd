extends Node
class_name G_Save_Manager

var game_data: R_Game_Data

func create_game_data(save_file_name: String):
	game_data = R_Game_Data.new()
	game_data.set_up(save_file_name)
	game_data.name = save_file_name
	GameManager.set_current_encounter_data()

# // PLAYER //

func get_current_player_data_resource() -> R_Player_Data:
	return game_data.player_data_list.get(game_data.current_player_character)

func get_player_grid_position() -> Vector2i:
	return game_data.get_player_grid_position()

func set_player_grid_position(new_position: Vector2i):
	game_data.set_player_grid_position(new_position)

func get_current_player_character_name() -> String:
	return game_data.get_current_player_character_name()

func set_current_player_character_name(character_name: String):
	game_data.set_current_player_character_name(character_name)

# // MAP //

func set_current_map(map_name: String):
	game_data.current_map = map_name

func get_current_map() -> String:
	return game_data.current_map

func create_new_map_data_entry(map_data_name: String):
	game_data.create_map_data(map_data_name)

func get_map_data_dictionary() -> Dictionary:
	return game_data.map_data_list

func get_map_data_entry_by_name(map_data_name: String) -> R_Map_Data:
	return game_data.get_map_data_entry_by_name(map_data_name)

func check_for_map_data_entry_by_name(map_data_name: String) -> bool:
	return game_data.check_for_map_data_entry_by_name(map_data_name)

func set_map_squares_data(map_data_name: String, new_square_list: Array[C_Room_Square], new_square_index_count: int):
	game_data.set_map_squares_data(map_data_name, new_square_list, new_square_index_count)

func set_map_room_data(map_data_name: String, new_room_list: Array[Dictionary], new_room_index_count: int):
	game_data.set_map_room_data(map_data_name, new_room_list, new_room_index_count)

func set_map_door_data(map_data_name: String, new_door_list: Array[Dictionary], new_door_index_count: int):
	game_data.set_map_door_data(map_data_name, new_door_list, new_door_index_count)

func set_map_effect_data(map_data_name: String, new_context_list: Array[Dictionary], new_context_index_count: int):
	game_data.set_map_effect_data(map_data_name, new_context_list, new_context_index_count)

func set_map_random_encounter_data(map_data_name: String, new_random_encounter_data: Dictionary):
	game_data.set_map_random_encounter_data(map_data_name, new_random_encounter_data)

# // FILE SAVING

func save_data():
	var save_file_name = game_data.name
	var file_path: String = GlobalVariables.save_file_path + save_file_name + ".tres"
	
	var save_status = ResourceSaver.save(game_data, file_path)

	if save_status == OK:
		print("DATA SAVED SUCCESSFULLY")
	else:
		print("DATA SAVE FAILED - Error " + str(save_status))

func load_data(save_file_name: String) -> bool:
	var file_path: String = GlobalVariables.save_file_path + save_file_name
	
	var saved_data: R_Game_Data = ResourceLoader.load(file_path, "", ResourceLoader.CacheMode.CACHE_MODE_IGNORE)
	
	if saved_data:
		game_data = saved_data
		return true
	
	return false

func get_all_save_data_file_names() -> PackedStringArray:
	var save_file_names = DirAccess.get_files_at(GlobalVariables.save_file_path)

	return save_file_names