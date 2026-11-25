extends Resource
class_name R_Game_Data

var name: String = ""

var player_data: R_Player_Data
var map_data: Dictionary = {}

func set_up(player_name: String) -> void:
	name = player_name
	create_player_data(player_name)

func create_map_data(map_name: String): 
	var new_map_data = R_Map_Data.new()
	map_data.set(map_name, new_map_data)

func create_player_data(player_name: String):
	player_data = R_Player_Data.new()
	player_data.name = player_name

func get_player_grid_position() -> Vector2i:
	return player_data.player_grid_position

func set_player_grid_position(new_position: Vector2i):
	map_data.player_grid_position = new_position

func get_current_player_character_name() -> String:
	return player_data.current_player_character

func set_current_player_character_name(character_name: String):
	player_data.current_player_character = character_name

func get_map_data_entry_by_name(map_data_name: String) -> R_Map_Data:
	if map_data.has(map_data_name):
		return null
	
	return map_data.get(map_data_name)